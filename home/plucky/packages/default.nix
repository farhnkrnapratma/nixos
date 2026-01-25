{ config
, pkgs
, ...
}:
{
  home.packages = with pkgs; [
    amberol
    appflowy
    baobab
    blanket
    discord
    exercise-timer
    github-copilot-cli
    keypunch
    localsend
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
