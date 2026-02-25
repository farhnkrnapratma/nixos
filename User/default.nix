{
  config,
  lib,
  pkgs,
  ...
}:
let
  env = import ../Shared;
  gpg_enabled = config.programs.gpg.enable;
  fish_enabled = config.programs.fish.enable;
  profile_dir = config.home.profileDirectory;
in
{
  editorconfig = {
    enable = true;
    settings."*" = {
      charset = "utf-8";
      end_of_line = "lf";
      indent_size = 2;
      indent_style = "space";
      insert_final_newline = true;
      trim_trailing_whitespace = true;
    };
  };

  home = {
    uid = env.user.guid;
    stateVersion = env.version;
    username = env.user.name;
    homeDirectory = env.path.home;
    enableNixpkgsReleaseCheck = true;
    packages = with pkgs; [
      # GUI
      discord
      element-desktop
      gnome-calculator
      gnome-characters
      gnome-clocks
      loupe
      nautilus
      onlyoffice-desktopeditors
      papers
      planify
      resources
      seahorse
      snapshot
      telegram-desktop
      termius
      vivaldi
      # CLI
      codeberg-cli
      codex
      cowsay
      gemini-cli
      github-copilot-cli
      glab
      gnome-keyring
      qwen-code
      shellcheck
      shfmt
      tea
      vlock
      wl-clipboard
      # Misc
      vivaldi-ffmpeg-codecs
      libgnome-keyring
      yaru-theme
    ];
    sessionVariables = {
      VISUAL = env.visual;
      EDITOR = env.visual;
    };
    shell.enableFishIntegration = fish_enabled;
    preferXdgDirectories = true;
  };

  programs = {
    aria2 = {
      enable = true;
      settings = {
        max-concurrent-downloads = 10;
        split = 10;
        max-connection-per-server = 5;
        min-split-size = "5M";
        optimize-concurrent-downloads = "true";
        file-allocation = "falloc";
        disk-cache = "64M";
        continue = true;
        retry-wait = 5;
        connect-timeout = 20;
        check-certificate = true;
        http-accept-gzip = true;
        enable-dht = true;
        enable-dht6 = true;
        enable-peer-exchange = true;
        bt-enable-lpd = true;
        seed-ratio = 0.0;
        seed-time = 0;
      };
    };

    bat = {
      enable = true;
      extraPackages = with pkgs.bat-extras; [
        batdiff
        batgrep
        batman
        batpipe
        batwatch
      ];
      config = {
        binary = "as-text";
        color = "always";
        decorations = "always";
        italic-text = "never";
        nonprintable-notation = "caret";
        number = true;
        tabs = "2";
        theme-dark = "gruvbox-dark";
        theme-light = "gruvbox-light";
        wrap = "auto";
      };
    };

    eza = {
      enable = true;
      enableFishIntegration = fish_enabled;
      colors = "auto";
      git = true;
      icons = "auto";
    };

    fish = {
      enable = true;
      generateCompletions = true;
      interactiveShellInit = ''
        set fish_greeting

        function shell
          set -l cmd -c fish -iP

          if test -f "flake.nix"; and test (count $argv) -eq 0
            nix shell $cmd
          else if test (count $argv) -eq 0
            echo "[!] No packages specified and no 'flake.nix' file found in the working directory"
            return 1
          else
            nix shell $argv $cmd
          end
        end

        function devel
          set -l cmd -c fish -iP

          if not test -f "flake.nix"
            echo "[!] No 'flake.nix' file found in the working directory"
            return 1
          else
            nix develop $cmd
          end
        end

        function commit
          if not git rev-parse --is-inside-work-tree >/dev/null 2>&1
            echo "[!] Not in a git repository"
            return 1
          end

          set -l cmsg $argv[1]
          set -l mode $argv[2]
          set -l files $argv[3..-1]

          if test -z "$cmsg"
            echo "[!] Commit messages cannot be empty"
            return 1
          end

          test -n "$mode"; or set mode a

          echo "[1/3] Staging changes..."
          switch $mode
            case a
              if not git add -A
                echo "[!] Failed at [1/3]"
                return 1
              end
            case f
              if test (count $files) -eq 0
                echo "[!] No files specified for mode 'f'"
                return 1
              end
              for f in $files
                if not test -e "$f"
                  echo "[!] File not found: '$f'"
                  return 1
                end
              end
              if not git add $files
                echo "[!] Failed at [1/3]"
                return 1
              end
            case '*'
              echo "[!] Invalid mode: $mode"
              return 1
          end
          echo "[1/3] Done"

          echo "[2/3] Committing staged changes..."
          if not git commit -s -m "$cmsg"
            echo "[!] Failed at [2/3]"
            return 1
          end
          echo "[2/3] Done"

          echo "[3/3] Pushing commits..."
          if not git push
            echo "[!] Failed at [3/3]"
            return 1
          end
          echo "[3/3] Done"
        end

        function update
          set -l cwd (pwd)
          set -l update false

          echo "[1/6] cd '$cwd' -> '${env.path.flake}'"
          if not cd ${env.path.flake}
            echo "[!] Failed at [1/6]"
            return 1
          end
          echo "[1/6] Done"

          echo "[2/6] Updating flakes..."
          if not nix flake update
            echo "[!] Failed at [2/6]"
            cd $cwd 2>/dev/null
            return 1
          end
          git diff --quiet -- flake.lock; or set update true
          test "$update" = false; and echo "[!] No flakes update available"
          echo "[2/6] Done"

          if test "$update" = true
            echo "[3/6] Pushing changes to remote repository..."
            if not commit "root: update the `flake.lock` file" f flake.lock
              echo "[!] Failed at [3/6]"
              cd $cwd 2>/dev/null
              return 1
            end
            echo "[3/6] Done"

            echo "[4/6] Rebuilding host system..."
            if not sudo nixos-rebuild switch --flake .#${env.user.host}
              echo "[!] Failed at [4/6]"
              cd $cwd 2>/dev/null
              return 1
            end
            echo "[4/6] Done"

            echo "[5/6] Deleting older generations..."
            if not sudo nix-collect-garbage -d
              echo "[!] Failed at [5/6]"
              cd $cwd 2>/dev/null
              return 1
            end
            echo "[5/6] Done"
          else
            echo "[!] Skipping step [3-5]..."
          end

          echo "[6/6] cd '${env.path.flake}' -> '$cwd'"
          if not cd $cwd
            echo "[!] Failed at [6/6]"
            return 1
          end
          echo "[6/6] Done"
        end
      '';
      shellAliases = {
        c = "clear";
        l = "eza -lahgmuU --smart-group --icons=always --color=always --color-scale --color-scale-mode=gradient";
        x = "exit";
        ga = "git add -A";
        gc = "git commit -s -m";
        ls = "eza --icons=always --color=always --color-scale --color-scale-mode=gradient";
        nfc = "nix flake check";
        nft = "nix fmt";
        nfu = "nix flake update --flake ${env.path.flake}";
        ngc = "sudo nix-collect-garbage -d";
        nrs = "sudo nixos-rebuild switch --flake ${env.path.flake}#${env.user.host}";
        ".." = "cd ..";
        "..." = "cd ../..";
      };
    };

    gh =
      let
        host = "github.com";
      in
      {
        enable = true;
        gitCredentialHelper = {
          enable = true;
          hosts = [ "https://${host}" ];
        };
        hosts.${host}.user = env.user.name;
        settings = {
          editor = env.visual;
          git_protocol = "https";
          aliases = {
            ls = "repo ls";
            del = "repo delete";
            ref = "auth refresh -ch ${host}";
            sync = "repo sync";
            clone = "repo clone";
            login = "auth login -cwhp https -h ${host}";
            logout = "auth logout -u ${env.user.name} -h ${host}";
          };
        };
      };

    ghostty = {
      enable = true;
      clearDefaultKeybinds = false;
      enableFishIntegration = fish_enabled;
      installBatSyntax = true;
      settings = {
        adjust-cell-height = "15%";
        background-opacity = 1;
        cursor-style = "underline";
        cursor-style-blink = true;
        font-family = "JetBrainsMono Nerd Font";
        font-feature = "+calt, +liga, +dlig";
        font-size = 11;
        link-previews = true;
        shell-integration = if fish_enabled then "fish" else "detect";
        shell-integration-features = "no-cursor";
        theme = "dark:Gruvbox Dark,light:Gruvbox Light";
        window-decoration = "none";
        window-padding-balance = true;
        window-padding-x = 3;
        window-padding-y = 3;
        window-show-tab-bar = "never";
        window-theme = "system";
      };
      systemd.enable = true;
    };

    git = {
      enable = true;
      attributes = [
        "* text=auto eol=lf"
        "*.lock linguist-generated=true"
        "*.lock merge=ours"
      ];
      ignores = [
        "*~"
        "*.ignore.*"
      ];
      maintenance = {
        enable = true;
        repositories = [
          "${env.path.projects}/cache"
          "${env.path.flake}"
        ];
        timers = {
          daily = "daily";
          hourly = "hourly";
          weekly = "weekly";
        };
      };
      settings = {
        core = {
          editor = env.visual;
          whitespace = "trailing-space,space-before-tab";
        };
        init.defaultBranch = "main";
        user = {
          email = "${env.user.name}@gmail.com";
          name = env.user.desc;
        };
      };
      signing = lib.mkIf gpg_enabled {
        format = "openpgp";
        signByDefault = true;
        signer = "${profile_dir}/bin/gpg";
        key = "440D2C6DF110AF257A97C26507723A92A04788B3";
      };
    };

    gpg = {
      enable = true;
      publicKeys = [
        {
          text = ''
            -----BEGIN PGP PUBLIC KEY BLOCK-----
            Comment: 440D 2C6D F110 AF25 7A97  C265 0772 3A92 A047 88B3

            xjMEaN5JuxYJKwYBBAHaRw8BAQdAB1TlqzOaNrDPwnuSMCi1Z+xVTYzJwRvWfVUs
            aOzo0JLNNWZhcmhua3JuYXByYXRtYUBnbWFpbC5jb20gPGZhcmhua3JuYXByYXRt
            YUBnbWFpbC5jb20+wpAEExYKADgWIQREDSxt8RCvJXqXwmUHcjqSoEeIswUCaN5J
            uwIbAwULCQgHAgYVCgkICwIEFgIDAQIeAQIXgAAKCRAHcjqSoEeIs6EEAQDOEVH3
            o2jde9hRqj3Re0QSWWI52pfkBQeOxglCnxOO/gEA3jqD2P8qHj78qRTbuU6kKFlc
            3xKEhAUtuAMgADeaIQHOOARo3km7EgorBgEEAZdVAQUBAQdAPzfEZcZDY8L6SDny
            ZmYPYrpKFX0MEl1EtVSP7rMhgx4DAQgHwngEGBYKACAWIQREDSxt8RCvJXqXwmUH
            cjqSoEeIswUCaN5JuwIbDAAKCRAHcjqSoEeIs+qMAQCVMwXPrVB+N+sd6Aeuy/M6
            39OzdAbrpn0jaCKMmxUKTwD9H25DDgCKqeeks+ujCj7kCNttt5AhS9yVsBaRevvB
            sQs=
            =MqeX
            -----END PGP PUBLIC KEY BLOCK-----
          '';
          trust = "ultimate";
        }
        {
          text = ''
            -----BEGIN PGP PUBLIC KEY BLOCK-----
            Comment: A277 1F8B 363C A8E7 6976  7F2F 8F88 1680 9F30 DEAC

            xjMEZ6OoQBYJKwYBBAHaRw8BAQdAfXDhv9qvJsngEsA3MuUVWfmdzx7jno4YOW9u
            Q7LOaILNP2Zhcmhua3JuYXByYXRtYUBwcm90b25tYWlsLmNvbSA8ZmFyaG5rcm5h
            cHJhdG1hQHByb3Rvbm1haWwuY29tPsLAEQQTFgoAgwWCZ6OoQAMLCQcJkI+IFoCf
            MN6sRRQAAAAAABwAIHNhbHRAbm90YXRpb25zLm9wZW5wZ3Bqcy5vcmeQJbXnN+qQ
            zWBPdRpFy12MJKvz8ucfFtCuEPA1VdtrbgMVCggEFgACAQIZAQKbAwIeARYhBKJ3
            H4s2PKjnaXZ/L4+IFoCfMN6sAAA/RAEAjl2QIDK9GJ48mXD9uP1dge1juFp1BlsS
            DEgTXZj0I/YA/RDTXiMn8M8/LhmDeUmNWeOx6HsXhWVmgBbQOk+XpgYKzjgEZ6Oo
            QBIKKwYBBAGXVQEFAQEHQME5UMxUw65JjupY6SZhz+WflufPgr2GzyYH892RJ8YR
            AwEIB8K+BBgWCgBwBYJno6hACZCPiBaAnzDerEUUAAAAAAAcACBzYWx0QG5vdGF0
            aW9ucy5vcGVucGdwanMub3JnK+KgEcPTLFs94wRo8IuFuv6wzZBjq85tV1W5h9eN
            tnoCmwwWIQSidx+LNjyo52l2fy+PiBaAnzDerAAAr8cBAMvnWbny02GHqYFEcDgN
            RG8pI+XJkA7Tz1ybdtT9jdUwAP0bhWp5kF7zAOmL4bYG16jtIa+HUQmqV61ZlfT7
            tA6CAA==
            =Se40
            -----END PGP PUBLIC KEY BLOCK-----
          '';
          trust = "ultimate";
        }
      ];
      settings = {
        use-agent = true;
        pinentry-mode = "ask";
      };
    };

    ssh = {
      enable = true;
      enableDefaultConfig = false;
      matchBlocks =
        let
          shared = {
            user = env.user.name;
            port = 22;
          };
        in
        {
          ganymede = {
            host = "ganymede";
            hostname = "192.168.1.50";
          }
          // shared;
          galileo = {
            host = "galileo";
            hostname = "192.168.1.51";
          }
          // shared;
          galilei = {
            host = "galilei";
            hostname = "192.168.1.52";
          }
          // shared;
        };
    };

    vscode = {
      enable = true;
      package = pkgs.vscodium;
      mutableExtensionsDir = false;
      profiles.default = {
        enableExtensionUpdateCheck = false;
        enableUpdateCheck = false;
        extensions = with pkgs.vscode-extensions; [
          bierner.github-markdown-preview
          bmalehorn.vscode-fish
          editorconfig.editorconfig
          github.vscode-github-actions
          github.vscode-pull-request-github
          jdinhlife.gruvbox
          jnoortheen.nix-ide
          ms-python.python
          nefrob.vscode-just-syntax
          pkief.material-icon-theme
          rust-lang.rust-analyzer
          tamasfe.even-better-toml
        ];
        userSettings = {
          chat.disableAIFeatures = true;
          editor = {
            autoIndent = "full";
            autoIndentOnPaste = true;
            cursorBlinking = "smooth";
            cursorSmoothCaretAnimation = "on";
            cursorStyle = "underline";
            fontFamily = "'JetBrainsMono Nerd Font', monospace";
            fontLigatures = true;
            fontSize = 14;
            inertialScroll = true;
            minimap.enabled = true;
            overtypeCursorStyle = "underline";
            smoothScrolling = true;
            tabCompletion = "on";
            tabSize = 2;
            trimWhitespaceOnDelete = true;
            unfoldOnClickAfterEndOfLine = true;
            wordWrap = "off";
            wordWrapColumn = 100;
          };
          explorer = {
            confirmDelete = false;
            confirmDragAndDrop = false;
          };
          extensions = {
            autoCheckUpdates = false;
            autoUpdate = false;
            closeExtensionDetailsOnViewChange = true;
            ignoreRecommendations = true;
            verifySignature = false;
          };
          files = {
            autoSave = "onFocusChange";
            autoSaveWhenNoErrors = true;
            autoSaveWorkspaceFilesOnly = true;
            eol = "\n";
            insertFinalNewline = true;
            simpleDialog.enable = true;
            trimFinalNewlines = true;
          };
          scm = {
            alwaysShowActions = true;
            alwaysShowRepositories = true;
            defaultViewMode = "tree";
            providerCountBadge = "auto";
            repositories.explorer = true;
          };
          search = {
            defaultViewMode = "tree";
            showLineNumbers = true;
            smartCase = true;
          };
          terminal.integrated = {
            cursorBlinking = true;
            cursorStyle = "underline";
            cursorStyleInactive = "line";
            defaultProfile.linux = "fish";
            enableImages = true;
            fontFamily = "'JetBrainsMono Nerd Font', monospace";
            fontLigatures.enabled = true;
            gpuAcceleration = "on";
            smoothScrolling = true;
          };
          update.showReleaseNotes = false;
          window.autoDetectColorScheme = true;
          workbench = {
            editor.showTabIndex = true;
            externalBrowser = "${profile_dir}/bin/brave";
            iconTheme = "material-icon-theme";
            preferredDarkColorTheme = "Gruvbox Dark Medium";
            preferredLightColorTheme = "Gruvbox Light Medium";
            startupEditor = "none";
            tips.enabled = false;
            tree.renderIndentGuides = "always";
          };
        };
      };
    };
    zoxide = {
      enable = true;
      enableFishIntegration = fish_enabled;
      options = [ "--cmd cd" ];
    };
  };

  services.gpg-agent = lib.mkIf gpg_enabled rec {
    enable = true;
    enableFishIntegration = fish_enabled;
    enableSshSupport = true;
    defaultCacheTtl = 3600;
    defaultCacheTtlSsh = defaultCacheTtl;
    extraConfig = ''
      allow-loopback-pinentry
    '';
    grabKeyboardAndMouse = false;
    maxCacheTtl = 7200;
    maxCacheTtlSsh = maxCacheTtl;
    noAllowExternalCache = true;
    pinentry.package = pkgs.pinentry-curses;
    verbose = true;
  };

  xdg = {
    enable = true;
    autostart =
      let
        dpath = "${config.xdg.dataHome}/applications";
      in
      {
        enable = true;
        entries = [
          "${dpath}/Debian-VM.desktop"
          "${dpath}/FreeBSD-VM.desktop"
          "${dpath}/OmniOS-VM.desktop"
        ];
        readOnly = true;
      };
    userDirs = {
      enable = true;
      createDirectories = true;
      desktop = null;
      documents = "${env.path.home}/Documents";
      download = "${env.path.home}/Downloads";
      music = null;
      pictures = "${env.path.home}/Pictures";
      publicShare = null;
      templates = null;
      videos = null;
      extraConfig = {
        XDG_PROJECTS_DIR = env.path.projects;
      };
    };
  };
}
