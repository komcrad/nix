{pkgs, ...}: {
  home = {
    packages = [pkgs.nixgl.auto.nixGLNvidia];
  };
}
