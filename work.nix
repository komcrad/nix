{
  pkgs,
  unstable,
  ...
}: {
  programs.kitty =
    import ./kitty.nix
    // {
      font = {
        size = 17;
        name = "Monospace";
      };
    };
  home = {
    packages = let
      php' = pkgs.php82.buildEnv {
        extensions = {
          enabled,
          all,
        }:
          enabled ++ [all.imagick all.gnupg];
        extraConfig = ''
          memory_limit = 16G
        '';
      };
    in
      (with unstable; [
        yarn
        colima
        aerospace
        gnupg
        imagemagick
      ])
      ++ [
        php'
        php'.packages.composer
      ];
  };
}
