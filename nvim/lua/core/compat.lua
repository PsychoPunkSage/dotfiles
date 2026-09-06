-- Compatibility shims for Neovim API churn.
--
-- Loaded from init.lua *before* lazy.nvim so plugins see the patched APIs.
-- Every shim here is guarded: once the running Neovim gains the real API the
-- shim becomes a no-op and can be deleted.

-- vim.lsp.codelens.enable(bool, opts)
--
-- ray-x/go.nvim (lua/go/codelens.lua) calls this on BufRead/InsertLeave/
-- BufWritePre for *.go and *.mod. It only exists in newer nvim 0.12 dev
-- builds; on older 0.12-dev / 0.11 it is nil, which throws:
--   codelens.lua:59: attempt to call field 'enable' (a nil value)
-- Emulate it with the refresh/clear pair that has always existed.
if vim.lsp and vim.lsp.codelens and vim.lsp.codelens.enable == nil then
  ---@param enable boolean|nil true (or nil) to show lenses, false to clear them
  ---@param opts table|nil { bufnr = integer, client_id = integer }
  vim.lsp.codelens.enable = function(enable, opts)
    opts = opts or {}
    local bufnr = opts.bufnr
    if bufnr == 0 or bufnr == nil then
      bufnr = vim.api.nvim_get_current_buf()
    end
    if not vim.api.nvim_buf_is_valid(bufnr) then
      return
    end
    if enable == false then
      vim.lsp.codelens.clear(opts.client_id, bufnr)
    else
      vim.lsp.codelens.refresh { bufnr = bufnr }
    end
  end
end
