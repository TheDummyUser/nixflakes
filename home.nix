{
  lib,
  config,
  inputs,
  pkgs,
  ...
}:
{
  programs.git = {
    enable = true;
    userName = "TheDummyUser";
    userEmail = "abhiram.reddy122002@gmail.com";
  };

  imports = [./config];
}
