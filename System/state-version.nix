# SPDX-FileCopyrightText: 2026 Farhan Kurnia Pratama
#
# SPDX-License-Identifier: MIT

let
  env = fromTOML (builtins.readFile ../env.toml);
in
{
  system.stateVersion = env.version;
}
