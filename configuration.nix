{
  inputs,
  config,
  pkgs,

  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./config/sddm
    ./config/nix
  ];

  # Bootloader.
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.enable = true;
  boot.loader.grub.devices = [ "nodev" ];
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.useOSProber = true; # set to false if you only have NixOS installed or just remove the line

  networking.hostName = "interstellar"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;
  networking.stevenblack = {
    enable = true;
    block = [
      "fakenews"
      "gambling"
      "porn"
    ];
  };
  # Set your time zone.
  time.timeZone = "Asia/Kolkata";

  #file system
  boot.supportedFilesystems = [ "ntfs" ];
  fileSystems."/mnt/Localdisk" = {
    device = "/dev/disk/by-uuid/F21C2B081C2AC805";
    fsType = "ntfs-3g";
  };

  # Select internationalisation properties.
  i18n.defaultLocale = "en_IN";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_IN";
    LC_IDENTIFICATION = "en_IN";
    LC_MEASUREMENT = "en_IN";
    LC_MONETARY = "en_IN";
    LC_NAME = "en_IN";
    LC_NUMERIC = "en_IN";
    LC_PAPER = "en_IN";
    LC_TELEPHONE = "en_IN";
    LC_TIME = "en_IN";
  };
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  services.displayManager.sddm.enable = true;
  services.xserver = {
    enable = true;
    excludePackages = with pkgs; [
      xterm
    ];
    windowManager.bspwm.enable = true;
  };

  hardware.bluetooth.enable = true; # enables support for Bluetooth
  hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot
  services.blueman.enable = true;
  services.gvfs.enable = true;

  # users.defaultUserShell = pkgs.fish;
  users.defaultUserShell = pkgs.zsh;

  environment.shells = with pkgs; [
    # fish
    zsh
  ];
  programs.zsh.enable = true;
  # programs.fish.enable = true;

  users.users.gabbar = {
    # shell = pkgs.fish;
    shell = pkgs.zsh;
    isNormalUser = true;
    description = "gabbar";
    extraGroups = [
      "networkmanager"
      "wheel"
      "kvm"
      "adbusers"
    ];
    packages = with pkgs; [ ];
  };

  nixpkgs.config.allowUnfree = true;
  services.jellyfin = {
    enable = true;
    openFirewall = true;
  };

  environment.systemPackages = with pkgs; [
    man-pages
    man-pages-posix
    wget
    curl
    vesktop
    jellyfin
    jellyfin-web
    jellyfin-ffmpeg
    ispell
    git
    fastfetch
    eza

    insomnia
    nixd
    nixfmt-rfc-style
    zed-editor
    nautilus
    cmake
    yazi
    obsidian
    waybar
    rofi
    swww
    networkmanagerapplet
    hyprshot
    dunst
    nix-init
    cava
    gopls
    vlc
    ani-cli
    lazygit
    btop
    direnv
    devenv
    hyprlock
    nil
    multimarkdown
    lavat
    shellcheck
    gthumb
    ripgrep
    gotools
    obs-studio
    qbittorrent
    gotests

    (pkgs.callPackage ./config/pokemon { })
    # (pkgs.callPackage ./config/baca { })
    # (pkgs.callPackage ./config/climage { })
    tmux
    pyprland

    firefox
    pstree
    zip
    unzip

    toipe

    libreoffice
    dysk

    wl-clipboard
    clipman
    fd
    libtool
    libnotify
    wineWowPackages.staging
    ungoogled-chromium
    gemini-cli
    spotdl
    epr
    flameshot
  ];

  powerManagement = {
    enable = true;
    cpuFreqGovernor = "performance";
  };
  # pam services
  programs.adb.enable = true;
  security = {
    polkit.enable = true;
    pam.services.hyprlock = { };
    pam.services.i3lock = { };
    pam.services.betterlockscreen = { };
  };

  services.syncthing = {
    enable = true;
    user = "gabbar";
    dataDir = "/home/gabbar/";
    configDir = "/home/gabbar/.config/syncthing";
    overrideDevices = true;
    overrideFolders = true;
    settings = {
      devices = {
        "mobile-device" = {
          id = "PCD2B7D-Y6HYEPG-A3I7RMK-QEEY5XY-RU2Z2NO-ZDV2UQD-CILNVKQ-M4TC4A2";
        };
      };
    };
  };

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };
  xdg.portal.enable = true;

  environment.sessionVariables.NIXOS_OZONE_WL = 1;
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.greetd.enableGnomeKeyring = true;

  fonts.packages = [
    pkgs.nerd-fonts.fira-code
    pkgs.nerd-fonts.jetbrains-mono
    pkgs.vistafonts
    pkgs.corefonts
    pkgs.font-awesome
  ];

  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
  };
  hardware.graphics.enable = true;

  networking.firewall = {
    enable = false;
    allowedTCPPorts = [
      8081
      8080
      5037
      8022
    ];
    allowedUDPPorts = [ ];
  };

  # networking.firewall = {
  #     enable = true;
  #     allowedTCPPortRanges = [
  #       { from = 1714; to = 1764; } # KDE Connect
  #     ];
  #     allowedUDPPortRanges = [
  #       { from = 1714; to = 1764; } # KDE Connect
  #     ];
  #   };

  system.stateVersion = "25.05";

}
