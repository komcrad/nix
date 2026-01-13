{
  nixgl,
  unstable,
  config,
  pkgs,
  lib,
  ...
}: {
  nixGL.packages = nixgl;
  nixGL.defaultWrapper = "mesa";

  programs.kitty =
    import ./kitty.nix
    // {
      package = config.lib.nixGL.wrap unstable.kitty;
    };

  home = {
    packages = with pkgs; [
      ollama
    ];
    sessionVariables = {
      LD_LIBRARY_PATH = "${unstable.stdenv.cc.cc.lib}/lib:$LD_LIBRARY_PATH";
    };
  };
}
