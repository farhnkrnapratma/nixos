# SPDX-FileCopyrightText: 2026 Farhan Kurnia Pratama
#
# SPDX-License-Identifier: MIT

{
  config,
  ...
}:
{
  home.shell.enableFishIntegration = config.programs.fish.enable;
}
