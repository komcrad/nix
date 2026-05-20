.PHONY: linux
linux:
	nix run home-manager/master -- switch --flake .#linux --impure

.PHONY: mac
mac:
	nix run home-manager/master -- switch --flake .#mac

.PHONY: work
work:
	nix run home-manager/master -- switch --flake .#work

.PHONY: clean
clean:
	nix-collect-garbage -d

.PHONY: update
update:
	nix flake update nixpkgs

