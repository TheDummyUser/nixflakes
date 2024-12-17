{
  lib,
  config,
  inputs,
  pkgs,
  ...
}:
{
  imports = [ ./config  inputs.nix-colors.homeManagerModules.default];

  colorScheme = inputs.nix-colors.colorSchemes.everforest-dark-hard;
}
