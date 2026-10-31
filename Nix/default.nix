# SPDX-FileCopyrightText: 2026 Farhan Kurnia Pratama
#
# SPDX-License-Identifier: MIT

{
  imports = [
    ./gc.nix
    ./optimise.nix
    ./settings.nix
  ];
  nix = {
    enable = true;
    checkAllErrors = true;
    checkConfig = true;
  };
}
