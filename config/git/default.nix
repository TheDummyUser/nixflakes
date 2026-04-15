{ ... }:
{
  programs.git = {
    enable = true;
    settings = {
      user.name = "TheDummyUser";
      user.email = "108084914+TheDummyUser@users.noreply.github.com";
    };
  };
}
