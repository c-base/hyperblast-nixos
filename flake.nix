{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
  outputs =
    { self, nixpkgs, ... }:
    let
      eachSystem =
        f: nixpkgs.lib.attrsets.genAttrs [ "x86_64-linux" ] (system: f nixpkgs.legacyPackages.${system});
    in
    {
      packages = eachSystem (pkgs: {
        relaxx = pkgs.callPackage ./packages/relaxx { };
      });
      nixosModules = {
        hyperblast = import ./modules/hyperblast.nix;
      };
      nixosConfigurations = rec {
        hyperblastng =
          let
            system = "x86_64-linux";
          in
          nixpkgs.lib.nixosSystem {
            specialArgs = {
              selfpkgs = self.packages.${system};
            };
            modules = [
              self.nixosModules.hyperblast
              ./machines/hyperblast/config.nix
            ];
          };
        hyperblast = hyperblastng;
      };
    };
}
