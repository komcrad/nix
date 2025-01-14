## Install nix
https://nixos.org/download/

```
sh <(curl -L https://nixos.org/nix/install) --daemon
```

For now just put this in `~/.config/nix/nix.conf`
```
experimental-features = nix-command flakes
```

## MacOS upgrade
Add the following back to `/etc/zshrc`
```
# Nix
if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
  source '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
fi
# End Nix
```
