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

  home.packages = with pkgs; [
    htop
  ];

  # Manage dotfiles (example for a simple file)
  # home.file.".config/my-app/config.conf".source = ./dotfiles/my-app/config.conf;

  # Other Home Manager options (refer to the Home Manager manual for a full list)
  # services.gpg-agent.enable = true;
  # xresources.enable = true;
}
