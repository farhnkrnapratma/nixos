{
  inputs,
  modulesPath,
  pkgs,
  ...
}:
let
  env = import ../Shared;
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
    kernelModules = [ "kvm-intel" ];
    kernelParams = [
      "quiet"
      "udev.log_level=err"
    ];
    extraModulePackages = [ pkgs.linuxKernel.packages.linux_zen.virtualbox ];
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
    fontconfig.defaultFonts = {
      monospace = [ "Noto Sans Mono" ];
      sansSerif = [ "Noto Sans" ];
      serif = [ "Noto Serif" ];
    };
    packages = with pkgs; [
      noto-fonts-cjk-sans
      nerd-fonts.jetbrains-mono
    ];
  };

  fileSystems = {
    "/boot" = {
      autoFormat = true;
      device = env.part.boot;
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
      device = env.part.mapper;
      encrypted = {
        enable = true;
        blkDev = env.part.root;
        label = env.part.luks;
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
    users.${env.user.name} = import ../User;
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
    hostName = env.user.host;
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
    openssh = {
      enable = true;
      banner = ''
        Hey, there!
        You're going to access
        this machine: ${env.user.name}@${env.user.host}
        [i] Only authorized keys can access this machine!
        That's it. Welcome!
      '';
      knownHosts.termux.publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJVDKzJp2tFsXc0B+S0cKjqs3Gulp31lY2pV/E1r2Rmy Farhan Kurnia Pratama";
      settings = {
        KbdInteractiveAuthentication = false;
        LogLevel = "VERBOSE";
        PasswordAuthentication = false;
        PermitRootLogin = "no";
      };
      startWhenNeeded = true;
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
      flake = env.path.flake;
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
    groups.${env.user.name} = rec {
      gid = env.user.guid;
      members = [ name ];
      name = env.user.name;
    };
    users = {
      ${env.user.name} = {
        createHome = true;
        description = env.user.desc;
        expires = "2036-01-01";
        extraGroups = [
          "audio"
          "networkmanager"
          "video"
          "vboxusers"
          "wheel"
        ];
        group = env.user.name;
        homeMode = "0700";
        ignoreShellProgramCheck = true;
        initialHashedPassword = "$6$ASMi1cF9jL1HgY/X$dnUd2rGPXGB77FGry8odE/gTXOD62dZDiwfnB2/YTpjasF4c9VRD/5YoQiFhflwO0yn.XmxOTueLQAmCFgMfc.";
        isNormalUser = true;
        shell = pkgs.fish;
        uid = env.user.guid;
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJVDKzJp2tFsXc0B+S0cKjqs3Gulp31lY2pV/E1r2Rmy Farhan Kurnia Pratama"
        ];
      };
      root.initialHashedPassword = "!";
    };
  };

  virtualisation.virtualbox.host = {
    enable = true;
    package = pkgs.virtualboxKvm;
    addNetworkInterface = false;
    enableHardening = true;
    enableKvm = true;
  };

  zramSwap = {
    enable = true;
    algorithm = "lz4";
    memoryMax = 3221225472;
    memoryPercent = 40;
  };
}
