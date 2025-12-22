{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./programs
    ./packages
    ./services
  ];

  home = rec {
    username = "plucky";
    homeDirectory = "/home/${username}";
  };
}
