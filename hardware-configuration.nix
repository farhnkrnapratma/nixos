{ config
, lib
, pkgs
, modulesPath
, ...
}:

{
  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.luks.devices."luks-4f63db25-9e60-4a4d-9726-9dcd03c32d39".device = "/dev/disk/by-uuid/4f63db25-9e60-4a4d-9726-9dcd03c32d39";

  fileSystems."/" =
    {
      device = "/dev/mapper/luks-4f63db25-9e60-4a4d-9726-9dcd03c32d39";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-uuid/5BD4-AFB5";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };
}
