# Plugins not in nixpkgs (or needing changes), on top of pkgs.vimPlugins.
{ pkgs }:
{
  vim-vdebug = pkgs.vimUtils.buildVimPlugin {
    name = "vim-vdebug";
    src = pkgs.fetchFromGitHub {
      owner = "vim-vdebug";
      repo = "vdebug";
      rev = "f979cc065e63796bdf60f014ae2280ce8e72cded";
      hash = "sha256-0pvRdqogxYs2QMH1uHTJzLY5QtvenSyowcqkGhtauLY=";
    };
  };
  navigator_lua = pkgs.vimUtils.buildVimPlugin {
    name = "navigator_lua";
    src = pkgs.fetchFromGitHub {
      owner = "ray-x";
      repo = "navigator.lua";
      rev = "4ba2c9557ea03243b079cf6c44572e1a6f011abc";
      hash = "sha256-BgzYspJPzUV5g6saDJfd3iReGv0Nasy0m+b3blUX7xM=";
    };
  };
  one-small-step-for-vimkind = pkgs.vimUtils.buildVimPlugin {
    name = "one-small-step-for-vimkind";
    src = pkgs.fetchFromGitHub {
      owner = "jbyuki";
      repo = "one-small-step-for-vimkind";
      rev = "113d9d26cc7258ff175a4be12bf161d86b9b1298";
      hash = "sha256-E6Dh9fZxa5SQrWM1PDo+eIwGUyaFMXMj3x1Vl4UDSrU=";
    };
  };
  vim-svelte-plugin = pkgs.vimUtils.buildVimPlugin {
    name = "vim-svelte-plugin";
    src = pkgs.fetchFromGitHub {
      owner = "leafOfTree";
      repo = "vim-svelte-plugin";
      rev = "e0971a037ace074f61703fd8d0cd7feb313690ac";
      hash = "sha256-zmGtguxuOlV/VgEqn8X4Uf/PKQsiW0tqNwiytM7muz8=";
    };
  };
  vim-freemarker = pkgs.vimUtils.buildVimPlugin {
    name = "vim-freemarker";
    src = pkgs.fetchFromGitHub {
      owner = "andreshazard";
      repo = "vim-freemarker";
      rev = "993bda23e72e4c074659970c1e777cb19d8cf93e";
      hash = "sha256-g4GnutHqxOH0rhZZmx7YpqFWZ9a+lTC6SdNYvVrSPbY=";
    };
  };
  nvim-nio = pkgs.vimUtils.buildVimPlugin {
    name = "nvim-nio";
    src = pkgs.fetchFromGitHub {
      owner = "nvim-neotest";
      repo = "nvim-nio";
      rev = "8765cbc4d0c629c8158a5341e1b4305fd93c3a90";
      hash = "sha256-VfoJOXXtMhalFcnfhVzweq7TVmB8WjRP+Z5Z5Z24Pzc=";
    };
  };
  vim-fluffy = pkgs.vimUtils.buildVimPlugin {
    name = "vim-fluffy";
    src = pkgs.fetchFromGitHub {
      owner = "EgZvor";
      repo = "vim-fluffy";
      rev = "75ea11be70e1bc9d845950f5b855c73fc09cbb5c";
      hash = "sha256-59Hink8rBsvFGE2NV9QUxj1a1z1i08HzeMlakYiUbYk=";
    };
  };
  repeatable-motions = pkgs.vimUtils.buildVimPlugin {
    name = "repeatable-motions";
    src = pkgs.fetchurl {
      url = "https://www.vim.org/scripts/download_script.php?src_id=25409";
      name = "repeatable-motions-1.2.zip";
      hash = "sha256-KIbehXZRdaCvQ1g4LgYD4E+fDmOZaF6HsS3cI0MP6HM=";
    };
    buildInputs = [ pkgs.unzip ]; # So unpacker know how to unpack ZIP
    # ZIP contains multiple folders, it is needed to put them in one root
    setSourceRoot = ''
      export sourceRoot=repmot
      mkdir repmot
      mv doc repmot
      mv plugin repmot
      mv after repmot
    '';
    patches = [
      ./patches/00_repeatable-motions-help.patch
      ./patches/01_repeatable-motions-replay-mappings.patch
    ];
    vimPluginGenTags = "";
  };
  cmp-dbee = pkgs.vimUtils.buildVimPlugin {
    name = "cmp-dbee";
    src = pkgs.fetchFromGitHub {
      owner = "MattiasMTS";
      repo = "cmp-dbee";
      rev = "1650f67b9bf43c029fc37570665ca895a33cdf5a";
      hash = "sha256-XxB4jQu9xAi/7XDcwsd0hGLSs74ysjg0N/uaTHjqByI=";
    };
    dependencies = with pkgs.vimPlugins; [ nvim-cmp nvim-dbee ];
    doCheck = false;
  };
}
