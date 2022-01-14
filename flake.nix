{
  description = "A basic linode configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/release-21.11";

    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, ... }@inputs:
  with inputs;
  {
    packages.x86_64-linux = {
      linode-img = nixos-generators.nixosGenerate {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        modules = [
          nixpkgs.nixosModules.notDetected
          ./configuration.nix
          ./hardware-configuration.nix
        ];
        format = "raw";
      };

      linode-compressed =
      let
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
      in
        pkgs.stdenvNoCC.mkDerivation {
          name = "linode-compressed-image.img.gz";

          src = self.packages.x86_64-linux.linode-img;

          unpackPhase = ''
            # Copy over source file
            cp $src/nixos.img ./nixos.img
          '';

          # gzip is thankfully provided by stdenv
          buildPhase = ''
            # Compress with gzip
            gzip ./nixos.img
          '';

          installPhase = ''
            # Copy produced file
            cp ./nixos.img.gz $out
          '';
        };
    };

    defaultPackage.x86_64-linux = self.packages.x86_64-linux.linode-compressed;
  };
}
