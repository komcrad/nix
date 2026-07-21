{
  stdenvNoCC,
  fetchzip,
  makeWrapper,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "kotlin-lsp";
  version = "262.8190.0";

  # Only the aarch64-darwin standalone distribution is fetched/hashed here.
  # JetBrains publishes separate archives per platform; add another fetchzip
  # + case branch if/when this needs to run on Linux or Intel Macs.
  src = fetchzip {
    url = "https://download-cdn.jetbrains.com/language-server/kotlin-server/${finalAttrs.version}/kotlin-server-${finalAttrs.version}-aarch64.sit";
    # The archive is a zip despite the .sit extension; tell fetchzip how to unpack it.
    extension = "zip";
    hash = "sha256-3lR3rnjFtjC16NEW7NuMRgy/2ulqNsWo5iz9Eht8+B0=";
  };

  nativeBuildInputs = [makeWrapper];

  # The archive is a self-contained, relocatable IntelliJ-platform distribution
  # (bundled JBR, native launcher that finds it via a relative path), so it
  # just needs to be copied into place and have its entry point put on PATH.
  installPhase = ''
    mkdir -p $out/share
    cp -r . $out/share/
    makeWrapper $out/share/bin/intellij-server $out/bin/intellij-server
  '';
})
