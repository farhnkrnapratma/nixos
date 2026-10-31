# SPDX-FileCopyrightText: 2026 Farhan Kurnia Pratama
#
# SPDX-License-Identifier: MIT

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
