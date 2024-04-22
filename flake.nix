{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nix-citizen.url = "github:LovingMelody/nix-citizen";
    neorg-overlay.url = "github:nvim-neorg/nixpkgs-neorg-overlay";
  };

  outputs = { self, nixpkgs, home-manager, nix-citizen, neorg-overlay }@inputs:
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
          specialArgs = { inherit inputs; };

          modules = [ ./nixos/desktop/configuration.nix ];
        };
      };
      homeConfigurations.vavakado = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.${system};
        modules =
          [ ./nixos/desktop/home.nix ];
      };
    };
}
