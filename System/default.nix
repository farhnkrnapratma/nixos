{
  inputs,
  modulesPath,
  pkgs,
  ...
}:
let
  my = import ../Shared;
in
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    inputs.home-manager.nixosModules.home-manager
    inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t480s
  ];

  boot = {
    consoleLogLevel = 0;
    initrd = {
      availableKernelModules = [
        "nvme"
        "sd_mod"
      ];
      verbose = false;
    };
    kernelPackages = pkgs.linuxPackagesFor pkgs.linuxKernel.kernels.linux_zen;
    kernelParams = [
      "quiet"
      "udev.log_level=err"
    ];
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

  documentation.nixos.enable = false;

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

  fonts = {
    fontconfig = {
      defaultFonts = {
        monospace = [ "AdwaitaMono Nerd Font" ];
        sansSerif = [ "Adwaita Sans" ];
        serif = [ "Liberation Serif" ];
      };
    };
    packages = with pkgs; [
      adwaita-fonts
      noto-fonts-cjk-sans
      nerd-fonts.adwaita-mono
    ];
  };

  fileSystems = {
    "/boot" = {
      autoFormat = true;
      device = my.part.boot;
      fsType = "vfat";
      mountPoint = "/boot";
      options = [
        "noatime"
        "nodev"
        "nosuid"
        "noexec"
        "umask=0077"
      ];
    };
    "/" = {
      device = my.part.mapper;
      encrypted = {
        enable = true;
        blkDev = my.part.root;
        label = my.part.luks;
      };
      fsType = "ext4";
      options = [
        "noatime"
        "errors=remount-ro"
      ];
    };
  };

  hardware = {
    bluetooth.enable = false;
    firmwareCompression = "zstd";
  };

  home-manager = {
    backupFileExtension = "bak";
    overwriteBackup = true;
    useGlobalPkgs = true;
    users.${my.user.name} = import ../User;
    useUserPackages = true;
    verbose = true;
  };

  i18n = {
    defaultLocale = "C.UTF-8";
    extraLocaleSettings = {
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
  };

  networking = {
    enableIPv6 = true;
    firewall = {
      enable = true;
      allowPing = true;
      checkReversePath = true;
      filterForward = true;
      pingLimit = "1/minute burst 3 packets";
      rejectPackets = true;
    };
    hostName = my.user.host;
    networkmanager = {
      enable = true;
      dhcp = "internal";
      dns = "systemd-resolved";
      ethernet.macAddress = "random";
      logLevel = "OFF";
      wifi = {
        backend = "iwd";
        macAddress = "random";
        powersave = false;
        scanRandMacAddress = true;
      };
    };
    nftables.enable = true;
    tempAddresses = "enabled";
    timeServers = [
      "0.id.pool.ntp.org"
      "1.id.pool.ntp.org"
      "2.id.pool.ntp.org"
      "3.id.pool.ntp.org"
    ];
  };

  nix = rec {
    enable = true;
    checkAllErrors = true;
    checkConfig = true;
    gc = {
      automatic = true;
      dates = "daily";
      persistent = true;
      randomizedDelaySec = "10min";
    };
    optimise = gc;
    settings = {
      auto-optimise-store = true;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
  };

  nixpkgs.config.allowUnfree = true;

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
      cosmic = {
        enable = true;
        showExcludedPkgsWarning = false;
        xwayland.enable = true;
      };
    };
    displayManager.cosmic-greeter.enable = true;
    gnome = {
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
        Cache = "yes";
        DNS = [
          "1.1.1.1#cloudflare-dns.com"
          "[2606:4700:4700::1111]#cloudflare-dns.com"
        ];
        DNSOverTLS = "opportunistic";
        DNSSEC = "allow-downgrade";
        DNSStubListener = "yes";
        FallbackDNS = [
          "9.9.9.9#dns.quad9.net"
          "[2620:fe::fe]#dns.quad9.net"
        ];
        LLMNR = "no";
        MulticastDNS = "no";
        StaleRetentionSec = "300";
      };
    };
  };

  system = {
    autoUpgrade = {
      enable = true;
      allowReboot = true;
      dates = "daily";
      fixedRandomDelay = true;
      flake = my.path.flake;
      operation = "switch";
      randomizedDelaySec = "10min";
      rebootWindow = {
        lower = "01:00";
        upper = "05:00";
      };
      runGarbageCollection = true;
      upgrade = false;
    };
    stateVersion = "26.05";
  };

  time.timeZone = "Asia/Jakarta";

  users = {
    mutableUsers = false;
    groups.${my.user.name} = rec {
      gid = my.user.guid;
      members = [ name ];
      name = my.user.name;
    };
    users = {
      ${my.user.name} = {
        createHome = true;
        description = my.user.desc;
        expires = "2036-01-01";
        extraGroups = [
          "audio"
          "networkmanager"
          "video"
          "wheel"
        ];
        group = my.user.name;
        homeMode = "0700";
        ignoreShellProgramCheck = true;
        initialHashedPassword = "$6$ASMi1cF9jL1HgY/X$dnUd2rGPXGB77FGry8odE/gTXOD62dZDiwfnB2/YTpjasF4c9VRD/5YoQiFhflwO0yn.XmxOTueLQAmCFgMfc.";
        isNormalUser = true;
        shell = pkgs.fish;
        uid = my.user.guid;
      };
      root.initialHashedPassword = "!";
    };
  };

  zramSwap = {
    enable = true;
    algorithm = "lz4";
    memoryMax = 3221225472;
    memoryPercent = 40;
  };
}
