{
  config,
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    ./config
    inputs.nix-colors.homeManagerModules.default
  ];
  colorScheme = inputs.nix-colors.colorSchemes.tomorrow-night;

  # gtk need to add custom files
  gtk = {
    enable = true;
    font = {
      name = "JetBrainsMono Nerd Font";
      size = 10;
    };
    theme = {
      name = "adw-gtk3-dark";
      package = pkgs.adw-gtk3;
    };
    iconTheme = {
      name = "Papirus";
      package = pkgs.papirus-icon-theme.override { color = "bluegrey"; };
    };
    cursorTheme = {
      name = "Bibata-Modern-Ice";
      package = pkgs.bibata-cursors;
      size = 24;
    };
  };

#   qt = {
#   enable = true;
#   platformTheme.name = "kde";
#   style = {
#     name = "adwaita-dark";
#     package = pkgs.adwaita-qt;
#   };
#   packages = with pkgs; [
#     kdePackages.plasma-integration
#   ];
# };


  home.pointerCursor = {
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Ice";
    size = 24;
    gtk.enable = true;
    x11.enable = true;
  };

  # dir env
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  services.kdeconnect = {
    enable = true;
    package = pkgs.kdePackages.kdeconnect-kde;
    indicator = true;
  };

  # sops-nix configuration for SSH keys
  sops = {
    defaultSopsFile = ./secrets/secrets.yaml; # Replace with your actual path
    defaultSopsFormat = "yaml";

    # The age key file location
    age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";

    # Define secrets
    secrets = {
      ssh_private_key = {
        path = "${config.home.homeDirectory}/.ssh/id_ed25519";
      };
      ssh_public_key = {
        path = "${config.home.homeDirectory}/.ssh/id_ed25519.pub";
      };
    };
  };

  # Ensure .ssh directory exists with correct permissions
  home.activation.setupSshDir = config.lib.dag.entryAfter [ "writeBoundary" ] ''
    $DRY_RUN_CMD mkdir -p ${config.home.homeDirectory}/.ssh
    $DRY_RUN_CMD mkdir -p ${config.home.homeDirectory}/.config/sops/age
    $DRY_RUN_CMD chmod 700 ${config.home.homeDirectory}/.ssh
    $DRY_RUN_CMD chmod 700 ${config.home.homeDirectory}/.config/sops/age
  '';

  # Enable SSH agent and add keys automatically
  services.ssh-agent.enable = true;

  # SSH configuration
  programs.ssh = {
  enable = true;
  enableDefaultConfig = false; # avoid using old defaults

  matchBlocks = {
    "*" = {
      addKeysToAgent = "yes";         # moved here
      identitiesOnly = true;
      identityFile = "${config.home.homeDirectory}/.ssh/id_ed25519";
    };
  };
  };

# services.mpd = {
#   enable = true;
#   musicDirectory = "/home/gabbar/music";
#   user = "gabbar";
 

#   # Optional:
#   network.listenAddress = "any"; # if you want to allow non-localhost connections
#   network.startWhenNeeded = true; # systemd feature: only start MPD service upon connection to its socket
# };
  services.mpd = {
    enable = true;
    musicDirectory = "/mnt/Localdisk/Media/music";
    
    # Use PipeWire for audio output (recommended for modern NixOS)
    extraConfig = ''
      audio_output {
        type "pipewire"
        name "PipeWire Output"
      }
    '';
    
    # Optional: Enable socket activation for automatic startup
    # startWhenNeeded = true;
  };

# programs.ncmpcpp = {
#     enable = true;
#     mpdMusicDir = "/mnt/Localdisk/Media/music";
    
#     # Optional: Custom ncmpcpp configuration
#     settings = {
#       mpd_host = "localhost";
#       mpd_port = "6600";
#       mpd_connection_timeout = "5";
#       mpd_crossfade_time = "5";
      
#       # UI Configuration
#       user_interface = "alternative";
#       header_visibility = "yes";
#       statusbar_visibility = "yes";
#       titles_visibility = "yes";
      
#       # Colors
#       colors_enabled = "yes";
#       main_window_color = "white";
#       # main_window_highlight_color = "blue";
#       header_window_color = "cyan";
#       volume_color = "red";
#       progressbar_color = "cyan";
      
#       # Playlist settings
#       playlist_display_mode = "columns";
#       autocenter_mode = "yes";
#       # fancy_scrolling = "yes";
      
#       # Format strings
#       song_list_format = "{$3%n │ $9}{$7%a - $9}{$5%t$9}|{$8%f$9}$R{$6 │ %b$9}{$3 │ %l$9}";
#       song_status_format = " $2%a $4⟫$3⟫ $8%t $4⟫$3⟫ $5%b ";
      
#       # Other settings
#       display_bitrate = "yes";
#       ignore_leading_the = "yes";
#       cyclic_scrolling = "yes";
#     };
#   };


  
  home.packages = with pkgs; [
    age
    sops
    openssh
    mpc-cli
    rmpc
  ];
}
