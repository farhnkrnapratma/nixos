#!/usr/bin/env bash

# SPDX-FileCopyrightText: 2026 Farhan Kurnia Pratama
#
# SPDX-License-Identifier: MIT

set -euo pipefail

repo_root=$(git rev-parse --show-toplevel 2>/dev/null) || exit 0

for hook in pre-commit; do
  src="$repo_root/.githooks/$hook"
  dest="$repo_root/.git/hooks/$hook"
  [ -f "$src" ] || continue
  cp "$src" "$dest"
  chmod +x "$dest"
done
