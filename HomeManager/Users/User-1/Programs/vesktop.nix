{
  pkgs,
  ...
}:
{
  programs.vesktop = {
    enable = true;
    vencord.useSystem = true;
    vencord.themes."system24.css" = pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/refact0r/system24/master/theme/system24.theme.css";
      sha256 = "sha256-cNrrCMC/GS8yi9kZW2cOXVmnCjffKOUjgO238pD2h7s=";
    };
  };
}
