rec {
  aos = "x86_64-linux"; # arch and os
  tag = "26.05"; # always prefer unstable
  user = rec {
    id = "${host}.${name}"; # reverse domain name identifier
    name = "farhnkrnapratma"; # username
    guid = 1202; # group and user id
    desc = "Farhan Kurnia Pratama"; # full name
    host = "dev"; # host name
    edit = "codium --wait"; # default code editor
  };
  path = rec {
    home = builtins.toPath "/home/${user.name}"; # path to home directory
    projects = builtins.toPath "${home}/Projects"; # path to works directory
    flake = builtins.toPath "${projects}/nixos"; # path to system flake
  };
  part = rec {
    boot = builtins.toPath "/dev/disk/by-partlabel/EFI"; # boot partition
    root = builtins.toPath "/dev/disk/by-partlabel/NixOS"; # root partition
    luks = "luks"; # label for luks encrypted partition
    mapper = builtins.toPath "/dev/mapper/${luks}"; # block device mapper
  };
}
