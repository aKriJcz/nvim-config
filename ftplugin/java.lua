local wkey = require("which-key")
local lsp = require('plugins/lsp')

-- Java
vim.g.syntastic_java_checkers = {}
local jdtls = require('jdtls')
local root_markers = {'settings.gradle', 'settings.gradle.kts', '.git', 'mvnw'}
-- Fall back to the file's directory for standalone files outside any project.
local root_dir = vim.fs.root(0, root_markers) or vim.fn.expand('%:p:h')
local home = os.getenv('HOME')

local project_name = vim.fn.fnamemodify(root_dir, ':p:h:t')
if (project_name == 'trunk') then -- For SVN style projects
  project_name = vim.fn.fnamemodify(root_dir, ':p:h:h:t')
end
local workspace_folder = home .. "/.local/share/jdt.ls/" .. project_name
local config_folder = home .. "/.local/share/jdt.ls/config_linux"

-- https://github.com/mfussenegger/nvim-jdtls/issues/38
-- For Gradle only lets remove the .settings folder.
-- Otherwise upon second project opening, buildship cannot detect subprojects.
if vim.uv.fs_stat(root_dir .. "/build.gradle") then
  vim.g['test#java#runner'] = 'gradletest'
  os.execute("rm -rf " .. root_dir .. "/.project")
end

local on_attach_jdtls = function(client, bufnr)
  lsp.lspdef.on_attach(client, bufnr)

  --jdtls.setup_dap({hotcodereplace = 'auto'})
  jdtls.setup_dap()

  wkey.add {
    { "<Leader>dt", group = "Test", buffer = bufnr },
    { "<Leader>dta", function() require('jdtls').test_class() end,          desc = "Test class", buffer = bufnr },
    { "<Leader>dti", function() require('jdtls').test_nearest_method() end, desc = "Test method", buffer = bufnr },
    { "<Leader>lo", function() require('jdtls').organize_imports() end,     desc = "Organize imports", buffer = bufnr },
  }

  -- https://github.com/mfussenegger/nvim-dap/issues/446
  vim.api.nvim_create_user_command('DapDebugPrepare', require('jdtls.dap').setup_dap_main_class_configs, {})
  vim.api.nvim_create_user_command('JdtUpdateConfig', jdtls.update_project_config, {})
end

-- The command that starts the language server
-- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
-- jdtls-lombok is a wrapper running jdtls with the Lombok agent.
local cmd = {
  'jdtls-lombok',
  '-data', workspace_folder,
  '-configuration', config_folder,
}

-- Paths to java-debug and vscode-java-test jars are generated.
-- See https://github.com/mfussenegger/nvim-jdtls#java-debug-installation
local bundles = {}
local ok, generated = pcall(require, 'generated.jdtls')
if ok then
  vim.list_extend(bundles, vim.fn.glob(generated.debug_dir .. "/com.microsoft.java.debug.plugin-*.jar", true, true))
  -- These two jars must not be loaded as bundles (see nvim-jdtls README).
  local excluded = {
    ["com.microsoft.java.test.runner-jar-with-dependencies.jar"] = true,
    ["jacocoagent.jar"] = true,
  }
  for _, jar in ipairs(vim.fn.glob(generated.test_dir .. "/*.jar", true, true)) do
    if not excluded[vim.fn.fnamemodify(jar, ':t')] then
      table.insert(bundles, jar)
    end
  end
else
  vim.notify("generated.jdtls not found, java-debug and java-test are disabled", vim.log.levels.WARN)
end

local jdtls_config = {
  capabilities = lsp.lspdef.capabilities,
  on_attach = on_attach_jdtls,
  cmd = cmd,

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
      -- https://www.reddit.com/r/neovim/comments/1n2ex0r/receive_help_on_typing_during_the_java_stream/
      eclipse = {
        downloadSources = true,
        downloadJavadoc = true,
      },
      referencesCodeLens = { enabled = true },
      implementationsCodeLens = { enabled = true },
      inlayHints = {
        parameterNames = { enabled = "all" },
      },
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

  -- Language server `initializationOptions`
  init_options = {
    bundles = bundles,
    extendedClientCapabilities = jdtls.extendedClientCapabilities,
  },
}

-- This starts a new client & server,
-- or attaches to an existing client & server depending on the `root_dir`.
jdtls.start_or_attach(jdtls_config)
