{
  lib,
  config,
  inputs,
  pkgs,
  ...
}:
let
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
in
{
  programs.spicetify = {
    enable = true;
    enabledExtensions = with spicePkgs.extensions; [
      adblock
      hidePodcasts
      shuffle # shuffle+ (special characters are sanitized out of extension names)
    ];
  };

  programs.spicetify.theme = {
    # Name of the theme (duh)
    name = "SpicetifyDarkTheme";
    # The source of the theme
    # make sure you're using the correct branch
    # It could also be a sub-directory of the repo
    src = pkgs.fetchFromGitHub {
      owner = "ch1kulya";
      repo = "SpicetifyDarkTheme";
      rev = "f436158932c326a7cb75bb677865ccfcb8414085";
      hash = "sha256-V6Zcx3ox4jE3saAn36UWu2zVaNc4cvKsBcm0bqa+dCw=";
    };

    # Additional theme options all set to defaults
    # the docs of the theme should say which of these
    # if any you have to change
    injectCss = true;
    injectThemeJs = true;
    replaceColors = true;
    homeConfig = true;
    overwriteAssets = false;
    additonalCss = "";
  };
}
