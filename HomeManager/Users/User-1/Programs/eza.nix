{
  config,
  ...
}:
{
  programs.eza = {
    enable = true;
    enableFishIntegration = config.programs.fish.enable;
    colors = "auto";
    git = true;
    icons = "auto";
  };
}
