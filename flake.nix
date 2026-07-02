{
  description = "A flake for my NixOS and Home Manager configuration";

  inputs = {
    self.submodules = true;
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel";
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
      env = fromTOML (builtins.readFile ./env.toml);
      pkgs = nixpkgs.legacyPackages.${env.system};
      treefmtEval = treefmt-nix.lib.evalModule pkgs {
        projectRootFile = "flake.nix";
        programs = {
          nixfmt.enable = true;
          nixf-diagnose.enable = true;
        };
      };
    in
    {
      checks.${env.system}.formatting = treefmtEval.config.build.check self;
      formatter.${env.system} = treefmtEval.config.build.wrapper;
      nixosConfigurations.${env.network.host} = nixpkgs.lib.nixosSystem {
        system = env.system;
        specialArgs = { inherit inputs; };
        modules = [ ./default.nix ];
      };
      devShells.${env.system}.default = pkgs.mkShellNoCC {
        nativeBuildInputs = with pkgs; [
          just
          shfmt
          shellcheck
        ];
      };
    };
}
