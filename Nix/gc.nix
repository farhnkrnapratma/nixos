{
  nix.gc = {
    automatic = true;
    dates = "daily";
    persistent = true;
    randomizedDelaySec = "10min";
  };
}
