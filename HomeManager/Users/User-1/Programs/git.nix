{
  lib,
  config,
  ...
}:
let
  env = fromTOML (builtins.readFile ../../../../env.toml);
in
{
  programs.git = {
    enable = true;
    attributes = [
      "* text=auto eol=lf"
      "*.lock linguist-generated=true"
      "*.lock merge=ours"
    ];
    ignores = [
      "*~"
      "*.ignore.*"
    ];
    maintenance = {
      enable = true;
      repositories = [
        "${env.path.projects}/cache"
        "${env.path.flake}"
      ];
      timers = {
        daily = "daily";
        hourly = "hourly";
        weekly = "weekly";
      };
    };
    settings = {
      core = {
        editor = env.set.visual;
        whitespace = "trailing-space,space-before-tab";
      };
      init.defaultBranch = "main";
      user = {
        email = "${env.user.name}@gmail.com";
        name = env.user.desc;
      };
    };
    signing = lib.mkIf config.programs.gpg.enable {
      format = "openpgp";
      signByDefault = true;
      signer = "${config.home.profileDirectory}/bin/gpg";
      key = "440D2C6DF110AF257A97C26507723A92A04788B3";
    };
  };
}
