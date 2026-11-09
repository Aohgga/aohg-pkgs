{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  python3,
}:

let
  python = python3.withPackages (ps: [ ps.fonttools ]);
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "material-osc";
  version = "0.0.14-unstable-2026-11-09";

  src = fetchFromGitHub {
    owner = "brahmkshatriya";
    repo = "material-osc";
    rev = "ddfeeb3a0c81fad6762bc94252103d4e30dd0926";
    hash = "sha256-2IY0MGVhztld+hiN/N2XMibyy0UeJnTAE5DCD/h9GXM=";
  };

  # MD3E patch: opaque MD3 panels, Chinese UI, smaller close dot,
  # measured text metrics, 120fps animation restore.
  patches = [ ./material-osc-md3e.patch ];

  nativeBuildInputs = [ python ];

  dontConfigure = true;

  buildPhase = ''
    runHook preBuild
    ${python}/bin/python3 bundle.py 0.0.14
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -Dm644 build/0.0.14/scripts/material-osc.lua \
      $out/share/mpv/scripts/material-osc/main.lua
    install -Dm644 build/0.0.14/fonts/* \
      -t $out/share/mpv/scripts/material-osc/fonts
    runHook postInstall
  '';

  passthru.scriptName = "material-osc";

  meta = {
    description = "Material Design OSC for mpv with MD3E opaque theme and Chinese UI";
    homepage = "https://github.com/brahmkshatriya/material-osc";
    # Upstream ships no LICENSE file; package kept in a private user repo.
    platforms = lib.platforms.linux;
  };
})
