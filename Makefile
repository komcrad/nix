.PHONY: update
update:
	nix run home-manager/release-24.05 -- switch --flake .#komcrad --impure

.PHONY: clean
clean:
	nix-collect-garbage -d
