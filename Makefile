.PHONY: linux
linux:
	nix run home-manager/release-24.11 -- switch --flake .#linux --impure

.PHONY: framework
framework:
	nix run home-manager/release-24.11 -- switch --flake .#framework --impure

.PHONY: mac
mac:
	nix run home-manager/release-24.11 -- switch --flake .#mac

.PHONY: work
work:
	nix run home-manager/release-24.11 -- switch --flake .#work

.PHONY: clean
clean:
	nix-collect-garbage -d
