{
  lib,
  pkgs,
  config,
  ...
}:
{
  services.gpg-agent = lib.mkIf config.programs.gpg.enable rec {
    enable = true;
    enableFishIntegration = config.programs.fish.enable;
    enableSshSupport = true;
    defaultCacheTtl = 3600;
    defaultCacheTtlSsh = defaultCacheTtl;
    extraConfig = ''
      allow-loopback-pinentry
    '';
    grabKeyboardAndMouse = false;
    maxCacheTtl = 7200;
    maxCacheTtlSsh = maxCacheTtl;
    noAllowExternalCache = true;
    pinentry.package = pkgs.pinentry-curses;
    verbose = true;
  };
}
