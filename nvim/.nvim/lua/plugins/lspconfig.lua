local goModuleName = function()
  local f = io.open("go.mod", "rb")
  if f then
    f:close()
  else
    return nil
  end
  for line in io.lines("go.mod") do
    if vim.startswith(line, "module") then
      local items = vim.split(line, " ")
      return vim.trim(items[2])
    end
  end
  return nil
end

return {
  "nvim-lspconfig",
  opts = {
    inlay_hints = { enabled = false },
    servers = {
      gopls = {
        settings = {
          gopls = {
            ["local"] = goModuleName(),
          },
        },
      },
    },
  },
}
