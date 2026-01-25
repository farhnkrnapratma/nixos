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
    packages = with pkgs; [
      amberol
      appflowy
      baobab
      blanket
      discord
      exercise-timer
      github-copilot-cli
      keypunch
      localsend
      newsflash
      onlyoffice-desktopeditors
      planify
      protonvpn-gui
      resources
      shortwave
      showtime
      signal-desktop
      spotify
      telegram-desktop
    ] ++ lib.optionals CodiumIsEnabled [
      nixfmt
      shellcheck
      shfmt
    ];
    sessionVariables = {
      EDITOR = CodiumOrNano;
      VISUAL = CodiumOrNano;
    };
  };

  programs = {
    vscode = {
      enable = true;
      package = pkgs.vscodium;
      mutableExtensionsDir = false;
      profiles.default = {
        extensions = with pkgs.vscode-extensions; [
          astro-build.astro-vscode
          bierner.github-markdown-preview
          bmalehorn.vscode-fish
          editorconfig.editorconfig
          enkia.tokyo-night
          github.vscode-github-actions
          github.vscode-pull-request-github
          jgclark.vscode-todo-highlight
          jnoortheen.nix-ide
          mads-hartmann.bash-ide-vscode
          ms-python.debugpy
          ms-python.flake8
          ms-python.mypy-type-checker
          ms-python.pylint
          ms-python.python
          ms-python.vscode-pylance
          pkief.material-icon-theme
          redhat.java
          rust-lang.rust-analyzer
          tamasfe.even-better-toml
          unifiedjs.vscode-mdx
        ];
        userSettings = {
          "chat.disableAIFeatures" = true;
          "debug.console.fontFamily" = "'Adwaita Mono', monospace";
          "editor.autoIndent" = "full";
          "editor.formatOnSave" = true;
          "editor.fontFamily" = "'Adwaita Mono', monospace";
          "editor.fontLigatures" = true;
          "editor.fontSize" = 14;
          "editor.wordWrap" = "off";
          "editor.cursorSmoothCaretAnimation" = "on";
          "editor.cursorStyle" = "underline";
          "editor.overtypeCursorStyle" = "underline";
          "editor.tabSize" = 4;
          "editor.minimap.enabled" = false;
          "editor.tabCompletion" = "on";
          "explorer.confirmDelete" = false;
          "explorer.confirmDragAndDrop" = false;
          "files.autoSave" = "onFocusChange";
          "redhat.telemetry.enabled" = false;
          "scm.inputFontFamily" = "'Adwaita Mono', monospace";
          "terminal.integrated.fontFamily" = "'Adwaita Mono', monospace";
          "terminal.integrated.fontLigatures.enabled" = true;
          "terminal.integrated.fontLigatures.featureSettings" = "\"calt\" on, \"liga\" on";
          "terminal.integrated.cursorStyle" = "underline";
          "terminal.integrated.cursorStyleInactive" = "line";
          "terminal.integrated.cursorBlinking" = true;
          "workbench.startupEditor" = "none";
          "workbench.iconTheme" = "material-icon-theme";
          "workbench.colorTheme" = "GitHub Dark";
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
          "/etc/nixos"
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
