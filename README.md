# nvim-config

My Neovim config, together with the Neovim package it runs with (`flake.nix`, `nix/`).
Nix provides the plugins and tools; the config itself is read live from `~/.config/nvim`.

## Editing

- **Lua config changes** need no rebuild, just restart Neovim.
- **Plugin or tool changes** (`nix/neovim.nix`, `nix/plugins.nix`): try them straight from the checkout,
  without a home-manager switch:

  ```sh
  nix run ~/.config/nvim            # full
  nix run ~/.config/nvim#minimal    # no Perl, no LSPs/tools
  nix run ~/.config/nvim#pure       # with the config from the checkout baked in
  ```

  New files must be `git add`ed first, otherwise the flake does not see them.
  When happy, commit, push and update the `nvim-config` input in home-manager (`nix flake update nvim-config`).

## Installing

Standalone (no home-manager):

```sh
git clone git@github.com:aKriJcz/nvim-config.git ~/.config/nvim
nix profile install ~/.config/nvim
```

Or without cloning, with the config baked into the store: `nix run github:aKriJcz/nvim-config#pure`.

home-manager: import `homeModules.default` and set `my.neovim.enable = true`. Options are under `my.neovim`
(`full`, `withPerl`, `extraPerlPackages`, `pureConfig`). Unfree plugins are listed in `lib.unfreePackages`.

## Perl

The Perl provider is optional (`withPerl`). Without it, `lua/perl.lua` and the Perl-only commands are skipped.
