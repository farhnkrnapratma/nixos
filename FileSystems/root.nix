let
  env = fromTOML (builtins.readFile ../env.toml);
in
{
  fileSystems."/" = {
    device = env.part.mapper;
    fsType = "ext4";
    encrypted = {
      enable = true;
      blkDev = env.part.root;
      label = env.part.luks;
    };
    options = [
      "noatime"
      "errors=remount-ro"
    ];
  };
}
