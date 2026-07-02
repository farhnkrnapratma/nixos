{
  config,
  ...
}:
let
  env = fromTOML (builtins.readFile ../../../../env.toml);
  fish_enabled = config.programs.fish.enable;
in
{
  programs.ghostty = {
    enable = true;
    clearDefaultKeybinds = false;
    enableFishIntegration = fish_enabled;
    installBatSyntax = true;
    settings = {
      adjust-cell-height = "15%";
      background-opacity = 1;
      cursor-style = "underline";
      cursor-style-blink = true;
      font-family = env.fonts.nerd;
      font-feature = "+calt, +liga, +dlig";
      font-size = 11;
      link-previews = true;
      shell-integration = if fish_enabled then "fish" else "detect";
      shell-integration-features = "no-cursor";
      theme = "dark:GitHub Dark Default,light: GitHub Light Default";
      window-decoration = "none";
      window-padding-balance = true;
      window-padding-x = 3;
      window-padding-y = 3;
      window-show-tab-bar = "never";
      window-theme = "system";
    };
    systemd.enable = true;
  };
}
