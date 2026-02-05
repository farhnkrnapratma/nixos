{
  description = "A flake for my NixOS and Home Manager configuration";

  inputs = {
    self.submodules = true;
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
      treefmt-nix,
      ...
    }@inputs:
    let
      my = import ./Shared;
      pkgs = nixpkgs.legacyPackages.${my.aos};
      treefmtEval = treefmt-nix.lib.evalModule pkgs {
        projectRootFile = "flake.nix";
        programs = {
          nixfmt.enable = true;
          nixf-diagnose.enable = true;
        };
      };
    in
    {
      checks.${my.aos}.formatting = treefmtEval.config.build.check self;
      formatter.${my.aos} = treefmtEval.config.build.wrapper;
      nixosConfigurations.${my.user.host} = nixpkgs.lib.nixosSystem {
        system = my.aos;
        specialArgs = { inherit inputs; };
        modules = [ ./System ];
      };
    };
}
