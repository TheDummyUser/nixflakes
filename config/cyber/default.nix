{ pkgs, ... }:
{
  home.packages = with pkgs; [
    metasploit
    dirb
    dirbuster
    gobuster
    ffuf
    nmap
    burpsuite
    openvpn
    powersploit
    rockyou
    seclists
  ];
}
