# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

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
  # networking.stevenblack = {
  #   enable = true;
  #   block = [
  #     "fakenews"
  #     "gambling"
  #     "porn"
  #   ];
  # };
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

  services.xserver = {
    enable = true;
    windowManager = {
      bspwm = {
        enable = true;
        configFile = "/home/gabbar/./.config/bspwm/bspwmrc";
        sxhkd.configFile = "/home/gabbar/./.config/sxhkd/sxhkdrc";
      };
      qtile = {
        enable = true;
        extraPackages =
          python3Packages: with python3Packages; [
            qtile-extras
          ];
      };
    };
    excludePackages = with pkgs; [
      xterm
    ];
  };
  services.displayManager.sddm.enable = true;

  # programs.steam = {
  #   enable = true;
  #   remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
  #   dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  #   localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
  # };

  hardware.bluetooth.enable = true; # enables support for Bluetooth
  hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot
  services.blueman.enable = true;
  services.gvfs.enable = true;
  users.defaultUserShell = pkgs.zsh;
  environment.shells = with pkgs; [ zsh ];
  programs.zsh.enable = true;
  users.users.gabbar = {
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
    wget
    curl
    vesktop
    jellyfin
    jellyfin-web
    jellyfin-ffmpeg
    ispell
    git
    fastfetch
    thefuck
    # zellij
    eza
    go
    nitch
    httpie-desktop
    nixd
    bspwm
    sxhkd
    copyq
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
    swayidle
    # swaylock
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
    bottles
    nodePackages_latest.js-beautify
    gotests
    fd
    google-chrome
    (pkgs.callPackage ./config/pokemon { })
    tmux
    pyprland
    vscode
    floorp
    zip
    unzip
    wineWowPackages.waylandFull
    winetricks
    mari0
    toipe

    polybar
    picom-pijulius
    flameshot
    feh
  ];

  # pam services
  programs.adb.enable = true;
  security = {
    polkit.enable = true;
    pam.services.hyprlock = { };
  };

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };
  environment.sessionVariables.NIXOS_OZONE_WL = 1;

  services = {
    emacs = {
      enable = true;
      package = pkgs.emacs-gtk;
      install = true;
    };
  };

  fonts.packages = [
    pkgs.nerd-fonts.fira-code
    pkgs.nerd-fonts.jetbrains-mono
  ];

  networking.firewall = {
    enable = false;
    allowedTCPPorts = [
      8080
      5037
      8022
    ];
    allowedUDPPorts = [ ];
  };

  networking.networkmanager.insertNameservers = [
    "8.8.8.8"
    "1.0.0.1"
    "1.1.1.1"
    "208.67.222.222"
  ];
  # networking.firewall = {
  #     enable = true;
  #     allowedTCPPortRanges = [
  #       { from = 1714; to = 1764; } # KDE Connect
  #     ];
  #     allowedUDPPortRanges = [
  #       { from = 1714; to = 1764; } # KDE Connect
  #     ];
  #   };

  system.stateVersion = "24.11";

}
