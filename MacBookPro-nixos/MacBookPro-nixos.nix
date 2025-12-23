# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;





  networking.hostName = "MacBookPro-nixos"; # Define your hostname.
  #networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Denver";

  # Select internationalisation properties.
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

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the Cinnamon Desktop Environment.
  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.desktopManager.cinnamon.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
    model = "macintosh_vndr/apple";
    options = "caps:swapescape"; # Optional: Swaps Caps Lock and Escape
  };

	services.xserver.displayManager.sessionCommands = ''
	${lib.getBin pkgs.xorg.xrandr}/bin/xrandr --setprovideroutputsource 2 0
	'';

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
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


# avahi required for service discovery
services.avahi.enable = true;

services.pipewire = {
  # opens UDP ports 6001-6002
  raopOpenFirewall = true;

  extraConfig.pipewire = {
    "10-airplay" = {
      "context.modules" = [
        {
          name = "libpipewire-module-raop-discover";

          # increase the buffer size if you get dropouts/glitches
           args = {
             "raop.latency.ms" = 500;
           };
        }
      ];
    };
  };
};


  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.giezac = {
    isNormalUser = true;
    description = "giezac";
    extraGroups = [ "wireshark" "networkmanager" "wheel" "dialout" ];
    packages = with pkgs; [
	     powershell
	     vscode-with-extensions
	     vscode-extensions.ms-vscode.powershell
	     vim
	     htop
	     btop
	     _1password-gui
	     _1password-cli
	     prusa-slicer
	     neofetch 
	     f3
	     oh-my-zsh
	     chromium
	     wireshark
	     meld
	     gparted
	     obs-studio
	     termius
	     hfsprogs  
     ];
  };

  # Install firefox.
  programs.firefox.enable = true;

   programs.wireshark.enable = true;

  virtualisation = {
    docker = {
      enable = true;
      autoPrune.enable = true;
    };
    #virtualbox = {
    #  host = {
    #    enable = true;
    #    enableExtensionPack = true;
    #    addNetworkInterface = true;
    #    enableWebService = true;
    #    #package = "";
    # };
    #};
};


  boot.blacklistedKernelModules = [ "kvm_intel" ]; 


  #users.extraGroups.vboxusers.members = [ "giezac" ];


  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  services.xserver.videoDrivers = [ "displaylink" "modesetting" ];

  environment.systemPackages = with pkgs; [
    impression
    displaylink
    k9s
    ollama
    mission-center
    xorg.setxkbmap
    #virtualbox
    slack
    bluebubbles
    hplipWithPlugin
    imagemagick
    xrdp
    realvnc-vnc-viewer
    devenv
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
    terraform
    terraform-providers.virtualbox
    terraform-providers.tailscale
    terraform-providers.proxmox
    terraform-providers.openwrt
    terraform-providers.docker
    xscreensaver
    pavucontrol
    rpi-imager
  ];

   permittedInsecurePackages = [
	"qtwebengine-5.15.19"
   ];

services.xscreensaver = {
	enable = true;
};

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
    allowReboot = false;
    channel = "https://channels.nixos.org/nixos-25.05";
  };

  nix.gc = {
    automatic = true;
    randomizedDelaySec = "5min";
  };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  system.stateVersion = "25.05"; # Did you read the comment?

}
