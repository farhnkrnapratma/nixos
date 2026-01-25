{ config
, modulesPath
, ...
}:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot.initrd.luks.devices = {
    "luks-37355eb9-fb07-4aa6-8a00-71b84622d91f".device =
      "/dev/disk/by-uuid/37355eb9-fb07-4aa6-8a00-71b84622d91f";
    "luks-1ec17656-96de-4a40-9b68-d365f3bcf466".device =
      "/dev/disk/by-uuid/1ec17656-96de-4a40-9b68-d365f3bcf466";
  };

  fileSystems."/" = {
    device = "/dev/mapper/luks-37355eb9-fb07-4aa6-8a00-71b84622d91f";
    fsType = "ext4";
  };

  fileSystems."/home" = {
    device = "/dev/mapper/luks-1ec17656-96de-4a40-9b68-d365f3bcf466";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/ESP_SYSTEM";
    fsType = "vfat";
    options = [
      "fmask=0077"
      "dmask=0077"
    ];
  };
}
