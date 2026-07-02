let
  env = fromTOML (builtins.readFile ../env.toml);
in
{
  system.stateVersion = env.version;
}
