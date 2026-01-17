{
  config,
  lib,
  pkgs,
  ...
}:
{
  services.gpg-agent = {
    enable = true;
    enableFishIntegration = lib.mkIf config.programs.fish.enable true;
    noAllowExternalCache = true;
    pinentry.package = pkgs.pinentry-all;
  };
}
