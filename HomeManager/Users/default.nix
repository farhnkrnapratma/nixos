let
  env = fromTOML (builtins.readFile ../../env.toml);
in
{
  home-manager.users.${env.user.name} = import ./User-1;
}
