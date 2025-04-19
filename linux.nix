{
  nixgl,
  unstable,
  config,
  pkgs,
  ...
}: {
  nixGL.packages = nixgl.packages;

  programs.kitty =
    import ./kitty.nix
    // {
      package = config.lib.nixGL.wrap unstable.kitty;
    };

  home = {
    packages = with pkgs; [
      ollama-cuda
    ];
  };
}
