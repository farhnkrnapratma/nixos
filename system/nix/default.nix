{ config
, ...
}:
let
  NixSchedule = {
    automatic = true;
    dates = "daily";
    persistent = true;
    randomizedDelaySec = "10min";
  };
in
{
  nix = {
    enable = true;
    checkAllErrors = true;
    checkConfig = true;
    gc = NixSchedule;
    optimise = NixSchedule;
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      auto-optimise-store = true;
    };
  };
}
