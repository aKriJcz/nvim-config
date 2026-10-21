# Neovim wrapped with the plugins (and optionally tools) this config uses.
#
# The config itself is read live from stdpath('config') (~/.config/nvim) by default,
# so changes to it need no rebuild. Only plugin and tool changes do.
{ pkgs
, full ? true                  # LSP servers, debug adapters and other external tools
, withPerl ? true              # Perl provider (:perl, :perldo, lua/perl.lua)
, extraPerlPackages ? (_: [ ]) # More modules for the Perl provider, like for perl.withPackages
, configSrc ? null             # Config baked into the store instead of the live one
}:
let
  lib = pkgs.lib;
  # The Java bits follow unstable where an `unstable` overlay is present (home-manager).
  unstable = pkgs.unstable or pkgs;

  custom = import ./plugins.nix { inherit pkgs; };

  grammars = [ "awk" "bash" "bibtex" "c" "c_sharp" "cmake" "cpp" "css" "csv" "diff" "dockerfile" "dot" "git_config" "git_rebase" "gitcommit" "gitignore" "gnuplot" "gpg" "haskell" "html" "ini" "java" "javascript" "jq" "json" "json5" "kotlin" "latex" "lua" "make" "markdown" "muttrc" "nix" "passwd" "perl" "pod" "printf" "properties" "python" "regex" "ruby" "rust" "scala" "sql" "ssh_config" "strace" "svelte" "tmux" "typescript" "udev" "unison" "vim" "xml" "xresources" "yaml" "zathurarc" "zig" ];

  plugins = with pkgs.vimPlugins; with custom; [
    vim-nix # Support for nix language
    which-key-nvim # Key bindings
    nvim-tree-lua # File browser
    lualine-nvim # airline
    aerial-nvim
    vim-surround vim-repeat
    repeatable-motions
    nerdcommenter # Vim plugin for intensely orgasmic commenting.
    nvim-web-devicons #"vim-devicons"
    vim-fugitive
    vim-quickrun
    vim-markdown
    cmp-emoji
    rainbow-delimiters-nvim
    vim-obsession
    vim-visual-multi
    tagbar
    vim-closetag # Auto close (X)HTML tags
    pear-tree #delimitMate # closing brackets,parentheses,...
    vim-matchup
    nvim-cmp cmp-buffer cmp-path cmp-nvim-lua
    vim-vsnip cmp-vsnip vim-vsnip-integ
    vim-unimpaired
    vim-qf
    vim-signify

    #(nvim-treesitter.withPlugins ( plugins: with plugins; nvim-treesitter.allGrammars ))
    # Grammars missing in the nixpkgs used are skipped (unstable dropped muttrc, tmux and zathurarc).
    (nvim-treesitter.withPlugins ( plugins: map (g: plugins.${g}) (builtins.filter (g: plugins ? ${g}) grammars) ))
      #nvim-treesitter-refactor # Problematic - freezes nvim
      nvim-treesitter-textobjects
      nvim-treesitter-context
      #playground # Archived. What is alternative?

    git-conflict-nvim

    nvim-jdtls
    fzf-lua # file fuzzy finder
    csv-vim
    NrrwRgn
    vim2hs vim-hoogle
    vimtex
    CheckAttach
    syntastic # Automatic syntax checking.
    #nvim-gdb # GDB and BashDB integration
    zig-vim
    nvim-lspconfig
    cmp-nvim-lsp
    lspsaga-nvim
    vim-shellcheck
    zeavim-vim
    nvim-dap nvim-dap-ui nvim-dap-virtual-text nvim-nio
    #telescope-nvim telescope-fzf-writer-nvim telescope-dap-nvim telescope-lsp-handlers-nvim telescope-ui-select-nvim
    trouble-nvim
    neodev-nvim
    vim-sleuth
    one-small-step-for-vimkind
    vim-svelte-plugin vim-freemarker #typescript-vim
    vim-fluffy
    #copilot-lua copilot-cmp
    claudecode-nvim
    orgmode org-roam-nvim
    nvim-dbee cmp-dbee
    { plugin = vim-vdebug; optional = true; }
  ];

  jdtls-lombok = pkgs.callPackage ./jdtls-lombok.nix { inherit (unstable) jdt-language-server; };

  tools = with pkgs; [
    boxes
    xdotool
    libxml2
    html-tidy
    jq
    shellcheck-minimal
    python3Packages.sqlparse
    python3Packages.msgpack # kvůli deoplete
    zls
    jdtls-lombok
    #haskell-language-server
    nixd deadnix
    lua-language-server
    vim-language-server
    bash-language-server
    vscode-langservers-extracted # HTML/CSS/JSON
    texlab # || ltex-ls || zeta_note
    clang-tools # || ccls
    #zk
    #perl perlPackages.PLS perlcritic # perlnavigator || perlls
    perl-debug-adapter
    fzf
    pandoc
    #java-debug
    svelte-language-server
    typescript-language-server

    # arduino_language_server
    # jedi_language_server || pylsp || pyright
    # awk_ls
    # gradle-language-server ?
    # vscode-html-language-server ?
    # lemminx ?
  ];

  # Store paths the config needs, available as vim.g.nix in Lua.
  nixValues = lib.optionalAttrs full {
    jdtls = {
      debug_dir = "${unstable.vscode-extensions.vscjava.vscode-java-debug}/share/vscode/extensions/vscjava.vscode-java-debug/server";
      test_dir = "${unstable.vscode-extensions.vscjava.vscode-java-test}/share/vscode/extensions/vscjava.vscode-java-test/server";
    };
  };

  configDir =
    if configSrc == null then "vim.fn.stdpath('config')"
    else lib.generators.toLua { } "${configSrc}";

  # The baked-in config replaces the live one in runtimepath, so a ~/.config/nvim
  # on the machine cannot interfere with it.
  pureRtp = lib.optionalString (configSrc != null) ''
    vim.opt.rtp:remove(vim.fn.stdpath('config'))
    vim.opt.rtp:remove(vim.fn.stdpath('config') .. '/after')
    vim.opt.rtp:prepend(${configDir})
    vim.opt.rtp:append(${configDir} .. '/after')
  '';

  wrapNeovimUnstable =
    if withPerl then
      pkgs.wrapNeovimUnstable.override {
        # The wrapper builds its Perl env with perl.withPackages, add our modules to it.
        perl = pkgs.perl // {
          withPackages = f: pkgs.perl.withPackages (ps:
            f ps
            ++ [ ps.HTMLParser ] # HTML::Entities in lua/perl.lua
            ++ extraPerlPackages ps
          );
        };
      }
    else pkgs.wrapNeovimUnstable;

  nvim = wrapNeovimUnstable pkgs.neovim-unwrapped {
    vimAlias = true;
    inherit withPerl plugins;
    luaRcContent = ''
      vim.g.nix = ${lib.generators.toLua { } nixValues}
      ${pureRtp}
      local init = ${configDir} .. '/init.lua'
      if vim.fn.filereadable(init) == 1 then
        vim.cmd.source(init)
      else
        vim.notify(init .. ' not found, clone the nvim-config repo there', vim.log.levels.WARN)
      end
    '';
  };
in
pkgs.buildEnv {
  name = "myvim" + lib.optionalString (!full) "-minimal" + lib.optionalString (configSrc != null) "-pure";
  paths = [ nvim ] ++ lib.optionals full tools;
  passthru = { inherit nvim jdtls-lombok; };
  meta.mainProgram = "nvim";
}
