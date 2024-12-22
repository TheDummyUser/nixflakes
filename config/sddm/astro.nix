{ pkgs }:
let
  image = pkgs.fetchurl {
    url = "https://w.wallhaven.cc/full/5g/wallhaven-5gele3.png";
    sha256 = "sha256-WbY27LnqDVWHDx+pfWx94uJaN4PPQ3+LRNr4gfY82cI=";
  };
in
pkgs.stdenv.mkDerivation {
  name = "sddm-theme";
  src = pkgs.fetchFromGitHub {
    owner = "Keyitdev";
    repo = "sddm-astronaut-theme";
    rev = "468a100460d5feaa701c2215c737b55789cba0fc";
    sha256 = "sha256-L+5xoyjX3/nqjWtMRlHR/QfAXtnICyGzxesSZexZQMA=";
  };
  installPhase = ''
    mkdir -p $out
    cp -R ./* $out/
    cd $out/Backgrounds/
    rm background.png
    cp -r ${image} $out/Backgrounds/background.png
  '';
}
