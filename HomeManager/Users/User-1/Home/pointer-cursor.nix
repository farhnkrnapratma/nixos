# SPDX-FileCopyrightText: 2026 Farhan Kurnia Pratama
#
# SPDX-License-Identifier: MIT

{
  pkgs,
  ...
}:
{
  home.pointerCursor = {
    enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Ice";
    size = 16;
    dotIcons.enable = true;
  };
}
