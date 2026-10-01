vim.bo.commentstring = "// %s"
vim.bo.expandtab = true
vim.bo.shiftwidth = 2
vim.bo.tabstop = 2

local function run_baml_cli(args, success_message)
  if vim.fn.executable("baml-cli") ~= 1 then
    vim.notify("baml-cli is not available on PATH", vim.log.levels.WARN)
    return
  end

  if vim.bo.modified then
    vim.cmd.write()
  end

  local result = vim.system(vim.list_extend({ "baml-cli" }, args), { text = true }):wait()
  if result.code ~= 0 then
    local message = result.stderr ~= "" and result.stderr or result.stdout
    vim.notify(message, vim.log.levels.ERROR)
    return
  end

  vim.cmd.edit()
  vim.notify(success_message)
end

vim.api.nvim_buf_create_user_command(0, "BamlFormat", function()
  run_baml_cli({ "fmt", vim.api.nvim_buf_get_name(0) }, "Formatted BAML file")
end, { desc = "Format current BAML file with baml-cli" })

vim.api.nvim_buf_create_user_command(0, "BamlGenerate", function()
  run_baml_cli({ "generate" }, "Generated BAML client")
end, { desc = "Generate baml_client with baml-cli" })
