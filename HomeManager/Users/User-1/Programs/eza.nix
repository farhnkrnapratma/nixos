# SPDX-FileCopyrightText: 2026 Farhan Kurnia Pratama
#
# SPDX-License-Identifier: MIT

{
  config,
  ...
}:
{
  programs.eza = {
    enable = true;
    enableFishIntegration = config.programs.fish.enable;
    colors = "auto";
    git = true;
    icons = "auto";
  };
}
