{
  lib,
  pkgs,
  unstable,
  ...
}: {
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "vscode"
      "nvidia"
    ];
  home = {
    packages =
      (with pkgs; [
        jdk11
        clojure
        stylua
        rustup
        black
        isort
        leiningen
        nixgl.auto.nixGLNvidia # TODO this needs to be host specific
        ripgrep
        vscode
        alejandra
      ])
      ++ (with unstable; [
        neovim
        clojure-lsp
      ]);

    # This needs to actually be set to your username
    username = "<username>";
    homeDirectory = "<home>";

    # You do not need to change this if you're reading this in the future.
    # Don't ever change this after the first build.  Don't ask questions.
    stateVersion = "24.05";
    file = {
      "bin/nix-setup.sh" = {
        executable = true;
        text = ''
          #!/bin/bash
          curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
          https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
        '';
      };
      ".config/nvim" = {
        recursive = true;
        source = ./modules/nvim;
      };
    };
  };
}
