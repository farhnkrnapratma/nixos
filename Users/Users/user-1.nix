{
  pkgs,
  ...
}:
let
  env = fromTOML (builtins.readFile ../../env.toml);
in
{
  users.users.${env.user.name} = {
    createHome = true;
    description = env.user.desc;
    expires = "2030-01-01";
    extraGroups = [
      "audio"
      "networkmanager"
      "video"
      "wheel"
    ];
    group = env.user.name;
    homeMode = "0700";
    ignoreShellProgramCheck = true;
    initialHashedPassword = env.user.pass;
    isNormalUser = true;
    shell = pkgs.fish;
    uid = env.user.guid;
  };
}
