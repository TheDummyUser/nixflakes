{
  description = "My nix config";
  inputs = {
    nix-colors.url = "github:misterio77/nix-colors";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs =
    inputs@{
      self,
      nixpkgs,
      ...
    }:
    {
      nixosConfigurations =
        let
          user = "gabbar";
        in
        {
          interstellar = nixpkgs.lib.nixosSystem rec {
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
                  backupFileExtension = "hmbackup";
                  useGlobalPkgs = true;
                  useUserPackages = true;
                  extraSpecialArgs = { inherit inputs system user; };
                  users.${user} = {
                    imports = [
                      inputs.spicetify-nix.homeManagerModules.default
                      inputs.nix-colors.homeManagerModule
                      inputs.sops-nix.homeManagerModules.sops

                      ./home.nix
                    ];
                    home = {
                      username = user;
                      homeDirectory = "/home/${user}";
                      stateVersion = "25.05";
                    };
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
