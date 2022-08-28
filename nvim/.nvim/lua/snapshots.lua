local _M = {}
local snapshot_path = vim.fn.stdpath('cache') .. '/packer.nvim/snapshots'
local snapshot_lock_path = snapshot_path .. '/.locked'

vim.cmd(":command PackerSnapshotList :lua require('snapshots').print_snapshots()")
vim.cmd(":command PackerSnapshotRollbackLast :lua require('snapshots').rollback_last()")
vim.cmd(":command PackerSnapshotLock :lua require('snapshots').lock_snapshot()")
vim.cmd(":command PackerSnapshotUnlock :lua require('snapshots').unlock_snapshot()")
vim.cmd(":command PackerSnapshotPath :lua require('snapshots').print_path()")
vim.cmd(":command PackerSnapshotCreate :lua require('snapshots').create_snapshot()")
vim.cmd(":command PackerSnapshotRemove :lua require('snapshots').remove_snapshot()")

local function file_exists(name)
  local f = io.open(name, "r")
  if f ~= nil then
    io.close(f)
    return true
  else
    return false
  end
end

local function list_snapshots()
  local paths = vim.split(vim.fn.glob(snapshot_path .. '/*'), '\n')
  local snapshots = {}
  local idx = 0
  for _, file in pairs(paths) do
    local short = file:sub(#snapshot_path + 2)
    if short:sub(1, 1) ~= '.' then
      snapshots[#paths - idx] = short
      idx = idx + 1
    end
  end
  return snapshots
end

local function remove_oldest_snapshot()
  local snapshots = list_snapshots()
  if #snapshots == 0 then
    return
  end
  local last = snapshots[#snapshots]
  os.remove(snapshot_lock_path .. '/' .. last)
end

local function last_snapshot()
  return list_snapshots()[1]
end

function _M.print_path()
  print(_M.path())
end

function _M.path()
  return snapshot_path
end

function _M.create_snapshot()
  local locked = vim.fn.empty(snapshot_lock_path)
  if locked == 1 then
    return
  end
  local snapshot = "snapshot-" .. os.date('%Y-%m-%d')
  local update = vim.fn.empty(vim.fn.glob(snapshot_path .. "/" .. snapshot))
  if update == 1 then
    vim.cmd("PackerSnapshot " .. snapshot)
    remove_oldest_snapshot()
  end
end

function _M.remove_snapshot()
  local snapshot = "snapshot-" .. os.date('%Y-%m-%d')
  local ok = os.remove(snapshot_lock_path .. '/' .. snapshot)
  if ok == true then
    print("Today's snapshot removed")
  else
    print("No today's snapshot")
  end
end

function _M.has_snapshot()
  local snapshot = "snapshot-" .. os.date('%Y-%m-%d')
  return file_exists(snapshot_path .. "/" .. snapshot)
end

function _M.is_locked()
  return file_exists(snapshot_lock_path)
end

function _M.lock_snapshot()
  local f = io.open(snapshot_lock_path, "w")
  io.write(os.date('%Y-%m-%d'))
  io.close(f)
  print('Packer snapshot locked')
end

function _M.unlock_snapshot()
  local ok = os.remove(snapshot_lock_path)
  if ok == true then
    print('Packer snapshot unlocked')
  else
    print('Packer snapshot already unlocked')
  end
end

function _M.rollback_last()
  local packer = require('packer')
  local last = last_snapshot()
  if last ~= nil then
    packer.rollback(last)
    print("Rollbacked packer snapshot: " .. last)
  else
    print("No snapshot found")
  end
end

function _M.print_snapshots()
  local snapshots = list_snapshots()
  for _, snapshot in pairs(snapshots) do
    print(snapshot)
  end
end

return _M
