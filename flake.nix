{
  description = "A flake for my NixOS and Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixos-hardware,
      home-manager,
    }:
    let
      nixos-config = ./configuration.nix;
      pkgs = nixpkgs.legacyPackages.${system};
      system = "x86_64-linux";
      users-config = {
        sharedModules = [ (import ./home/shared) ];
        users.plucky = import ./home/plucky;
      };
    in
    {
      nixosConfigurations.puffin = nixpkgs.lib.nixosSystem {
        system = system;
        modules = [
          nixos-config
          nixos-hardware.nixosModules.lenovo-thinkpad-t480s
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              backupCommand = "${pkgs.trash-cli}/bin/trash";
              backupFileExtension = "bak";
              overwriteBackup = true;
              useGlobalPkgs = true;
              useUserPackages = true;
              verbose = true;
            }
            // users-config;
          }
        ];
      };
    };
}
