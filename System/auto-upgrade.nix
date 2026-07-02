let
  env = fromTOML (builtins.readFile ../env.toml);
in
{
  system.autoUpgrade = {
    enable = true;
    dates = "daily";
    fixedRandomDelay = true;
    flake = env.path.flake;
    operation = "switch";
    upgrade = false;
    runGarbageCollection = true;
    randomizedDelaySec = "10min";
    allowReboot = true;
    rebootWindow = {
      lower = "00:00";
      upper = "03:00";
    };
  };
}
