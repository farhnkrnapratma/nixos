{ config
, lib
, pkgs
, ...
}:
let
  NixSchedule = {
    automatic = true;
    dates = "daily";
    persistent = true;
    randomizedDelaySec = "10min";
  };
in
{
  imports = [ ./hardware-configuration.nix ];
  boot = {
    consoleLogLevel = 7;
    initrd = {
      availableKernelModules = [
        "nvme"
        "sd_mod"
      ];
      compressor = "zstd";
    };
    kernelPackages = pkgs.linuxPackages_latest;
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot = {
        enable = true;
        configurationLimit = 20;
        consoleMode = "auto";
        editor = false;
      };
      timeout = 3;
    };
  };

  console = {
    enable = true;
    earlySetup = true;
    font = "ter-v16n";
    keyMap = "us";
    packages = [ pkgs.terminus_font ];
  };

  documentation = {
    dev.enable = false;
    doc.enable = false;
    info.enable = false;
    man.enable = false;
    nixos.enable = false;
  };

  environment = {
    cosmic.excludePackages = with pkgs; [
      cosmic-edit
      cosmic-files
      cosmic-player
      cosmic-store
      cosmic-term
      cosmic-reader
      rygel
    ];
    shells = [ pkgs.fish ];
  };

  fonts.packages = with pkgs; [
    adwaita-fonts
    jetbrains-mono
  ];

  hardware = {
    bluetooth.enable = false;
    firmwareCompression = "zstd";
  };

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "id_ID.UTF-8";
    LC_IDENTIFICATION = "id_ID.UTF-8";
    LC_MEASUREMENT = "C.UTF-8";
    LC_MONETARY = "id_ID.UTF-8";
    LC_NAME = "id_ID.UTF-8";
    LC_NUMERIC = "C.UTF-8";
    LC_PAPER = "id_ID.UTF-8";
    LC_TELEPHONE = "id_ID.UTF-8";
    LC_TIME = "C.UTF-8";
  };

  networking = {
    hostName = "puffin";
    enableIPv6 = true;
    tempAddresses = "enabled";
    timeServers = [
      "0.id.pool.ntp.org"
      "1.id.pool.ntp.org"
      "2.id.pool.ntp.org"
      "3.id.pool.ntp.org"
    ];
    nameservers = [
      "1.1.1.1"
      "9.9.9.9"
    ];
    networkmanager = {
      enable = true;
      dns = "systemd-resolved";
      dhcp = "internal";
      wifi = {
        scanRandMacAddress = true;
        powersave = false;
        macAddress = "random";
        backend = "iwd";
      };
      ethernet.macAddress = "random";
      logLevel = "OFF";
    };
    nftables.enable = true;
    firewall = {
      enable = lib.mkIf config.networking.nftables.enable true;
      backend = "nftables";
      allowPing = true;
      pingLimit = "1/minute burst 5 packets";
      filterForward = true;
      checkReversePath = "loose";
    };
  };

  nix = {
    enable = true;
    checkAllErrors = true;
    checkConfig = true;
    gc = NixSchedule;
    optimise = NixSchedule;
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      auto-optimise-store = true;
    };
  };

  nixpkgs.config.allowUnfree = true;

  programs = {
    chromium.enable = true;
    steam = {
      enable = true;
      dedicatedServer.openFirewall = true;
      remotePlay.openFirewall = true;
    };
  };

  security = {
    protectKernelImage = true;
    rtkit.enable = true;
    sudo-rs = {
      enable = true;
      execWheelOnly = true;
      wheelNeedsPassword = false;
    };
  };

  services = {
    desktopManager = {
      cosmic.enable = true;
      cosmic.showExcludedPkgsWarning = false;
      cosmic.xwayland.enable = true;
    };
    displayManager = {
      cosmic-greeter.enable = true;
    };
    gnome = {
      evolution-data-server.enable = true;
      gnome-keyring.enable = true;
      sushi.enable = true;
    };
    pipewire = {
      enable = true;
      alsa.enable = true;
      jack.enable = true;
      pulse.enable = true;
    };
    resolved = {
      enable = true;
      settings.Resolve = {
        DNSOverTLS = "opportunistic";
        DNSSEC = "allow-downgrade";
        FallbackDNS = [ "9.9.9.9" ];
      };
    };
  };

  system = {
    autoUpgrade = {
      enable = true;
      allowReboot = true;
      dates = "daily";
      fixedRandomDelay = true;
      flags = [
        "--update-input"
        "nixpkgs"
        "--commit-lock-file"
      ];
      flake = "/home/plucky/Projects/nixos";
      operation = "switch";
      randomizedDelaySec = "10min";
      rebootWindow = {
        lower = "01:00";
        upper = "05:00";
      };
      runGarbageCollection = true;
    };
    stateVersion = "26.05";
  };

  time.timeZone = "Asia/Jakarta";

  users = {
    mutableUsers = false;
    users = {
      root.hashedPassword = "!";
      plucky = {
        enable = true;
        createHome = true;
        description = "Plucky Puffin";
        expires = "2030-01-01";
        extraGroups = [
          "wheel"
          "networkmanager"
          "audio"
          "video"
        ];
        hashedPassword = "$6$ASMi1cF9jL1HgY/X$dnUd2rGPXGB77FGry8odE/gTXOD62dZDiwfnB2/YTpjasF4c9VRD/5YoQiFhflwO0yn.XmxOTueLQAmCFgMfc.";
        homeMode = "700";
        ignoreShellProgramCheck = true;
        isNormalUser = true;
        shell = pkgs.fish;
      };
    };
  };

  zramSwap = {
    enable = true;
    algorithm = "lz4";
    memoryMax = 3221225472;
    memoryPercent = 40;
  };
}
