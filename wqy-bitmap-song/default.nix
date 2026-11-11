{
  lib,
  stdenvNoCC,
}:

stdenvNoCC.mkDerivation {
  pname = "wqy-bitmap-song";
  version = "1.0.0";

  src = ./fonts;

  dontBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/fonts/otb
    cp $src/*.otb $out/share/fonts/otb/
    runHook postInstall
  '';

  meta = {
    description = "WenQuanYi Bitmap Song CJK bitmap font, 10/11/12pt strikes";
    homepage = "http://wenq.org/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
}
