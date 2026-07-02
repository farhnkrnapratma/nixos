{
  imports = [
    ./ethernet.nix
    ./wifi.nix
  ];
  networking.networkmanager = {
    enable = true;
    dhcp = "internal";
    dns = "systemd-resolved";
  };
}
