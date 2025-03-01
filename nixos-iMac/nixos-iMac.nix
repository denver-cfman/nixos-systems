# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader = {
    systemd-boot = {
            enable = true;
      configurationLimit = 15;
    };
    efi.canTouchEfiVariables = true;
  };


  networking = {
    hostName = "nixos-iMac";
    networkmanager = {
      enable = true;
    };
  };
  
  time.timeZone = "America/Denver";

  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Configure X11
  services.xserver = {

    #libinput.enable = true;

    enable = true;
    xkb = {
      variant = "";
      layout = "us";
    };
    displayManager = {
      gdm = {
        enable = true;
      };
    };
    desktopManager = {
      gnome = {
        enable = true;
      };
    };
  };

  services = {
    displayManager = {
      autoLogin = {
        enable = true;
        user = "giezac";
      };
    };
  };

  # Enable CUPS to print documents.
  #services.printing.enable = true;

  # Enable sound with pipewire.
  #sound.enable = true;
  services.pulseaudio = {
    enable = false;
  };
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.giezac = {
    isNormalUser = true;
    description = "giezac";
    extraGroups = [ "wireshark" "networkmanager" "wheel" ];
    packages = with pkgs; [
      neofetch 
      f3
      oh-my-zsh
      chromium
      firefox 
      wireshark
      meld
      gparted
      obs-studio
     termius
    ];
    password = "changeme";
    openssh.authorizedKeys.keys = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCZawwmpdesq0ZvtXTdPekpjK3OYiPONrKO0no625FqYG8A8fZY++cxjG4my6HgmoaBrZiWvRJTa0WfTfw9Tzx9xt/FKrCB4bk9G33WP+RJNF7AEo3wkGGBLHzxp9bnhzzxdJOQCV67DRDxQNjMiR5S/bkSU+QYPDq+MLLx8mFz8lfzOSThVgDLjOj7lsRAJcrFDawsjZYHjsVBdDfCkjXGPKT7/c90k0BOvOjnOZ4vEn1w2s/Neq0rDTJYDUSmu9SzW/+WkM1rZa4GS5QGFMJVrI1Ow3X8tiUYpAp1oa0MyIpRkpuP39W+I6qaRBW4/+lyJYWsLP09hU7K2wT6OGap forGitHub"
    ];
  };

  users.users.root.openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPmNXnRi9A/6hQL0wxpyti2Qo+Sd8LZt0uLu/hSJ91tH root@R210ii"
  ];

   programs.wireshark.enable = true;

  virtualisation = {
    docker = {
      enable = true;
      autoPrune.enable = true;
    };
    virtualbox = {
      host = {
        enable = true;
        enableExtensionPack = true;
        addNetworkInterface = true;
        enableWebService = true;
        #package = "";
      };
    };
};

  users.extraGroups.vboxusers.members = [ "giezac" ];

  # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  environment.systemPackages = with pkgs; [
    vim
    wget
    htop
    btop
    iftop
    curl
    git
    oh-my-zsh
    jq
    vlc
    openshot-qt
    podman
    podman-desktop
    podman-compose
    python310
    screen
  ];

  boot.binfmt.emulatedSystems = [ 
    "aarch64-linux"
    "armv6l-linux"
    "armv7l-linux"
    "i386-linux"
    "i486-linux"
    "i586-linux"
    "i686-linux"
    "wasm32-wasi"
    "wasm64-wasi"
  ];

  system.autoUpgrade = {
    enable = true;
    allowReboot = true;
    channel = "https://channels.nixos.org/nixos-24.05";
  };

  nix.gc = {
    automatic = true;
    randomizedDelaySec = "5min";
  };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  system.stateVersion = "24.05"; # Did you read the comment?

}
