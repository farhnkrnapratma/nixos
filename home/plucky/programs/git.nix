{ config
, lib
, ...
}:
{
  programs.git = {
    enable = true;
    maintenance = {
      enable = true;
      repositories = [
        "/etc/nixos"
        "/home/plucky/Projects/data"
      ];
      timers = {
        daily = "daily";
        hourly = "hourly";
        weekly = "weekly";
      };
    };
    settings = {
      core = {
        whitespace = "trailing-space,space-before-tab";
      };
      init.defaultBranch = "main";
      user = {
        email = "farhnkrnapratma@gmail.com";
        name = "Farhan Kurnia Pratama";
      };
    };
    signing = lib.mkIf config.programs.gpg.enable {
      format = "openpgp";
      key = "440D2C6DF110AF257A97C26507723A92A04788B3";
      signByDefault = lib.mkIf config.services.gpg-agent.enable true;
      signer = "${config.home.profileDirectory}/bin/gpg";
    };
  };
}
