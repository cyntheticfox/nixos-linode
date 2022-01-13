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
    packages.x86_64-linux.linode = nixos-generators.nixosGenerate {
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      modules = [
        nixpkgs.nixosModules.notDetected
        ./configuration.nix
        ./hardware-configuration.nix
      ];
      format = "raw";
    };

    defaultPackage.x86_64-linux = self.packages.x86_64-linux.linode;
  };
}
