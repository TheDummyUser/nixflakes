{
  ...
}:

{
  nix = {
    settings = {
      auto-optimise-store = true;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
    gc = {
      automatic = true;
      persistent = true;
    };
    extraOptions = ''
      warn-dirty = false
    '';
  };
}
