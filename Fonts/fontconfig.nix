let
  env = fromTOML (builtins.readFile ../env.toml);
in
{
  fonts.fontconfig.defaultFonts = {
    monospace = [ env.fonts.mono ];
    sansSerif = [ env.fonts.sans ];
    serif = [ env.fonts.serif ];
    emoji = [ env.fonts.mono ];
  };
}
