{
  description = "A very basic flake";

  inputs = { nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11"; };

  outputs = { self, nixpkgs }:
    let system = "x86_64-linux";
    in {
      nixosConfigurations = {
        nixuwu = nixpkgs.lib.nixosSystem {
          inherit system;

          modules = [ ./nixos/configuration.nix ];
        };
      };
    };
}
