{ config
, ...
}:
{
  imports = [
    ./programs
    ./packages
  ];

  home.stateVersion = "26.05";
}
