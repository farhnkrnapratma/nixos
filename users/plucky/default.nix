{ config
, lib
, pkgs
, ...
}:
let
  CodiumIsEnabled = config.programs.vscode.enable;
  CodiumOrNano = if CodiumIsEnabled then "codium" else "nano";
in
{
  home = rec {
    username = "plucky";
    homeDirectory = "/home/${username}";
    packages =
      with pkgs;
      [
        appflowy
        blanket
        discord
        element-desktop
        github-copilot-cli
        keypunch
        localsend
        onlyoffice-desktopeditors
        planify
        resources
        signal-desktop
        telegram-desktop
      ]
      ++ lib.optionals CodiumIsEnabled [
        shellcheck
        shfmt
      ];
    sessionVariables = rec {
      EDITOR = CodiumOrNano;
      VISUAL = EDITOR;
    };
  };

  programs = {
    vscode = {
      enable = true;
      package = pkgs.vscodium;
      mutableExtensionsDir = false;
      profiles.default = {
        extensions = with pkgs.vscode-extensions; [
          bierner.github-markdown-preview
          bmalehorn.vscode-fish
          editorconfig.editorconfig
          egirlcatnip.adwaita-github-theme
          github.vscode-github-actions
          github.github-vscode-theme
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
            fontFamily = "'Adwaita Mono', monospace";
            fontLigatures = true;
            fontSize = 14;
            inertialScroll = true;
            wordWrap = "off";
            cursorSmoothCaretAnimation = "on";
            cursorStyle = "underline";
            overtypeCursorStyle = "underline";
            smoothScrolling = true;
            tabSize = 2;
            trimWhitespaceOnDelete = true;
            unfoldOnClickAfterEndOfLine = true;
            minimap.enabled = false;
            tabCompletion = "on";
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
            accessibleViewFocusOnCommandExecution = true;
            accessibleViewPreserveCursorPosition = true;
            cursorBlinking = true;
            cursorStyle = "underline";
            cursorStyleInactive = "line";
            defaultProfile.linux = "fish";
            enableImages = true;
            fontFamily = "'Adwaita Mono', monospace";
            fontLigatures.enabled = true;
            gpuAcceleration = "on";
            smoothScrolling = true;
          };
          update.showReleaseNotes = false;
          window.autoDetectColorScheme = true;
          workbench = {
            editor.showTabIndex = true;
            externalBrowser = "/etc/profiles/per-user/plucky/bin/brave";
            iconTheme = "material-icon-theme";
            colorTheme = "GitHub Dark Dimmed";
            preferredDarkColorTheme = "GitHub Dark Dimmed";
            preferredLightColorTheme = "GitHub Light Default";
            startupEditor = "none";
            tips.enabled = false;
            tree.renderIndentGuides = "always";
          };
        };
      };
    };

    gh = {
      enable = true;
      gitCredentialHelper = {
        enable = true;
        hosts = [ "https://github.com" ];
      };
      hosts."github.com".user = "farhnkrnapratma";
      settings = {
        aliases = {
          clone = "repo clone";
          delete = "repo delete --yes";
          login = "auth login -cwh github.com -p https --skip-ssh-key";
          logout = "auth logout -h github.com -u farhnkrnapratma";
          ls = "repo ls";
          refresh = "auth refresh -ch github.com";
          sync = "repo sync";
        };
        git_protocol = "https";
        editor = CodiumOrNano;
      };
    };

    git = {
      enable = true;
      maintenance = {
        enable = true;
        repositories = [
          "/home/plucky/Projects/nixos"
          "/home/plucky/Projects/data"
        ];
        timers = {
          daily = "daily";
          hourly = "hourly";
          weekly = "weekly";
        };
      };
      settings = {
        core = {
          whitespace = "trailing-space,space-before-tab";
          editor = CodiumOrNano;
        };
        init.defaultBranch = "main";
        user = {
          email = "farhnkrnapratma@gmail.com";
          name = "Farhan Kurnia Pratama";
        };
      };
      signing = lib.mkIf config.programs.gpg.enable {
        format = "openpgp";
        key = "440D2C6DF110AF257A97C26507723A92A04788B3";
        signByDefault = lib.mkIf config.services.gpg-agent.enable true;
        signer = "${config.home.profileDirectory}/bin/gpg";
      };
    };

    gpg = {
      enable = true;
      publicKeys = [
        {
          text = ''
            -----BEGIN PGP PUBLIC KEY BLOCK-----
            Comment: 440D 2C6D F110 AF25 7A97  C265 0772 3A92 A047 88B3
            Comment: farhnkrnapratma@gmail.com <farhnkrnapratma@gmail.com>

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
            Comment: farhnkrnapratma@protonmail.com <farhnkrnapratma@protonm

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
  };

  services.gpg-agent = {
    enable = true;
    enableFishIntegration = lib.mkIf config.programs.fish.enable true;
    noAllowExternalCache = true;
    pinentry.package = pkgs.pinentry-all;
  };
}
