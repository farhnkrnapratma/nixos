# SPDX-FileCopyrightText: 2026 Farhan Kurnia Pratama
#
# SPDX-License-Identifier: MIT

{
  pkgs,
  ...
}:
{
  boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-bore;
}
