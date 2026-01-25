{ config
, lib
, ...
}:
let
  WhenFishEnabled =
    { config, lib, ... }:
    lib.mkIf config.programs.fish.enable {
      programs.ghostty.enableFishIntegration = true;
    };
in
{
  imports = [
    WhenFishEnabled
    ./fish.nix
    ./ghostty.nix
  ];
}
