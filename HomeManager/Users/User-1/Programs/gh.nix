let
  env = fromTOML (builtins.readFile ../../../../env.toml);
  host = "github.com";
in
{
  programs.gh = {
    enable = true;
    gitCredentialHelper = {
      enable = true;
      hosts = [ "https://${host}" ];
    };
    hosts.${host}.user = env.user.name;
    settings = {
      editor = env.set.visual;
      git_protocol = "https";
      aliases = {
        ls = "repo ls";
        del = "repo delete";
        ref = "auth refresh -ch ${host}";
        sync = "repo sync";
        clone = "repo clone";
        login = "auth login -cwhp https -h ${host}";
        logout = "auth logout -u ${env.user.name} -h ${host}";
      };
    };
  };
}
