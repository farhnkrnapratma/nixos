{ config, ... }:
{
    networking = {
        hostName = "puffin";
        enableIPv6 = true;
        tempAddresses = "enabled";
        timeServers = [
            "0.id.pool.ntp.org"
            "1.id.pool.ntp.org"
            "2.id.pool.ntp.org"
            "3.id.pool.ntp.org"
        ];
        nameservers = [
            "1.1.1.1"
            "9.9.9.9"
        ];
        networkmanager = {
            enable = true;
            dns = "systemd-resolved";
            dhcp = "internal";
            wifi = {
                scanRandMacAddress = true;
                powersave = false;
                macAddress = "random";
                backend = "iwd";
            };
            ethernet.macAddress = "random";
            logLevel = "OFF";
        };
        nftables.enable = true;
        firewall = {
            enable = config.networking.nftables.enable;
            backend = if config.networking.nftables.enable then "nftables" else "firewalld";
            allowPing = true;
            pingLimit = if config.networking.nftables.enable then "1/minute burst 5 packets" else null;
            filterForward = true;
            checkReversePath = "loose";
        };
    };
}
