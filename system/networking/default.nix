{ config, lib, ... }:

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
      enable = lib.mkIf config.networking.nftables.enable true;
      backend = "nftables";
      allowPing = true;
      pingLimit = "1/minute burst 5 packets";
      filterForward = true;
      checkReversePath = "loose";
    };
  };
}
