{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [ ./programs ];

  home = rec {
    username = "plucky";
    homeDirectory = "/home/${username}";
    packages = with pkgs; [
      amberol
      appflowy
      baobab
      blanket
      equibop
      exercise-timer
      github-copilot-cli
      keypunch
      localsend
      newsflash
      onlyoffice-desktopeditors
      planify
      resources
      shortwave
      showtime
      signal-desktop
      spotify
      telegram-desktop
    ];
  };
  services.gpg-agent = {
    enable = true;
    enableFishIntegration = lib.mkIf config.programs.fish.enable true;
    noAllowExternalCache = true;
    pinentry.package = pkgs.pinentry-all;
  };
}
