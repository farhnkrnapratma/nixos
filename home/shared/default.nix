{ config, ... }:
{
  imports = [
    ./programs
    ./packages.nix
  ];

  home.stateVersion = "26.05";
}
