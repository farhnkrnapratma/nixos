rec {
  system = "x86_64-linux"; # system architecture and kernel name
  version = "26.05"; # always prefer unstable version
  visual = "codium --wait"; # default code editor
  user = {
    host = "dev"; # host name
    domain = "home.arpa"; # # special-use domain (RFC 8375)
    name = "farhnkrnapratma"; # username
    desc = "Farhan Kurnia Pratama"; # full name
    guid = 1202; # group and user id
  };
  path = rec {
    home = builtins.toPath "/home/${user.name}"; # path to home directory
    projects = builtins.toPath "${home}/Projects"; # path to projects directory
    flake = builtins.toPath "${projects}/nixos"; # path to flake directory
  };
  part = rec {
    boot = builtins.toPath "/dev/disk/by-partlabel/EFI"; # boot partition
    root = builtins.toPath "/dev/disk/by-partlabel/NixOS"; # root partition
    luks = "luks"; # label for luks encrypted partition
    mapper = builtins.toPath "/dev/mapper/${luks}"; # block device mapper
  };
}
