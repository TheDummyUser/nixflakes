{
  description = "My nix config";
  inputs = {
    nix-colors.url = "github:misterio77/nix-colors";
    # change to github:nixos/nixpkgs/nixos-unstable for unstable
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      # change to github:nix-community/home-manager for unstable home-manager/release-24.11
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # nvf.url = "github:notashelf/nvf";
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs =
    inputs@{ self, nixpkgs, ... }:
    {
      nixosConfigurations =
        let
          user = "gabbar";
        in
        {
          # update with `nix flake update`
          # rebuild with `nixos-rebuild switch --flake .#dev`
          default = nixpkgs.lib.nixosSystem rec {
            system = "x86_64-linux";
            specialArgs = {
              inherit (nixpkgs) lib;
              inherit
                inputs
                nixpkgs
                system
                user
                ;
            };
            modules = [
              inputs.sops-nix.nixosModules.sops
              inputs.home-manager.nixosModules.home-manager
              {
                home-manager = {
                  backupFileExtension = "hmbackup1";
                  useGlobalPkgs = true;
                  useUserPackages = true;
                  extraSpecialArgs = { inherit inputs system user; };
                  users.${user} = {
                    imports = [
                      inputs.spicetify-nix.homeManagerModules.default
                      inputs.nix-colors.homeManagerModule
                      inputs.sops-nix.homeManagerModules.sops
                      # inputs.nvf.homeManagerModules.default
                      ./home.nix
                    ];
                    home = {
                      username = user;
                      homeDirectory = "/home/${user}";
                      # do not change this value
                      stateVersion = "25.05";
                    };
                    # Let Home Manager install and manage itself.
                    programs.home-manager.enable = true;
                  };
                };
              }
              ./configuration.nix
            ];
          };
        };
    };
}
