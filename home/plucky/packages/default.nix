{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    amberol
    appflowy
    baobab
    blanket
    discord
    exercise-timer
    github-copilot-cli
    google-chrome
    keypunch
    localsend
    microsoft-edge
    newsflash
    onlyoffice-desktopeditors
    planify
    protonvpn-gui
    resources
    shortwave
    showtime
    signal-desktop
    spotify
    telegram-desktop
  ];
}
