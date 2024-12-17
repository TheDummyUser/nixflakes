{
  description = "My nix config";
  inputs = {
    nix-colors.url = "github:misterio77/nix-colors";
    # change to github:nixos/nixpkgs/nixos-unstable for unstable
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    home-manager = {
      # change to github:nix-community/home-manager for unstable
      url = "github:nix-community/home-manager/release-24.11";
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
              inputs.home-manager.nixosModules.home-manager
              {
                home-manager = {
                  backupFileExtension = "backup";
                  useGlobalPkgs = true;
                  useUserPackages = true;
                  extraSpecialArgs = { inherit inputs system user; };
                  users.${user} = {
                    imports = [
                      inputs.nix-colors.homeManagerModule
                      ./home.nix
                    ];
                    home = {
                      username = user;
                      homeDirectory = "/home/${user}";
                      # do not change this value
                      stateVersion = "24.11";
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
