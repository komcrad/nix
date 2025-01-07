{pkgs, unstable, ...}: {
  programs.kitty = import ./kitty.nix;
  home = {
    packages = [
      unstable.colima
      unstable.docker
    ];
  };
}
