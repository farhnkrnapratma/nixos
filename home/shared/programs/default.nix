{ config, lib, ... }:
let
  WhenFishEnabled =
    { config, lib, ... }:
    lib.mkIf config.programs.fish.enable {
      programs = {
        starship = {
          enableFishIntegration = true;
          enableTransience = true;
        };
        ghostty.enableFishIntegration = true;
      };
    };
in
{
  imports = [
    WhenFishEnabled
    ./fastfetch.nix
    ./firefox.nix
    ./fish.nix
    ./ghostty.nix
    ./starship.nix
  ];
}
