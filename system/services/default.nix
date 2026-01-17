{ config, pkgs, ... }:

{
  services = {
    desktopManager = {
      cosmic.enable = true;
      cosmic.showExcludedPkgsWarning = false;
      cosmic.xwayland.enable = true;
    };
    displayManager = {
      #cosmic-greeter.enable = true;
      dms-greeter = {
        enable = true;
        package = pkgs.dms-shell;
        compositor.name = "niri";
        configHome = "/home/plucky";
      };
    };
    gnome = {
      evolution-data-server.enable = true;
      gnome-keyring.enable = true;
      sushi.enable = true;
    };
    pipewire = {
      enable = true;
      alsa.enable = true;
      jack.enable = true;
      pulse.enable = true;
    };
    resolved = {
      enable = true;
      settings.Resolve = {
        DNSOverTLS = "opportunistic";
        DNSSEC = "allow-downgrade";
        FallbackDNS = [ "9.9.9.9" ];
      };
    };
  };
}
