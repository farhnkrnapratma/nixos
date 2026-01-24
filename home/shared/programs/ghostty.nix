{ config, ... }:
{
  programs.ghostty = {
    enable = true;
    enableFishIntegration = true;
    clearDefaultKeybinds = false;
    installBatSyntax = true;
    settings = {
      adjust-cell-height = "15%";
      background-opacity = 0.9;
      cursor-style = "underline";
      cursor-style-blink = true;
      font-family = "JetBrains Mono";
      font-feature = "+calt, +liga, +dlig";
      font-size = 11;
      link-previews = true;
      shell-integration = if config.programs.fish.enable then "fish" else "detect";
      shell-integration-features = "no-cursor";
      theme = "dark:Detuned,light:TokyoNight Day";
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
