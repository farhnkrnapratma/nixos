{
  description = "A flake for my NixOS and Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    treefmt-nix.url = "github:numtide/treefmt-nix";
  };

  outputs =
    {
      self,
      nixpkgs,
      nixos-hardware,
      home-manager,
      treefmt-nix,
    }:
    let
      system = "x86_64-linux";
      nixos-config = import ./configuration.nix;
      pkgs = nixpkgs.legacyPackages.${system};
      users-config = {
        sharedModules = [ (import ./home-manager-shared.nix) ];
        users.plucky = import ./home-manager.nix;
      };
      treefmtEval = treefmt-nix.lib.evalModule pkgs ./treefmt.nix;
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
      formatter.${system} = treefmtEval.config.build.wrapper;
      checks.${system}.formatting = treefmtEval.config.build.check self;
    };
}
