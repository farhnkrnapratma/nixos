# ❄️ My NixOS Flake

## Getting Started

### Prerequisites

- [x] NixOS installed on the target system
- [x] Flakes enabled in the Nix configuration:

  ```nix
  # configuration.nix
  {
    nix.settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
  }
  ```

### Usage

> [!WARNING]
> Please read the [disclaimer](#disclaimer) before continue.

1. Clone the repository:

  ```sh
  git clone https://github.com/farhnkrnapratma/nixos.git <dir_name>
  ```
  ```sh
  cd <dir_name>
  ```

2. Modify the configuration as necessary
3. Validate the configuration:
  ```sh
  nixos-rebuild dry-build --flake .#<host_name>
  ```

4. Apply the configuration:
  ```sh
  nixos-rebuild switch --flake .#<host_name>
  ```

## License

This project is licensed under the [`MIT License`](LICENSE).

## Contact

- Website: [`https://fkp.my.id`](https://fkp.my.id)
- Email: [`contact@fkp.my.id`](mailto:contact@fkp.my.id)
- Matrix: `@farhnkrnapratma` on [`matrix.org`](https://matrix.org)
- IRC: `@farhnkrnapratma` on [`libera.chat`](https://libera.chat)

---

## DISCLAIMER

```txt
This NixOS Flake configuration is provided "AS IS", without warranty of any kind,
express or implied, including but not limited to the warranties of
merchantability, fitness for a particular purpose, and non-infringement.

USE AT YOUR OWN RISK. The author(s) shall not be held liable for any damages
arising from the use or misuse of this configuration, including but not limited to:

  - Data loss or corruption
  - System failure, boot issues, or unbootable system states
  - System instability or degraded performance due to misconfiguration
  - Security vulnerabilities introduced by third-party components
  - Unexpected behavior due to experimental or unstable features

THIRD-PARTY DEPENDENCIES. This configuration may rely on external inputs
(e.g., nixpkgs, home-manager, and other flake sources). No guarantees are made
regarding their safety, correctness, or long-term stability.

EXPERIMENTAL FEATURES. This configuration uses Nix Flakes, which are currently
considered experimental and may change without notice.

NO SUPPORT OBLIGATION. The author(s) are not required to provide support,
maintenance, updates, or bug fixes.

BEFORE USE:
  1. Back up important data.
  2. Test in a virtual machine or isolated environment.
  3. Review all configurations to ensure compatibility.

This disclaimer applies to all versions unless explicitly overridden.

This disclaimer does not supersede the terms of the repository license.

For issues, visit:
https://github.com/farhnkrnapratma/nixos/issues
```
