{ config, pkgs, ... }:
{
    fonts.packages = with pkgs; [
        adwaita-fonts
        jetbrains-mono
    ];
}
