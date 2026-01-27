{
  description = "A flake for my NixOS and Home Manager configuration";

  inputs = {
    self.submodules = true;
    nixpkgs.url = "github:NixOS/nixpkgs/master";
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
    }@inputs:
    let
      arch = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${arch};
      treefmtModule =
        { pkgs
        , ...
        }:

        {
          projectRootFile = "flake.nix";
          programs.nixpkgs-fmt.enable = true;
        };
      treefmtEval = treefmt-nix.lib.evalModule pkgs treefmtModule;
    in
    {
      nixosConfigurations.puffin = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        system = arch;
        modules = [ ./configuration.nix ];
      };
      formatter.${arch} = treefmtEval.config.build.wrapper;
      checks.${arch}.formatting = treefmtEval.config.build.check self;
    };
}
