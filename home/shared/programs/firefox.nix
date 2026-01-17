{ config, ... }:
{
  programs.firefox = {
    enable = true;
    languagePacks = [
      "en-US"
      "id"
    ];
  };
}
