{ config
, pkgs
, ...
}:
{
  environment = {
    cosmic.excludePackages = with pkgs; [
      cosmic-edit
      cosmic-files
      cosmic-player
      cosmic-store
      cosmic-term
      cosmic-reader
      rygel
    ];
    shells = [ pkgs.fish ];
  };
}
