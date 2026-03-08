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
    ./fonts
  ];

  boot = {
    kernelPackages = pkgs.linuxPackagesFor pkgs.linuxKernel.kernels.linux_zen;
    extraModulePackages = [ pkgs.linuxKernel.packages.linux_zen.virtualbox ];
    kernelModules = [ "kvm-intel" ];
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
    initrd = {
      availableKernelModules = [
        "nvme"
        "sd_mod"
      ];
      verbose = false;
    };
    consoleLogLevel = 0;
  };

  documentation.nixos.enable = false;

  environment = {
    shells = [ pkgs.fish ];
    cosmic.excludePackages = with pkgs; [
      cosmic-edit
      cosmic-files
      cosmic-player
      cosmic-store
      cosmic-term
      cosmic-reader
      rygel
    ];
  };

  fileSystems = {
    "/boot" = {
      device = env.part.boot;
      fsType = "vfat";
      mountPoint = "/boot";
      autoFormat = true;
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
      fsType = "ext4";
      encrypted = {
        enable = true;
        blkDev = env.part.root;
        label = env.part.luks;
      };
      options = [
        "noatime"
        "errors=remount-ro"
      ];
    };
  };

  hardware.firmwareCompression = "zstd";

  home-manager = {
    users.${env.user.name} = import ../User;
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "bak";
    overwriteBackup = true;
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
    hostName = env.user.host;
    domain = env.user.domain;
    search = [ env.user.domain ];
    tempAddresses = "enabled";
    nftables.enable = true;
    firewall = {
      enable = true;
      allowedTCPPorts = [ 65535 ];
      checkReversePath = true;
      filterForward = true;
      allowPing = true;
      pingLimit = "1/minute burst 5 packets";
    };
    networkmanager = {
      enable = true;
      dhcp = "internal";
      dns = "systemd-resolved";
      wifi = {
        backend = "iwd";
        macAddress = "random";
        powersave = false;
        scanRandMacAddress = true;
      };
      ethernet.macAddress = "random";
      logLevel = "OFF";
    };
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

  programs.nix-ld.enable = true;

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
    desktopManager.cosmic = {
      enable = true;
      showExcludedPkgsWarning = false;
      xwayland.enable = true;
    };
    displayManager.cosmic-greeter.enable = true;
    gnome = {
      gnome-keyring.enable = true;
      sushi.enable = true;
    };
    openssh = {
      enable = true;
      ports = [ 65535 ];
      allowSFTP = false;
      generateHostKeys = false;
      startWhenNeeded = true;
      banner = ''
        Hey, there!
        You're going to access this machine: ${env.user.name}@${env.user.host}
        (i) Only authorized keys can access this machine!
      '';
      knownHosts = {
        termius = {
          publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHp60gbkkzDf8urz76/Wbq6td4/0gCjmjDh2T/GaqBTd Farhan Kurnia Pratama";
          certAuthority = true;
        };
        termux = {
          publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJVDKzJp2tFsXc0B+S0cKjqs3Gulp31lY2pV/E1r2Rmy Farhan Kurnia Pratama";
          certAuthority = true;
        };
      };
      settings = {
        KbdInteractiveAuthentication = false;
        LogLevel = "VERBOSE";
        PasswordAuthentication = false;
        PermitRootLogin = "no";
        UseDns = true;
        PrintLastLog = "no";
        PrintMotd = false;
      };
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
        DNS = [
          "1.1.1.1#cloudflare-dns.com"
          "[2606:4700:4700::1111]#cloudflare-dns.com"
        ];
        FallbackDNS = [
          "9.9.9.9#dns.quad9.net"
          "[2620:fe::fe]#dns.quad9.net"
        ];
        DNSOverTLS = "opportunistic";
        DNSSEC = "allow-downgrade";
        DNSStubListener = "yes";
        MulticastDNS = "no";
        Cache = "yes";
        LLMNR = "no";
        StaleRetentionSec = "300";
      };
    };
  };

  system = {
    stateVersion = env.version;
    autoUpgrade = {
      enable = true;
      dates = "daily";
      fixedRandomDelay = true;
      flake = env.path.flake;
      operation = "switch";
      upgrade = false;
      runGarbageCollection = true;
      randomizedDelaySec = "10min";
      allowReboot = true;
      rebootWindow = {
        lower = "00:00";
        upper = "03:00";
      };
    };
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
        expires = "2030-01-01";
        extraGroups = [
          "audio"
          "networkmanager"
          "video"
          "wheel"
          "vboxusers"
        ];
        group = env.user.name;
        homeMode = "0700";
        ignoreShellProgramCheck = true;
        initialHashedPassword = "$6$ASMi1cF9jL1HgY/X$dnUd2rGPXGB77FGry8odE/gTXOD62dZDiwfnB2/YTpjasF4c9VRD/5YoQiFhflwO0yn.XmxOTueLQAmCFgMfc.";
        isNormalUser = true;
        shell = pkgs.fish;
        uid = env.user.guid;
      };
      root.initialHashedPassword = "!";
    };
  };

  virtualisation.virtualbox.host.enable = true;

  zramSwap = {
    enable = true;
    memoryPercent = 35;
  };
}
