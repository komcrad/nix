{pkgs, ...}: {
  programs.kitty = import ./kitty.nix;
  home = {
    packages = [];
  };
}
