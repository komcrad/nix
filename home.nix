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

  programs.kitty = {
    enable = true;
    theme = "Catppuccin-Mocha";
    font.size = 15;
    font.name = "Monospace";
    settings = {
      confirm_os_window_close = -0;
    };
  };

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
        ripgrep
        brave
        vscode
        kitty
        alejandra
      ])
      ++ (with unstable; [
        neovim
        clojure-lsp
        #(lib.hiPrio kitty)
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
