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

  qt = {
    enable = true;
    platformTheme.name = "kde";
    style = {
      name = "adwaita-dark";
      package = pkgs.adwaita-qt;
    };
  };

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
    addKeysToAgent = "yes";

    # Optional: Add common SSH config
    matchBlocks = {
      "*" = {
        identitiesOnly = true;
        identityFile = "${config.home.homeDirectory}/.ssh/id_ed25519";
      };
    };
  };

  # Ensure required packages are available
  home.packages = with pkgs; [
    age
    sops
    openssh

    # fish plugins start
    fishPlugins.done
    fishPlugins.fzf-fish
    fishPlugins.forgit
    fishPlugins.hydro
    fzf
    fishPlugins.grc
    grc
    fasd
    # fish plugins end
  ];

}
