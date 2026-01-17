{ config, ... }:
{
  programs.gh = {
    enable = true;
    gitCredentialHelper = {
      enable = true;
      hosts = [ "https://github.com" ];
    };
    hosts."github.com".user = "farhnkrnapratma";
    settings = {
      aliases = {
        clone = "repo clone";
        delete = "repo delete --yes";
        login = "auth login -cwh github.com -p https --skip-ssh-key";
        logout = "auth logout -h github.com -u farhnkrnapratma";
        ls = "repo ls";
        refresh = "auth refresh -ch github.com";
        sync = "repo sync";
      };
      git_protocol = "https";
    };
  };
}
