{
  config,
  lib,
  pkgs,
  ...
}:
let
  my = import ../Shared;
  profile_directory = config.home.profileDirectory;
  fish_enabled = config.programs.fish.enable;
  gpg_enabled = config.programs.gpg.enable;
in
{
  editorconfig = {
    enable = true;
    settings = {
      "*" = {
        charset = "utf-8";
        end_of_line = "lf";
        indent_size = 2;
        indent_style = "space";
        insert_final_newline = true;
        trim_trailing_whitespace = true;
      };
    };
  };

  home = {
    uid = my.user.guid;
    username = my.user.name;
    enableNixpkgsReleaseCheck = true;
    homeDirectory = my.path.home;
    stateVersion = my.tag;
    packages = with pkgs; [
      # GUI
      brave
      discord
      gnome-calculator
      gnome-characters
      gnome-clocks
      joplin-desktop
      loupe
      nautilus
      onlyoffice-desktopeditors
      papers
      planify
      resources
      seahorse
      signal-desktop
      snapshot
      telegram-desktop
      # CLI
      codeberg-cli
      gemini-cli
      github-copilot-cli
      glab
      qwen-code
      shellcheck
      shfmt
      tea
      wl-clipboard
      # Misc
      gnome-keyring
      libgnome-keyring
      yaru-theme
    ];
    sessionVariables = rec {
      VISUAL = my.user.edit;
      EDITOR = VISUAL;
    };
    shell = {
      enableFishIntegration = true;
      enableShellIntegration = true;
    };
  };

  programs = {
    aria2 = {
      enable = true;
      settings = {
        max-concurrent-downloads = 6;
        split = 12;
        max-connection-per-server = 6;
        min-split-size = "4M";
        optimize-concurrent-downloads = "true";
        file-allocation = "falloc";
        disk-cache = "64M";
        continue = true;
        retry-wait = 2;
        max-tries = 0;
        lowest-speed-limit = "20K";
        timeout = 60;
        connect-timeout = 20;
        check-certificate = true;
        min-tls-version = "TLSv1.2";
        http-accept-gzip = true;
        enable-dht = true;
        enable-dht6 = true;
        enable-peer-exchange = true;
        bt-enable-lpd = true;
        bt-request-peer-speed-limit = "200K";
        max-upload-limit = "0";
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
        theme-dark = "OneHalfDark";
        theme-light = "OneHalfLight";
        wrap = "auto";
      };
    };

    eza = {
      enable = true;
      enableFishIntegration = true;
      colors = "auto";
      git = true;
      icons = "auto";
    };

    fish = {
      enable = true;
      generateCompletions = true;
      interactiveShellInit = ''
        set fish_greeting

        function fish_right_prompt
          date +"%H:%M:%S"
        end

        function shell
          set cmd --command fish --interactive --private
          if test -f "flake.nix"
              nix shell $cmd
          else if test (count $argv) -eq 0
              echo "[!] No packages specified and no 'flake.nix' file found in the working directory"
              return 1
          else
              nix shell $argv $cmd
          end
        end

        function commit
          git rev-parse --is-inside-work-tree >/dev/null 2>&1
          or begin
              echo "[!] Not in a git repository"
              return 1
          end

          set -l cmsg $argv[1]
          set -l mode $argv[2]
          set -l files $argv[3..-1]

          test -n "$cmsg"
          or begin
              echo "[!] Commit messages cannot be empty"
              return 1
          end

          test -n "$mode"; or set mode a

          echo "[1/3] Adding change(s) to the staging area..."
          switch $mode
              case a
                  git add -A
              case f
                  if test (count $files) -eq 0
                      echo "[!] No files specified for mode 'f'"
                      return 1
                  end
                  for f in $files
                      test -e "$f"
                      or begin
                          echo "[!] File not found: $f"
                          return 1
                      end
                  end
                  git add $files
              case '*'
                  echo "[!] Invalid mode: $mode"
                  return 1
          end
          or begin
              echo "[!] Failed at step 1/3"
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
          set -l orig_dir (pwd)
          set -l flakes_updated false

          function _fail --argument-names step
              echo "[!] Failed at step $step"
              cd $orig_dir 2>/dev/null
              return 1
          end

          echo "[1/7] Change directory to flake repository..."
          cd ${my.path.flake}; or _fail "1/7"
          echo "[1/7] Done."

          echo "[2/7] Updating flakes..."
          nix flake update; or _fail "2/7"
          git diff --quiet -- flake.lock; or set flakes_updated true
          test "$flakes_updated" = false; and echo "[!] No flakes updates available"
          echo "[2/7] Done."

          echo "[3/7] Formatting repository..."
          nix fmt; or _fail "3/7"
          echo "[3/7] Done."

          if test "$flakes_updated" = true
              echo "[4/7] Pushing changes to remote repository..."
              commit "nixos: update flake"; or _fail "4/7"
              echo "[4/7] Done."

              echo "[5/7] Rebuilding host system..."
              sudo nixos-rebuild switch --flake; or _fail "5/7"
              echo "[5/7] Done."

              echo "[6/7] Deleting older generations..."
              sudo nix-collect-garbage -d; or _fail "6/7"
              echo "[6/7] Done."
          else
              echo "[!] Skipping step [4-6]... Done."
          end

          echo "[7/7] Back to last directory..."
          cd $orig_dir; or _fail "7/7"
          echo "[7/7] Done."

          functions -e _fail
        end
      '';
      preferAbbrs = true;
      shellAbbrs = {
        c = "clear";
        cat = "bat";
        l = "eza -lahgmuU --smart-group";
        ls = "eza";
        nfc = "nix flake check";
        nft = "nix fmt";
        nfu = "nix flake update --flake ${my.path.flake}";
        ngc = "sudo nix-collect-garbage -d";
        nrs = "sudo nixos-rebuild switch --flake ${my.path.flake}";
        x = "exit";
      };
    };

    gh = {
      enable = true;
      gitCredentialHelper = {
        enable = true;
        hosts = [ "https://github.com" ];
      };
      hosts."github.com".user = my.user.name;
      settings = {
        aliases = {
          clone = "repo clone";
          delete = "repo delete --yes";
          login = "auth login -cwh github.com -p https --skip-ssh-key";
          logout = "auth logout -h github.com -u ${my.user.name}";
          ls = "repo ls";
          refresh = "auth refresh -ch github.com";
          sync = "repo sync";
        };
        editor = my.user.edit;
        git_protocol = "https";
      };
    };

    ghostty = {
      enable = true;
      clearDefaultKeybinds = false;
      enableFishIntegration = lib.mkIf fish_enabled true;
      installBatSyntax = true;
      settings = {
        adjust-cell-height = "15%";
        background-opacity = 1;
        cursor-style = "underline";
        cursor-style-blink = true;
        font-family = "Adwaita Mono";
        font-feature = "+calt, +liga, +dlig";
        font-size = 11;
        link-previews = true;
        shell-integration = if fish_enabled then "fish" else "detect";
        shell-integration-features = "no-cursor";
        theme = "dark:Adwaita Dark,light:Adwaita";
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
          "${my.path.projects}/cache"
          "${my.path.flake}"
        ];
        timers = {
          daily = "daily";
          hourly = "hourly";
          weekly = "weekly";
        };
      };
      settings = {
        core = {
          editor = my.user.edit;
          whitespace = "trailing-space,space-before-tab";
        };
        init.defaultBranch = "main";
        user = {
          email = "${my.user.name}@gmail.com";
          name = my.user.desc;
        };
      };
      signing = lib.mkIf gpg_enabled {
        format = "openpgp";
        key = "440D2C6DF110AF257A97C26507723A92A04788B3";
        signByDefault = true;
        signer = "${profile_directory}/bin/gpg";
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
          egirlcatnip.adwaita-github-theme
          github.vscode-github-actions
          github.vscode-pull-request-github
          jnoortheen.nix-ide
          mads-hartmann.bash-ide-vscode
          ms-python.python
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
            fontFamily = "'Adwaita Mono', monospace";
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
            fontFamily = "'AdwaitaMono Nerd Font', monospace";
            fontLigatures.enabled = true;
            gpuAcceleration = "on";
            smoothScrolling = true;
          };
          update.showReleaseNotes = false;
          window.autoDetectColorScheme = true;
          workbench = rec {
            colorTheme = "Adwaita Dark & Github syntax highlighting";
            editor.showTabIndex = true;
            externalBrowser = "${profile_directory}/bin/brave";
            iconTheme = "material-icon-theme";
            preferredDarkColorTheme = colorTheme;
            preferredLightColorTheme = "Adwaita Light & Github syntax highlighting";
            startupEditor = "none";
            tips.enabled = false;
            tree.renderIndentGuides = "always";
          };
        };
      };
    };
    zoxide = {
      enable = true;
      enableFishIntegration = true;
      options = [ "--cmd cd" ];
    };
  };

  services.gpg-agent = lib.mkIf gpg_enabled {
    enable = true;
    enableFishIntegration = lib.mkIf fish_enabled true;
    noAllowExternalCache = true;
    pinentry.package = pkgs.pinentry-all;
  };

  xdg.userDirs = {
    enable = true;
    createDirectories = true;
    desktop = null;
    documents = "${my.path.home}/Documents";
    download = "${my.path.home}/Downloads";
    music = null;
    pictures = "${my.path.home}/Pictures";
    publicShare = null;
    templates = null;
    videos = null;
    extraConfig = {
      XDG_PROJECTS_DIR = my.path.projects;
    };
  };
}
