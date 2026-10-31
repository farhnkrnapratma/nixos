# SPDX-FileCopyrightText: 2026 Farhan Kurnia Pratama
#
# SPDX-License-Identifier: MIT

{
  boot.initrd = {
    availableKernelModules = [ "nvme" ];
  };
}
