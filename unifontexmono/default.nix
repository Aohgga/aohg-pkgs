{
  lib,
  stdenvNoCC,
  fetchurl,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "unifontexmono";
  version = "unstable-c926e9a";

  src = fetchurl {
    url = "https://raw.githubusercontent.com/stgiga/UnifontEX/c926e9a579f5a908149eec1d7b728d1a306d36a9/UnifontExMono.otb";
    hash = "sha256-on0hVwd1aqHn6UKmuxikqE1a+P3RRLhQ5/UGtZ9EKo0=";
  };

  dontUnpack = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/fonts/otb
    cp $src $out/share/fonts/otb/UnifontExMono.otb
    runHook postInstall
  '';

  meta = {
    description = "Extended fork of GNU Unifont, monospace bitmap variant";
    homepage = "https://github.com/stgiga/UnifontEX";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
})
