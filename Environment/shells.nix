# SPDX-FileCopyrightText: 2026 Farhan Kurnia Pratama
#
# SPDX-License-Identifier: MIT

{
  pkgs,
  ...
}:
{
  environment.shells = [ pkgs.fish ];
}
