# SPDX-FileCopyrightText: 2026 Farhan Kurnia Pratama
#
# SPDX-License-Identifier: MIT

{
  nix.gc = {
    automatic = true;
    dates = "daily";
    persistent = true;
    randomizedDelaySec = "10min";
  };
}
