{ config, pkgs, ... }:

{
    boot = {
        consoleLogLevel = 7;
        initrd = {
            availableKernelModules = [
                "nvme"
                "sd_mod"
            ];
            compressor = "zstd";
        };
        kernelPackages = pkgs.linuxPackages_zen;
        loader = {
            efi.canTouchEfiVariables = true;
            systemd-boot = {
                enable = true;
                configurationLimit = 20;
                consoleMode = "auto";
                editor = false;
            };
            timeout = 3;
        };
    };
}
