# SPDX-FileCopyrightText: 2026 Farhan Kurnia Pratama
#
# SPDX-License-Identifier: MIT

{
  programs.fastfetch = {
    enable = true;
    settings = {
      logo.source = "Cosmic";
      logo.padding.left = 2;
      display.color = "cyan";
      display.separator = ": ";
      modules = [
        "title"
        "separator"
        "os"
        "kernel"
        "shell"
        "initsystem"
        "packages"
        "uptime"
        "break"
        "colors"
      ];
    };
  };
}
