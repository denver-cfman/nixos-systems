{ config, pkgs, lib, ... }: 
{
  home.username = "giezac";
  home.homeDirectory = "/home/giezac";
  home.stateVersion = "25.05";

  # Enable programs and configure them
  programs.git = {
    settings = {
      user = {
        name = "Zach Giezen";
        email = "denver.cfman@gmail.com";
      };
    };
    enable = true;
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
    xscreensaver
    htop
  ];

  # Manage dotfiles (example for a simple file)
  # home.file.".config/my-app/config.conf".source = ./dotfiles/my-app/config.conf;

  # Other Home Manager options (refer to the Home Manager manual for a full list)
  # services.gpg-agent.enable = true;
  # xresources.enable = true;

  # Ensure xscreensaver is enabled
  services.xscreensaver = {
    enable = true;

    # Define your xscreensaver settings here
    # These correspond to the entries you'd find in ~/.xscreensaver or the xscreensaver-demo settings
    settings = {
      # Basic settings
      mode = "one"; # "random", "blank", "one", "off"
      lock = false;     # Whether to lock the screen when the screensaver activates
      timeout = "0:10:00"; # Blank after 10 minutes of inactivity (HH:MM:SS)
      cycle = "0:05:00";   # Change screensaver every 5 minutes
      lockTimeout = "0:00:00"; # Grace period before locking (0 means lock immediately)
      passwdTimeout = "0:00:30"; # How long after unlocking until password expires

      # Fade/Unfade options
      fade = true;
      unfade = true;
      fadeSeconds = "0:00:03";

      # DPMS (Display Power Management Signaling)
      dpmsEnabled = true; # Let xscreensaver manage DPMS
      dpmsQuickOff = false;
      
      programs = ''
        GL: glslideshow -root
      '';

      # Text settings (if you use text-based screensavers)
      # textMode = "url";
      # textUrl = "https://www.jwz.org/xscreensaver/xscreensaver.xml";
      # textLiteral = "Hello NixOS!";
      
      # Other common settings
      # verbose = false;
      # showURLs = true;
      # grabDesktopImages = true; # For screensavers that use your desktop as background
      # grabVideoImages = false;
      # preferBlanking = true;
      # visual = "default";
      # grabLoop = false;
    };
  };

  # Make sure XScreenSaver is allowed to manage the X server's screensaver.
  # This often involves disabling the default DE screen locking (like Cinnamon's).
  # For Cinnamon, you might need to adjust dconf settings as mentioned in the previous answer,
  # especially if it has its own locking mechanism that conflicts.
  # Example (though may vary by Cinnamon version):
  # dconf.settings = {
  #   "org/cinnamon/desktop/screensaver" = {
  #     lock-enabled = false; # Disable Cinnamon's built-in lock
  #     idle-activation-enabled = false; # Disable Cinnamon's idle activation
  #   };
  #   "org/gnome/desktop/session" = {
  #     idle-delay = 0; # Set to 0 for no idle delay from Gnome/Cinnamon session management
  #   };
  # };

  # Ensure xsession is enabled for proper X resource management (if you don't already have it)
  xsession.enable = true;

}
