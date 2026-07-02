let
  env = fromTOML (builtins.readFile ../../../../env.toml);
in
{
  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      desktop = null;
      music = null;
      publicShare = null;
      templates = null;
      videos = null;
      createDirectories = true;
      extraConfig = {
        XDG_PROJECTS_DIR = env.path.projects;
      };
    };
  };
}
