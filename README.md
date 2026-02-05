# ❄️ NixOS Flake by [`@farhnkrnapratma`](https://github.com/farhnkrnapratma)

## 1. Getting Started

### 1.1 Prerequisites

- [x] NixOS installed on your system
- [x] Flakes enabled in your Nix configuration:
  ```nix
  {
    nix.settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
  }
  ```

### 1.2 Using This Flake

#### Option 1: As a Flake Input

Add this flake as an input to your own configuration:

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos.url = "github:farhnkrnapratma/nixos";
  };

  outputs = { self, nixpkgs, nixos, ... }: {
    nixosConfigurations.myhost = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [ nixos.nixosModules.default ];
    };
  };
}
```

#### Option 2: Standalone Usage

1. **Clone or fork this repository:**

   ```fish
   git clone https://github.com/farhnkrnapratma/nixos.git
   cd nixos
   ```

2. **Customize the configuration:**
   - `Shared/default.nix`: set your hostname, username, and other variables
   - `System/default.nix`: system-level settings
   - `User/default.nix`: user-level preferences

3. **Test the configuration:**
   ```fish
   sudo nixos-rebuild dry-build --flake .#yourHostName
   ```

4. **Apply the configuration:**
   ```fish
   sudo nixos-rebuild switch --flake .#yourHostName
   ```

## 2. Common Commands

### 2.1 Build & Switch

Apply configuration changes:

```fish
sudo nixos-rebuild switch --flake .#yourHostName
```

### 2.2 Update Flakes

Update all flake inputs to their latest versions:

```fish
nix flake update
```

### 2.3 Check Flakes

Checks that `flake.nix` is valid and evaluates correctly:

```fish
nix flake check
```

### 2.4 Format Code

Format all Nix files using `nixfmt`:

```fish
nix fmt
```

### 2.5 Garbage Collection

Remove old generations and free up disk space:

```fish
sudo nix-collect-garbage -d
```

## 3. Structure Overview

```
nixos/
├── Shared/       # Global variables and constants shared across the configuration
├── System/       # System-level NixOS configuration files
├── User/         # Home Manager integration and user-level configuration
└── flake.nix     # Main flake configuration file
```

## 4. License

This project is licensed under the GNU General Public License v3.0 - see the [`LICENSE`](LICENSE) file for details.

## 5. Contact

- Email: [`farhnkrnapratma@gmail.com`](https://mailto:farhnkrnapratma@gmail.com)
- Matrix: `farhnkrnapratma` on [`matrix.org`](https://matrix.org/)
- IRC: `farhnkrnapratma` on [`libera.chat`](https://libera.chat/)

```text
DISCLAIMER

USE AT YOUR OWN RISK. THIS CONFIGURATION IS PROVIDED AS-IS WITHOUT ANY
WARRANTIES OR GUARANTEES. I AM NOT RESPONSIBLE FOR ANY DAMAGE, DATA LOSS,
SYSTEM FAILURES, OR OTHER ISSUES THAT MAY ARISE FROM USING THIS FLAKE.
ALWAYS BACKUP YOUR DATA AND TEST CONFIGURATIONS IN A SAFE ENVIRONMENT
BEFORE APPLYING THEM TO PRODUCTION SYSTEMS.
```
