# SPDX-FileCopyrightText: 2026 Farhan Kurnia Pratama
#
# SPDX-License-Identifier: MIT

{
  config,
  ...
}:
{
  programs.zoxide = {
    enable = true;
    enableFishIntegration = config.programs.fish.enable;
    options = [ "--cmd cd" ];
  };
}
