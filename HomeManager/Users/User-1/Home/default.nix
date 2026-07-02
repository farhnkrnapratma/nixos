let
  env = fromTOML (builtins.readFile ../../../../env.toml);
in
{
  imports = [
    ./packages.nix
    ./pointer-cursor.nix
    ./session-variables.nix
  ];
  home = {
    uid = env.user.guid;
    stateVersion = env.version;
    username = env.user.name;
    homeDirectory = env.path.home;
    enableNixpkgsReleaseCheck = true;
    preferXdgDirectories = true;
  };
}
