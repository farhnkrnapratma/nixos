let
  env = fromTOML (builtins.readFile ../../env.toml);
in
{
  users.groups.${env.user.name} = rec {
    gid = env.user.guid;
    members = [ name ];
    name = env.user.name;
  };
}
