local wkey = require("which-key")
local lsp = require('plugins/lsp')

-- Java
vim.g.syntastic_java_checkers = {}
local jdtls = require('jdtls')
local root_markers = {'settings.gradle', 'settings.gradle.kts', '.git', 'mvnw'}
local root_dir = require('jdtls.setup').find_root(root_markers)
local home = os.getenv('HOME')

local project_name = vim.fn.fnamemodify(root_dir, ':p:h:t')
if (project_name == 'trunk') then
  project_name = vim.fn.fnamemodify(root_dir, ':p:h:h:t')
end
local workspace_folder = home .. "/.local/share/jdt.ls/" .. project_name
local config_folder = home .. "/.local/share/jdt.ls/config_linux"
--local workspace_folder = root_dir .. "/workspace"

-- https://github.com/mfussenegger/nvim-jdtls/issues/38
-- For Gradle only lets remove the .settings folder.
-- Otherwise upon second project opening, buildship cannot detect subprojects.
if root_dir ~= nil then
  local f = io.open(root_dir .. "/build.gradle","r")
  if f ~= nil then
    io.close(f)
    -- vim.g['test#java#runner'] = 'gradletest'
    vim.api.nvim_exec([[
           let test#java#runner = 'gradletest'
           ]], true)
    os.execute("rm -rf " .. root_dir .. "/.project")
    --if workspace_folder ~= nil then
    --  os.execute("rm -rf " .. workspace_folder .. "/jdt.ls-java-project/.settings")
    --end
  end
end


local dap = require("dap")
-- TODO: deduplikovat!
local on_attach_jdtls = function(client, bufnr)
  local opts = { noremap=true, silent=true }

  lsp.lspdef.on_attach(client, bufnr)

  -- Enable completion triggered by <c-x><c-o>
  --vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  --jdtls.setup_dap({hotcodereplace = 'auto'})
  jdtls.setup_dap()
  --jdtls.setup.add_commands()

  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<Leader>o', '<Cmd>lua require"jdtls".organize_imports()<CR>', opts)

  wkey.register {
    ["<Leader>dta"] = { ":lua require'jdtls'.test_class()<CR>",           "Test class" },
    ["<Leader>dti"] = { ":lua require'jdtls'.test_nearest_method()<CR>",  "Test method" },
  }

  -- https://github.com/mfussenegger/nvim-dap/issues/446
  vim.api.nvim_create_user_command('DapDebugPrepare', require('jdtls.dap').setup_dap_main_class_configs, {})
  -- https://github.com/mfussenegger/nvim-jdtls

  --vim.api.nvim_create_user_command('JdtlsDeleteWorkspace', '<cmd>call termopen("rm ")', {})

  --aerial.on_attach(client, bufnr)
  vim.api.nvim_create_user_command('JdtUpdateConfig', jdtls.update_project_config, {})
end

--map("n", "<Leader>dta", "<cmd>lua require'jdtls'.test_class()<CR>")
--map("n", "<Leader>dti", "<cmd>lua require'jdtls'.test_nearest_method()<CR>")
--map("n", "<F6>", "<cmd>lua require'dap'.step_over()<CR>")
--map("n", "<F7>", "<cmd>lua require'dap'.step_into()<CR>")
--map("n", "<F8>", "<cmd>lua require'dap'.step_out()<CR>")
--map("n", "<Leader>dee", "<cmd>lua vim.diagnostic.open_float()<CR>")
--map("n", "<Leader>def", "<cmd>lua vim.diagnostic.setqflist()<CR>")

local jdtls_config = {
  capabilities = lsp.lspdef.capabilities,
  -- The command that starts the language server
  -- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
  cmd = { 'jdtls', '-data', workspace_folder, '-configuration', config_folder },

  -- This is the default if not provided, you can remove it. Or adjust as needed.
  -- One dedicated LSP server & client will be started per unique root_dir
  root_dir = root_dir,

  -- Here you can configure eclipse.jdt.ls specific settings
  -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
  -- for a list of options
  settings = {
    java = {
      signatureHelp = { enabled = true };
      --contentProvider = { preferred = 'fernflower' };
      codeGeneration = {
        generateComments = true,
        toString = {
          template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}"
        },
        hashCodeEquals = {
          useJava7Objects = true,
        },
        useBlocks = true,
      };
      --configuration = {
      --  runtimes = {
      --    {
      --      name = "JavaSE-1.8",
      --      path = home .. "/.nixpkgs/local-builds/openjdk8/",
      --    },
      --    {
      --      name = "JavaSE-11",
      --      path = home .. "/.nixpkgs/local-builds/openjdk11/lib/openjdk/",
      --    },
      --    {
      --      name = "JavaSE-17",
      --      path = home .. "/.nixpkgs/local-builds/openjdk17/lib/openjdk/",
      --    },
      --  }
      --};
    }
  },
}
jdtls_config.on_attach = on_attach_jdtls -- TODO: proč nefunguje?
local bundles = {
  vim.fn.glob("/home/jirka/pgm/java/java-debug/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-*.jar"),
}
vim.list_extend(bundles, vim.split(vim.fn.glob("/home/jirka/pgm/java/vscode-java-test/server/*.jar", true), "\n"))

-- Language server `initializationOptions`
-- You need to extend the `bundles` with paths to jar files
-- if you want to use additional eclipse.jdt.ls plugins.
--
-- See https://github.com/mfussenegger/nvim-jdtls#java-debug-installation
jdtls_config['init_options'] = {
  bundles = bundles,
  extendedClientCapabilities = jdtls.extendedClientCapabilities,
}

--print(vim.inspect(jdtls_config))
--print(vim.inspect(jdtls_config))

-- This starts a new client & server,
-- or attaches to an existing client & server depending on the `root_dir`.
jdtls.start_or_attach(jdtls_config)
