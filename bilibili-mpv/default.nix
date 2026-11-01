{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  python3,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "mpv-bilibiliAssert";
  version = "1";

  src = fetchFromGitHub {
    owner = "itKelis";
    repo  = "MPV-Play-BiliBili-Comments";
    rev   = "main";
    hash  = "sha256-gUHjQU7fZYih5wkRFeTToJQ3yJo43eEe0RxsI76VMm8=";
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/mpv/scripts
    cp -r scripts/bilibiliAssert $out/share/mpv/scripts/

    substituteInPlace $out/share/mpv/scripts/bilibiliAssert/main.lua \
      --replace-fail \
        'python_path = "python",' \
        'python_path = "${python3}/bin/python3",'

    chmod +x $out/share/mpv/scripts/bilibiliAssert/Danmu2Ass.py
    patchShebangs $out/share/mpv/scripts/bilibiliAssert

    runHook postInstall
  '';

  passthru.scriptName = "bilibiliAssert";

  meta = {
    description = "MPV script for BiliBili comments";
    homepage = "https://github.com/itKelis/MPV-Play-BiliBili-Comments";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
  };
})
