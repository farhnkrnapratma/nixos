# SPDX-FileCopyrightText: 2026 Farhan Kurnia Pratama
#
# SPDX-License-Identifier: MIT

let
  env = fromTOML (builtins.readFile ../../../../env.toml);
in
{
  home.sessionVariables = rec {
    VISUAL = env.set.visual;
    EDITOR = VISUAL;
    SUDO_EDITOR = VISUAL;
  };
}
