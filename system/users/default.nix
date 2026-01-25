{ config
, ...
}:

{
  imports = [
    ./plucky
    ./root
  ];
  users.mutableUsers = false;
}
