{
  nixgl,
  unstable,
  config,
  pkgs,
  lib,
  ...
}: {
  nixGL.packages = nixgl;
  nixGL.defaultWrapper = "nvidia";

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
