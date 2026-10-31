# SPDX-FileCopyrightText: 2026 Farhan Kurnia Pratama
#
# SPDX-License-Identifier: MIT

{
  imports = [
    ./alsa.nix
    ./jack.nix
    ./pulse.nix
  ];
  services.pipewire.enable = true;
}
