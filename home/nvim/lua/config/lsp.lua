-- LSP setup (Neovim 0.11+ API)

-- Completion capabilities (optional)
local capabilities = vim.lsp.protocol.make_client_capabilities()
local ok_cmp, cmp_lsp = pcall(require, "cmp_nvim_lsp")
if ok_cmp then
  capabilities = cmp_lsp.default_capabilities(capabilities)
end

-- Helper: define+enable a server only if its binary exists
local function setup_if_present(server, opts)
  opts = opts or {}
  -- if opts.cmd is set, check that binary; otherwise check the server name
  local cmd = (opts.cmd and opts.cmd[1]) or server
  if vim.fn.executable(cmd) ~= 1 then
    return
  end
  -- merge capabilities
  opts.capabilities = vim.tbl_deep_extend("force", opts.capabilities or {}, capabilities)
  -- define/extend the config, then enable it for its filetypes
  vim.lsp.config(server, opts)
  vim.lsp.enable(server)
end

-- Servers (enabled only when present on PATH)
setup_if_present("lua_ls", {
  settings = {
    Lua = {
      diagnostics = { globals = { "vim" } },
      workspace = { checkThirdParty = false },
    },
  },
})
setup_if_present("r_language_server", {
  cmd = { "R", "--slave", "-e", "languageserver::run()" },
})
setup_if_present("bashls")
setup_if_present("pyright")
setup_if_present("jsonls")
setup_if_present("yamlls")
setup_if_present("html")
setup_if_present("cssls")
setup_if_present("nixd")
setup_if_present("clangd")
setup_if_present("texlab")
setup_if_present("ocamllsp")
setup_if_present("baml_ls", {
  cmd = { "baml-cli", "lsp" },
  filetypes = { "baml" },
  root_markers = { "baml_src", "pyproject.toml", "flake.nix", ".git" },
})
