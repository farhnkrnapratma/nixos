{ config, ... }:

{
    system = {
        autoUpgrade = {
            enable = true;
            allowReboot = true;
            dates = "daily";
            fixedRandomDelay = true;
            flags = [
                "--update-input"
                "nixpkgs"
                "--commit-lock-file"
            ];
            flake = "/etc/nixos";
            operation = "switch";
            randomizedDelaySec = "10min";
            rebootWindow = {
                lower = "01:00";
                upper = "05:00";
            };
            runGarbageCollection = true;
        };
        stateVersion = "26.05";
    };
}
