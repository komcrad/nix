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
        jdk17
        clojure
        postgresql
        cljfmt
        open-policy-agent
        stylua
        bazelisk
        rustup
        gnupg
        black
        awscli2
        isort
        regols
        leiningen
        ripgrep
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
      ".cljfmt.edn" = {
        source = ./modules/cljfmt.edn;
      };
      #".zshrc" = {
      #  source = ./modules/zshrc;
      #};
      "bin/bazel" = {
      text = ''
        #!/usr/bin/env bash

        ${pkgs.bazelisk}/bin/bazelisk "$@"
      '';
      };
    };
  };
}
