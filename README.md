## Install nix
https://nixos.org/download/

```
sh <(curl -L https://nixos.org/nix/install) --daemon
```

For now just put this in `~/.config/nix/nix.conf`
```
experimental-features = nix-command flakes
```
