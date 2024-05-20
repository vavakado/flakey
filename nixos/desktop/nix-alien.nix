{ self, system, pkgs, ... }: {
  environment.systemPackages = with self.inputs.nix-alien.packages.${system}; [
    nix-alien
  ];
}
