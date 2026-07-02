{
  pkgs,
  ...
}:
let
  env = fromTOML (builtins.readFile ../../../../env.toml);
in
{
  programs.firefox = {
    enable = true;
    package = pkgs.librewolf;
    languagePacks = [ "en-US" ];
    policies = {
      BlockAboutConfig = true;
      DefaultDownloadDirectory = "${env.path.home}/Downloads";
      ExtensionSettings = {
        "uBlock-Origin" = {
          default_area = "menupanel";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
          installation_mode = "force_installed";
          private_browsing = true;
        };
        "Privacy-Badger" = {
          default_area = "menupanel";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/privacy-badger17/latest.xpi";
          installation_mode = "force_installed";
          private_browsing = true;
        };
      };
    };
  };
}
