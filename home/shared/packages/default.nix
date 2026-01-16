{ config, pkgs, ... }:
{
    home.packages = with pkgs; [
        aria2
        bat
        cosmic-ext-applet-caffeine
        cosmic-ext-applet-privacy-indicator
        cosmic-ext-applet-weather
        eza
        gnome-calculator
        gnome-calendar
        gnome-characters
        gnome-clocks
        loupe
        nautilus
        papers
        snapshot
        wl-clipboard
        yaru-theme
        zoxide
    ];
}
