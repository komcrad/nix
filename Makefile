.PHONY: update-linux
update-linux:
	nix run home-manager/release-24.05 -- switch --flake .#linux --impure

.PHONY: update-mac
update-mac:
	nix run home-manager/release-24.05 -- switch --flake .#mac

.PHONY: clean
clean:
	nix-collect-garbage -d
