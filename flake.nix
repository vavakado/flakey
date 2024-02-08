{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nixpkgs, home-manager }:
    let system = "x86_64-linux";
    in {
      nixosConfigurations = {
        nixuwu = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit self system; };

          modules = [
            ./nixos/laptop/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.vavakado = import ./nixos/laptop/home.nix;
            }
          ];
        };
        nixpc = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit self system; };

          modules = [
            ./nixos/desktop/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.vavakado = import ./nixos/desktop/home.nix;
            }
          ];
        };
      };
    };
}
