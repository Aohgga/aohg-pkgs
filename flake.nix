{
  description = "Aohg's personal Nix package collection";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, ... }:
  let
    supportedSystems = [ "x86_64-linux" ];
    forAllSystems = nixpkgs.lib.genAttrs supportedSystems;

    mkPackages = pkgs: {
      maple-mono.NFPropo-CN = pkgs.callPackage ./maple-mono.NFPropo-CN {};
      yaru                  = pkgs.callPackage ./yaru {};
      bilibili-mpv          = pkgs.callPackage ./bilibili-mpv {};
    };
  in {
    overlays.default = final: _prev: mkPackages final;

    packages = forAllSystems (system:
      mkPackages nixpkgs.legacyPackages.${system}
    );

    legacyPackages = self.packages;

    formatter = forAllSystems (system:
      nixpkgs.legacyPackages.${system}.nixfmt-rfc-style
    );
  };
}
