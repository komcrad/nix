{
  nixgl,
  unstable,
  config,
  ...
}: {
  nixGL.packages = nixgl.packages;
  programs.kitty =
    import ./kitty.nix
    // {
      package = config.lib.nixGL.wrap unstable.kitty;
    };

  home = {
    packages = [
    ];
  };
}
