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
    { self
    , nixpkgs
    , nixos-hardware
    , home-manager
    , treefmt-nix
    ,
    }:
    let
      arch = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${arch};
      treefmtEval = treefmt-nix.lib.evalModule pkgs ./treefmt.nix;
    in
    {
      nixosConfigurations.puffin = nixpkgs.lib.nixosSystem {
        system = arch;
        modules = [
          (import ./configuration.nix)
          nixos-hardware.nixosModules.lenovo-thinkpad-t480s
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              backupCommand = "${pkgs.trash-cli}/bin/trash";
              backupFileExtension = "bak";
              overwriteBackup = true;
              sharedModules = [ (import ./home/shared.nix) ];
              useGlobalPkgs = true;
              users.plucky = import ./home/plucky/home.nix;
              useUserPackages = true;
              verbose = true;
            };
          }
        ];
      };
      formatter.${arch} = treefmtEval.config.build.wrapper;
      checks.${arch}.formatting = treefmtEval.config.build.check self;
    };
}
