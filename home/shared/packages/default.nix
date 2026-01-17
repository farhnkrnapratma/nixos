{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    aria2
    bat
    cava
    cosmic-ext-applet-caffeine
    cosmic-ext-applet-privacy-indicator
    cosmic-ext-applet-weather
    eza
    gnome-calculator
    gnome-calendar
    gnome-characters
    gnome-clocks
    khal
    loupe
    nautilus
    papers
    snapshot
    wl-clipboard
    wtype
    yaru-theme
    zoxide
  ];
}
