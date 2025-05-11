{ pkgs }:
let
  image = pkgs.fetchurl {
    url = "https://w.wallhaven.cc/full/5y/wallhaven-5ylp38.jpg";
    sha256 = "sha256-w7nO2SKnXdnK0/UvpNrV2xhC72GK4DaDc3XqqwTQQoY=";
  };
in
pkgs.stdenv.mkDerivation {
  name = "sddm-theme";
  src = pkgs.fetchFromGitHub {
    owner = "aczw";
    repo = "sddm-theme-corners";
    rev = "6ff0ff455261badcae36cd7d151a34479f157a3c";
    sha256 = "sha256-CPK3kbc8lroPU8MAeNP8JSStzDCKCvAHhj6yQ1fWKkY=";
  };
  installPhase = ''
    mkdir -p $out
    cp -R ./corners/* $out/
    cd $out
    echo 'FontFamily="JetBrainsMono Nerd Font"' | tee -a ./theme.conf > /dev/null
    cd  $out/backgrounds
    rm glacier.png
    cp -r ${image} $out/backgrounds/glacier.png
  '';
}
