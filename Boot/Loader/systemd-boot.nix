# SPDX-FileCopyrightText: 2026 Farhan Kurnia Pratama
#
# SPDX-License-Identifier: MIT

{
  boot.loader.systemd-boot = {
    enable = true;
    editor = false;
    consoleMode = "max";
    configurationLimit = 25;
  };
}
