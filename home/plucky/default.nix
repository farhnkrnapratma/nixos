{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./programs
    ./packages.nix
  ];

  home = rec {
    username = "plucky";
    homeDirectory = "/home/${username}";
  };
  services.gpg-agent = {
    enable = true;
    enableFishIntegration = lib.mkIf config.programs.fish.enable true;
    noAllowExternalCache = true;
    pinentry.package = pkgs.pinentry-all;
  };
}
