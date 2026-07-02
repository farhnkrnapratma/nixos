let
  env = fromTOML (builtins.readFile ../env.toml);
in
{
  fileSystems."/boot" = {
    device = env.part.boot;
    fsType = "vfat";
    mountPoint = "/boot";
    autoFormat = true;
    options = [
      "noatime"
      "nodev"
      "nosuid"
      "noexec"
      "umask=0077"
    ];
  };
}
