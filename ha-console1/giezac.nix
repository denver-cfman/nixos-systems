{ config, pkgs, lib, ... }: 
{
  home.username = "giezac";
  home.homeDirectory = "/home/giezac";
  home.stateVersion = "25.05";

  # Enable programs and configure them
  programs.git = {
    enable = true;
    userName = "Zach Giezen";
    userEmail = "denver.cfman@gmail.com";
  };

  dconf.settings = {
    "org/cinnamon/desktop/session" = {
      lock-on-suspend = false;
    };
    "org/cinnamon/desktop/screensaver" = {
      lock-enabled = false;
      # If lock-enabled = false doesn't work, try a very long delay:
      # idle-activation-enabled = true; # Ensure idle activation is on if you want the delay to work
      # idle-delay = 7200; # 2 hours in seconds
    };
  };

  home.packages = with pkgs; [
    htop
  ];

  # Manage dotfiles (example for a simple file)
  # home.file.".config/my-app/config.conf".source = ./dotfiles/my-app/config.conf;

  # Other Home Manager options (refer to the Home Manager manual for a full list)
  # services.gpg-agent.enable = true;
  # xresources.enable = true;
}
