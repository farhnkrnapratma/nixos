{
  config,
  ...
}:
{
  programs.zoxide = {
    enable = true;
    enableFishIntegration = config.programs.fish.enable;
    options = [ "--cmd cd" ];
  };
}
