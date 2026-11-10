{
  lib,
  stdenvNoCC,
  fetchurl,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "miku-cursors";
  version = "1.2.6";

  src = fetchurl {
    url = "https://github.com/supermariofps/hatsune-miku-windows-linux-cursors/releases/download/${finalAttrs.version}/miku-cursor-linux.tar.xz";
    hash = "sha256-ahPuw5KJN1dbw1Q1QQ8nZBDImSRdDKmMf54cwj8fJok=";
  };

  sourceRoot = "miku-cursor-linux";

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/icons/miku-cursor-linux
    cp -r cursors index.theme cursor.theme $out/share/icons/miku-cursor-linux/

    runHook postInstall
  '';

  meta = {
    description = "Hatsune Miku cursor theme for Windows and Linux";
    homepage = "https://github.com/supermariofps/hatsune-miku-windows-linux-cursors";
    # 上游没有 LICENSE 文件，作者说明原作者已无法追溯，故按不可自由分发处理。
    license = lib.licenses.unfree;
    platforms = lib.platforms.linux;
  };
})
