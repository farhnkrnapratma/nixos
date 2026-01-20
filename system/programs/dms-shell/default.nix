{ config, pkgs, ... }:

{
  programs.dms-shell = {
    enable = true;
    package = pkgs.dms-shell;
    enableAudioWavelength = true;
    enableCalendarEvents = true;
    enableClipboardPaste = true;
    enableSystemMonitoring = true;
    enableDynamicTheming = true;
    enableVPN = true;
    quickshell.package = pkgs.quickshell;
    systemd = {
      enable = true;
      restartIfChanged = true;
      target = "graphical-session.target";
    };
  };
}
