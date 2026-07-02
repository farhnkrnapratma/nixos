set shell := ["/usr/bin/env", "bash", "-euo", "pipefail", "-c"]

envlock_script := "./envcrypt"
flake_profile  := ".#dev"
secret_file    := "env.toml"

alias a := add
alias c := clean
alias d := check
alias e := encrypt
alias f := format
alias g := decrypt
alias p := push
alias r := rebuild
alias s := shell
alias u := update

[doc("Run standard maintenance workflow: format, update, check, and clean")]
@default:
  echo "[just] Starting standard system maintenance..."
  @just format
  @just update
  @just check
  @just clean
  echo "[just] Maintenance workflow completed successfully."

[doc("Add all changes to staging area.")]
@add:
  echo "[just] Adding changes to staging area..."
  @just ensure-encrypted
  git add -A
  echo "[just] Added succesfully."

[doc("Auto-encrypt if the secret file is in plain text")]
@ensure-encrypted:
  if file {{secret_file}} | grep -q "text"; then \
    echo "[just] {{secret_file}} is plain text. Encrypting now..."; \
    just encrypt; \
  else \
    echo "[just] {{secret_file}} is already encrypted."; \
  fi

[doc("Remove system garbage and older Nix generations")]
@clean:
  echo "[just] Running nix-collect-garbage..."
  @sudo nix-collect-garbage -d
  echo "[just] Cleanup finished."

[doc("Validate Flake integrity and configuration")]
@check:
  echo "[just] Starting Flake integrity check..."
  @just decrypt
  @nix flake check
  @just encrypt
  echo "[just] Flake check passed."

[doc("Encrypt the env.toml file using envcrypt")]
@encrypt:
  echo "[just] Locking configuration files (encrypting)..."
  @{{envlock_script}} --encrypt
  echo "[just] Files secured."

[doc("Format the Nix flake code according to standards")]
@format:
  echo "[just] Running Nix formatter..."
  @just decrypt
  @nix fmt
  @just encrypt
  echo "[just] Formatting completed."

[doc("Decrypt the env.toml file for system access")]
@decrypt:
  echo "[just] Unlocking configuration files (decrypting)..."
  @{{envlock_script}} --decrypt
  echo "[just] Files decrypted and ready for use."

[doc("Ensure secrets are encrypted and push changes to remote")]
@push:
  @just ensure-encrypted
  echo "[just] Pushing changes to remote repository..."
  @git push
  echo "[just] Push process completed."

[doc("Rebuild the NixOS system using the specified profile")]
@rebuild:
  @just decrypt
  echo "[just] Starting NixOS system rebuild (profile: {{flake_profile}})..."
  @sudo nixos-rebuild switch --flake {{flake_profile}}
  @just encrypt
  echo "[just] System rebuild successful. Changes applied."

[doc("Open the development shell (nix develop)")]
@shell:
  echo "[just] Preparing development environment..."
  @just decrypt
  @nix develop
  @just encrypt
  echo "[just] Exited shell. Secrets have been re-encrypted."

[doc("Update all flake inputs in flake.lock")]
@update:
  echo "[just] Updating Nix Flake inputs..."
  @nix flake update
  echo "[just] flake.lock has been updated."
