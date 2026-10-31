# SPDX-FileCopyrightText: 2026 Farhan Kurnia Pratama
#
# SPDX-License-Identifier: MIT

{
  inputs,
  ...
}:
{
  nixpkgs.overlays = [ inputs.cachyos-kernel.overlays.default ];
}
