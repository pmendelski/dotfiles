local M = {}

local function find_dir_with(start_dir, marker)
  local dir = start_dir
  while dir ~= "/" do
    if vim.fn.filereadable(dir .. "/" .. marker) == 1 then
      return dir
    end
    dir = vim.fn.fnamemodify(dir, ":h")
  end
end

-- Parse Cargo.toml [[test]] sections; return list of {name, path, features} tables.
local function cargo_test_targets(cargo_root)
  local lines = vim.fn.readfile(cargo_root .. "/Cargo.toml")
  local targets, in_test, cur = {}, false, {}
  for _, line in ipairs(lines) do
    if line:match("^%[%[test%]%]") then
      if cur.name then table.insert(targets, cur) end
      in_test, cur = true, {}
    elseif line:match("^%[") then
      if in_test and cur.name then table.insert(targets, cur) end
      in_test, cur = false, {}
    elseif in_test then
      cur.name = line:match('^name%s*=%s*"([^"]+)"') or cur.name
      cur.path = line:match('^path%s*=%s*"([^"]+)"') or cur.path
      if not cur.features then
        local feat_str = line:match('^required%-features%s*=%s*%[([^%]]+)%]')
        if feat_str then
          cur.features = feat_str:gsub('"', ""):gsub("%s*,%s*", " ")
        end
      end
    end
  end
  if in_test and cur.name then table.insert(targets, cur) end
  return targets
end

-- For a file linked into src/ via #[path = "..."], return "mod_name::file_stem", else nil.
local function lib_module_for(file, cargo_root)
  local mod_rs = vim.fn.fnamemodify(file, ":h") .. "/mod.rs"
  if vim.fn.filereadable(mod_rs) == 0 then return nil end

  local mod_rs_rel = mod_rs:sub(#cargo_root + 2)
  local hits = vim.fn.systemlist(
    string.format("grep -rn --include='*.rs' '%s' '%s/src'", mod_rs_rel, cargo_root)
  )
  if #hits == 0 then return nil end

  local src_file, lnum_str = hits[1]:match("^([^:]+):(%d+):")
  if not src_file or not lnum_str then return nil end

  local lines = vim.fn.readfile(src_file)
  local lnum = tonumber(lnum_str)
  for i = lnum + 1, math.min(lnum + 3, #lines) do
    local mod_name = lines[i]:match("^%s*mod%s+([%w_]+)%s*;")
    if mod_name then
      return mod_name .. "::" .. vim.fn.fnamemodify(file, ":t:r")
    end
  end
end

-- For a file under a [[test]] integration target, return (name, mod_path, features).
local function integration_target_for(file, cargo_root)
  local file_rel = file:sub(#cargo_root + 2)
  for _, t in ipairs(cargo_test_targets(cargo_root)) do
    if t.path then
      local norm = t.path:gsub("^%./", "")
      local target_dir = norm:match("^(.+)/[^/]+%.rs$")
      if target_dir and file_rel:sub(1, #target_dir + 1) == target_dir .. "/" then
        local mod_path = file_rel:sub(#target_dir + 2):gsub("%.rs$", ""):gsub("/", "::")
        return t.name, mod_path, t.features
      end
    end
  end
  return nil, nil, nil
end

-- Return the name of the test function nearest to (and above) the cursor.
function M.nearest_test_name()
  for i = vim.fn.line("."), 1, -1 do
    local l = vim.fn.getline(i)
    local name = l:match("^%s*fn%s+([%w_]+)%s*%(") or l:match("[^%w_]fn%s+([%w_]+)%s*%(")
    if name then return name end
  end
end

-- Command to run all tests in a file.
function M.cmd_for_file(file)
  local cargo_root = find_dir_with(vim.fn.fnamemodify(file, ":h"), "Cargo.toml")
  if not cargo_root then return "cargo test -- --nocapture" end

  local lib_mod = lib_module_for(file, cargo_root)
  if lib_mod then
    return "cargo test --lib " .. lib_mod .. " -- --nocapture"
  end

  local src_rel = file:match("/src/(.+)%.rs$")
  if src_rel and src_rel ~= "lib" and src_rel ~= "main" then
    local mod_path = src_rel:gsub("/mod$", ""):gsub("/", "::")
    return "cargo test --lib " .. mod_path .. " -- --nocapture"
  end

  local target, mod_path, features = integration_target_for(file, cargo_root)
  if target then
    local feat = features and (" --features " .. features) or ""
    local filter = mod_path ~= "" and (" " .. mod_path) or ""
    return "cargo test --test " .. target .. feat .. filter .. " -- --nocapture"
  end

  return "cargo test -- --nocapture"
end

-- Command to run a single named test in a file.
function M.cmd_for_test(file, name)
  local cargo_root = find_dir_with(vim.fn.fnamemodify(file, ":h"), "Cargo.toml")
  if not cargo_root then return "cargo test " .. name .. " -- --nocapture" end

  local lib_mod = lib_module_for(file, cargo_root)
  if lib_mod then
    return "cargo test --lib " .. lib_mod .. "::" .. name .. " -- --nocapture"
  end

  local src_rel = file:match("/src/(.+)%.rs$")
  if src_rel and src_rel ~= "lib" and src_rel ~= "main" then
    local mod_path = src_rel:gsub("/mod$", ""):gsub("/", "::")
    return "cargo test --lib " .. mod_path .. "::" .. name .. " -- --nocapture"
  end

  local target, _, features = integration_target_for(file, cargo_root)
  if target then
    local feat = features and (" --features " .. features) or ""
    return "cargo test --test " .. target .. feat .. " " .. name .. " -- --nocapture"
  end

  return "cargo test " .. name .. " -- --nocapture"
end

-- For a directory linked into src/ via #[path], return the top-level mod name, else nil.
-- e.g. tests/unit/images/ -> "images_tests"
local function lib_module_for_dir(dir, cargo_root)
  local mod_rs = dir:gsub("/$", "") .. "/mod.rs"
  if vim.fn.filereadable(mod_rs) == 0 then return nil end

  local mod_rs_rel = mod_rs:sub(#cargo_root + 2)
  local hits = vim.fn.systemlist(
    string.format("grep -rn --include='*.rs' '%s' '%s/src'", mod_rs_rel, cargo_root)
  )
  if #hits == 0 then return nil end

  local src_file, lnum_str = hits[1]:match("^([^:]+):(%d+):")
  if not src_file or not lnum_str then return nil end

  local lines = vim.fn.readfile(src_file)
  local lnum = tonumber(lnum_str)
  for i = lnum + 1, math.min(lnum + 3, #lines) do
    local mod_name = lines[i]:match("^%s*mod%s+([%w_]+)%s*;")
    if mod_name then return mod_name end
  end
end

-- For a directory under an integration test target, return (target_name, mod_path, features).
local function integration_target_for_dir(dir, cargo_root)
  local dir_rel = dir:gsub("/$", ""):sub(#cargo_root + 2)
  for _, t in ipairs(cargo_test_targets(cargo_root)) do
    if t.path then
      local norm = t.path:gsub("^%./", "")
      local target_dir = norm:match("^(.+)/[^/]+%.rs$")
      if target_dir and dir_rel:sub(1, #target_dir + 1) == target_dir .. "/" then
        local mod_path = dir_rel:sub(#target_dir + 2):gsub("/", "::")
        return t.name, mod_path, t.features
      end
    end
  end
  return nil, nil, nil
end

-- Command to run all tests under a directory recursively.
function M.cmd_for_dir(dir)
  local cargo_root = find_dir_with(dir, "Cargo.toml")
  if not cargo_root then return "cargo test -- --nocapture" end

  local lib_mod = lib_module_for_dir(dir, cargo_root)
  if lib_mod then
    return "cargo test --lib " .. lib_mod .. " -- --nocapture"
  end

  local target, mod_path, features = integration_target_for_dir(dir, cargo_root)
  if target then
    local feat = features and (" --features " .. features) or ""
    local filter = mod_path ~= "" and (" " .. mod_path) or ""
    return "cargo test --test " .. target .. feat .. filter .. " -- --nocapture"
  end

  return "cargo test -- --nocapture"
end

return M
