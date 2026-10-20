{
  description = "Neovim config of jirka, with the Neovim package it runs with";

  # Standalone:
  #   git clone github.com:aKriJcz/nvim-config ~/.config/nvim
  #   nix profile install ~/.config/nvim   # config read live from ~/.config/nvim
  #   nix run github:aKriJcz/nvim-config#pure   # config baked in, no clone needed
  # Trying plugin/tool changes from the checkout, without home-manager:
  #   nix run ~/.config/nvim   (new files must be `git add`ed to be seen)
  # home-manager: import homeModules.default and set my.neovim.enable.

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
    let
      lib = nixpkgs.lib;
      systems = [ "x86_64-linux" "aarch64-linux" ];

      # Unfree plugins in nix/neovim.nix. Exported for configs reusing their own nixpkgs.
      unfreePackages = [ "cmp-emoji" "vim-closetag" "git-conflict.nvim" "vim2hs" "vim-hoogle" ];

      mkNeovim = import ./nix/neovim.nix;
    in {
      lib = { inherit mkNeovim unfreePackages; };

      packages = lib.genAttrs systems (system:
        let
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfreePackages = unfreePackages;
          };
        in rec {
          default = mkNeovim { inherit pkgs; };
          minimal = mkNeovim { inherit pkgs; full = false; withPerl = false; };
          pure = mkNeovim { inherit pkgs; configSrc = self; };
          jdtls-lombok = default.jdtls-lombok;
        });

      homeModules.default = { config, lib, pkgs, ... }:
        let
          cfg = config.my.neovim;
        in {
          options.my.neovim = with lib; {
            enable = mkEnableOption "Neovim with the nvim-config plugins and tools";
            full = mkOption {
              type = types.bool;
              default = true;
              description = "Include LSP servers, debug adapters and other external tools.";
            };
            withPerl = mkOption {
              type = types.bool;
              default = true;
              description = "Enable the Perl provider.";
            };
            extraPerlPackages = mkOption {
              type = types.functionTo (types.listOf types.package);
              default = _: [ ];
              example = literalExpression "ps: [ ps.JSON ]";
              description = "More Perl modules for the Perl provider (:perl, :perldo).";
            };
            pureConfig = mkOption {
              type = types.bool;
              default = false;
              description = ''
                Use the config from this flake's store copy instead of reading ~/.config/nvim live.
                Then config changes need the flake input updated and a rebuild.
              '';
            };
            package = mkOption {
              type = types.package;
              readOnly = true;
              description = "The resulting Neovim package.";
            };
          };

          config = lib.mkIf cfg.enable {
            # Built from the home-manager pkgs, so it follows the system nixpkgs and its unfree settings.
            my.neovim.package = mkNeovim {
              inherit pkgs;
              inherit (cfg) full withPerl extraPerlPackages;
              configSrc = if cfg.pureConfig then self else null;
            };
            home.packages = [ cfg.package ];
          };
        };
    };
}
