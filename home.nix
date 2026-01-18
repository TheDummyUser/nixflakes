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

  gtk = {
    enable = true;

    font = {
      name = "Iosevka Nerd Font";
      size = 11;
    };

    theme = {
      name = "adw-gtk3-dark";
      package = pkgs.adw-gtk3;
    };

    iconTheme = {
      name = "Papirus";
      package = pkgs.papirus-icon-theme.override {
        color = "bluegrey";
      };
    };

    cursorTheme = {
      name = "Bibata-Modern-Ice";
      package = pkgs.bibata-cursors;
      size = 24;
    };

    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
  };

  home.pointerCursor = {
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Ice";
    size = 24;
    gtk.enable = true;
    x11.enable = true;
  };


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


  home.packages = with pkgs; [
    (pkgs.writeShellScriptBin "jrun" (builtins.readFile ./customScripts/java-run.sh))
    
    openssh
    mpc
    rmpc
  ];


 
}
