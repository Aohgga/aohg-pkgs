{
  lib,
  python3,
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
    ${python3}/bin/python3 ${./fix-cmap.py} $out/share/fonts/otb $src/*.otb
    runHook postInstall
  '';

  meta = {
    description = "WenQuanYi Bitmap Song CJK bitmap font, 9/10/11/12pt strikes with Unicode cmap";
    homepage = "http://wenq.org/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
}
