# SPDX-FileCopyrightText: 2026 Farhan Kurnia Pratama
#
# SPDX-License-Identifier: MIT

{
  networking.networkmanager.wifi = {
    backend = "iwd";
    macAddress = "random";
    powersave = false;
    scanRandMacAddress = true;
  };
}
