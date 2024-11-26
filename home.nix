{
  lib,
  pkgs,
  unstable,
  config,
  nixgl,
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
        gnupg
        black
        isort
        leiningen
        ripgrep
        brave
        vscode
        alejandra
      ])
      ++ (with unstable; [
        neovim
        clojure-lsp
      ]);

    # This needs to actually be set to your username
    username = (import ./user.nix).username;
    homeDirectory = (import ./user.nix).homeDirectory;

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
