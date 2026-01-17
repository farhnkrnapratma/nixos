{ config, pkgs, ... }:
{
  console = {
    enable = true;
    earlySetup = true;
    font = "ter-v16n";
    keyMap = "us";
    packages = [ pkgs.terminus_font ];
  };
}
