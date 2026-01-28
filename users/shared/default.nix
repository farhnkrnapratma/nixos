{ config
, lib
, pkgs
, ...
}:
let
  flakePath = "/home/plucky/Projects/nixos";
in
{
  home = {
    stateVersion = "26.05";
    packages = with pkgs; [
      aria2
      bat
      brave
      eza
      gnome-calculator
      gnome-calendar
      gnome-characters
      gnome-clocks
      loupe
      nautilus
      papers
      showtime
      snapshot
      wl-clipboard
      yaru-theme
      zoxide
    ];
  };

  programs = {
    fish = {
      enable = true;
      interactiveShellInit = ''
        set fish_greeting

        function commit
          if not git rev-parse --is-inside-work-tree >/dev/null 2>&1
            echo "[!] Not in a Git repository."
            return 1
          end

          set cmsg $argv[1]
          set mode $argv[2]
          set file $argv[3..-1]

          if test -z "$cmsg"
            echo "[!] Commit messages cannot be empty"
            return 1
          end

          test -n "$mode"; or set mode a

          echo "[1/3] Adding change(s) to the staging area..."
          switch $mode
            case a
              git add -A
              or begin
                echo "[!] Failed at step 1/3"
                return 1
              end
            case f
              if test (count $file) -eq 0
                echo "[!] No files specified for mode 'f'"
                return 1
              end
              for f in $file
                if not test -e "$f"
                  echo "[!] File not found: $f"
                  return 1
                end
              end
              git add $file
              or begin
                echo "[!] Failed at step 1/3"
                return 1
              end
            case '*'
              echo "Invalid mode: $mode"
              return 1
          end
          echo "[1/3] Done."

          echo "[2/3] Committing staged changes..."
          git commit -s -m "$cmsg"
          or begin
            echo "[!] Failed at step 2/3"
            return 1
          end
          echo "[2/3] Done."

          echo "[3/3] Pushing commits..."
          git push
          or begin
            echo "[!] Failed at step 3/3"
            return 1
          end
          echo "[3/3] Done."
        end

        function update
          set flakesNeedUpdate false
          set _cdir (pwd)

          echo "[1/7] Change directory to flake repository..."
          cd /home/plucky/Projects/nixos
          or begin
            echo "[!] Failed at step 1/7"
            return 1
          end
          echo "[1/7] Done."

          echo "[2/7] Updating flakes..."
          nix flake update
          or begin
            echo "[!] Failed at step 2/7"
            cd $_cdir
            return 1
          end

          if git diff --quiet -- flake.lock
            echo "[!] No flakes updates available"
          else
            set flakesNeedUpdate true
          end
          echo "[2/7] Done."

          echo "[3/7] Formatting repository..."
          nix fmt
          or begin
            echo "[!] Failed at step 3/7"
            cd $_cdir
            return 1
          end
          echo "[3/7] Done."

          if test "$flakesNeedUpdate" = true
            echo "[4/7] Pushing changes to remote repository..."
            commit "nixos: update flake" all
            or begin
              echo "[!] Failed at step 4/7"
              cd $_cdir
              return 1
            end
            echo "[4/7] Done."

            echo "[5/7] Rebuilding host system..."
            sudo nixos-rebuild switch --flake .#puffin
            or begin
              echo "[!] Failed at step 5/7"
              cd $_cdir
              return 1
            end
            echo "[5/7] Done."

            echo "[6/7] Deleting older generations..."
            sudo nix-collect-garbage -d
            or begin
              echo "[!] Failed at step 6/7"
              cd $_cdir
              return 1
            end
            echo "[6/7] Done."
          else
            echo "[!] Skipping step [4-6]..."
            echo "[!] Done."
          end

          echo "[7/7] Back to last directory..."
          cd $_cdir
          or begin
            echo "[!] Failed at step 7/7"
            cd $_cdir
            return 1
          end
          echo "[7/7] Done."
        end

        zoxide init fish | source
      '';
      preferAbbrs = true;
      shellAbbrs = {
        c = "clear";
        cat = "bat";
        cd = "z";
        l = "eza -lahgmuU --smart-group";
        ls = "eza";
        ngc = "sudo nix-collect-garbage -d";
        nfu = "nix flake update --flake ${flakePath}";
        nft = "nix fmt";
        nrd = "sudo nixos-rebuild dry-run --flake ${flakePath}";
        nrs = "sudo nixos-rebuild switch --flake ${flakePath}";
        x = "exit";
      };
    };

    ghostty = {
      enable = true;
      enableFishIntegration = lib.mkIf config.programs.fish.enable true;
      clearDefaultKeybinds = false;
      installBatSyntax = true;
      settings = {
        adjust-cell-height = "15%";
        background-opacity = 1;
        cursor-style = "underline";
        cursor-style-blink = true;
        font-family = "JetBrains Mono";
        font-feature = "+calt, +liga, +dlig";
        font-size = 11;
        link-previews = true;
        shell-integration = if config.programs.fish.enable then "fish" else "detect";
        shell-integration-features = "no-cursor";
        theme = "dark:Detuned,light:TokyoNight Day";
        window-decoration = "none";
        window-padding-balance = true;
        window-padding-x = 3;
        window-padding-y = 3;
        window-show-tab-bar = "never";
        window-theme = "system";
      };
      systemd.enable = true;
    };
  };
}
