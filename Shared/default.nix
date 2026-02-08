rec {
  aos = "x86_64-linux"; # arch and os
  tag = "26.05"; # always prefer unstable
  user = {
    name = "farhnkrnapratma"; # username
    guid = 1202; # group and user id
    desc = "Farhan Kurnia Pratama"; # full name
    host = "dotdev"; # host name
    edit = "codium --wait"; # default code editor
  };
  path = rec {
    home = "/home/${user.name}"; # path to home directory
    projects = "${home}/Projects"; # path to works directory
    flake = "${projects}/nixos"; # path to system flake
  };
  part = rec {
    boot = "/dev/disk/by-partlabel/EFI"; # boot partition
    root = "/dev/disk/by-partlabel/NixOS"; # root partition
    luks = "luks"; # label for luks encrypted partition
    mapper = "/dev/mapper/${luks}"; # block device mapper
  };
}
