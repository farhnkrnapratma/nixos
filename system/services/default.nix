{ config, ... }:

{
    services = {
        desktopManager = {
            cosmic.enable = true;
            cosmic.showExcludedPkgsWarning = false;
            cosmic.xwayland.enable = true;
        };
        displayManager.cosmic-greeter.enable = true;
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
            dnsovertls = "opportunistic";
            dnssec = "allow-downgrade";
            fallbackDns = [ "8.8.8.8" ];
        };
    };
}
