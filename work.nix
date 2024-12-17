{pkgs, ...}: {
  programs.kitty =
    import ./kitty.nix
    // {
      font = {
        size = 17;
        name = "Monospace";
      };
    };
  home = {
    packages = [];
  };
}
