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
      bilibili-mpv          = pkgs.callPackage ./bilibili-mpv {};
      material-osc          = pkgs.callPackage ./material-osc {};
    };
  in {
    overlays.default = final: prev: {
      maple-mono = prev.maple-mono // {
        NFPropo-CN = final.callPackage ./maple-mono.NFPropo-CN {};
      };
      bilibili-mpv = final.callPackage ./bilibili-mpv {};
      material-osc = final.callPackage ./material-osc {};
    };

    packages = forAllSystems (system:
      mkPackages nixpkgs.legacyPackages.${system}
    );

    legacyPackages = self.packages;

    formatter = forAllSystems (system:
      nixpkgs.legacyPackages.${system}.nixfmt-rfc-style
    );
  };
}
