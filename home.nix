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
      "cuda_cudart"
      "libcublas"
      "cuda_cccl"
      "cuda_nvcc"
    ];
  home = {
    packages =
      (with pkgs; [
        clojure
        postgresql
        mariadb
        bash-completion
        cljfmt
        open-policy-agent
        stylua
        bazelisk
        rustup
        csharp-ls
        phpactor
        cmake
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
        logseq
        sops
        age
        zulu21
        gcc
        cljstyle
        geckodriver
        chromedriver
        prettierd
        terraform-ls
        nodejs_20
        nodePackages.typescript
        nodePackages.prettier
        nodePackages.eslint
        nodePackages.eslint_d
        nodePackages.typescript-language-server
        clj-kondo
        libiconv
        intelephense
        neovim
        neovide
        babashka
        bbin
        parinfer-rust
        gnupg
        caddy
        screen
        clojure-lsp
        docker
        docker-compose
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
      ".zshrc" = {
        source = ./modules/zshrc;
      };

      "bin/bazel" = {
        executable = true;
        text = ''
          #!/usr/bin/env bash

          ${pkgs.bazelisk}/bin/bazelisk "$@"
        '';
      };
      "bin/fix-docker" = {
        executable = true;
        text = ''
          #!/usr/bin/env bash
          colima stop
          colima start
          sudo rm /var/run/docker.sock
          sudo ln ~/.colima/default/docker.sock /var/run
        '';
      };
      "bin/setup-clojure-mcp" = {
        executable = true;
        text = ''
          #!/usr/bin/env bash
          set -e

          echo "Installing clojure-mcp-light tools via bbin..."

          # Install the Claude Code hook for paren repair
          bbin install https://github.com/bhauman/clojure-mcp-light.git --tag v0.2.1

          # Install nREPL eval tool
          bbin install https://github.com/bhauman/clojure-mcp-light.git --tag v0.2.1 \
            --as clj-nrepl-eval \
            --main-opts '["-m" "clojure-mcp-light.nrepl-eval"]'

          # Install paren repair CLI tool
          bbin install https://github.com/bhauman/clojure-mcp-light.git --tag v0.2.1 \
            --as clj-paren-repair \
            --main-opts '["-m" "clojure-mcp-light.paren-repair"]'

          echo ""
          echo "clojure-mcp-light tools installed successfully!"
          echo ""
          echo "Available commands:"
          echo "  clj-paren-repair-claude-hook - Hook for Claude Code Write/Edit operations"
          echo "  clj-nrepl-eval               - Evaluate code against an nREPL"
          echo "  clj-paren-repair             - CLI tool for delimiter repair"
          echo ""
          echo "Claude Code settings have been configured at ~/.claude/settings.json"
          echo "Start an nREPL in your project and Claude can evaluate code against it."
        '';
      };
      ".claude/settings.json" = {
        text = builtins.toJSON {
          hooks = {
            PreToolUse = [
              {
                matcher = "Write|Edit";
                hooks = [
                  {
                    type = "command";
                    command = "clj-paren-repair-claude-hook --format pre $TOOL_INPUT";
                  }
                ];
              }
            ];
            PostToolUse = [
              {
                matcher = "Write|Edit";
                hooks = [
                  {
                    type = "command";
                    command = "clj-paren-repair-claude-hook --format post $TOOL_INPUT";
                  }
                ];
              }
            ];
          };
        };
      };
    };
  };
}
