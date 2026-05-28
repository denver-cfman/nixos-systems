{ config, pkgs, ... }:

{

  isoImage.squashfsCompression = "zstd -Xcompression-level 1";

  imports =
    [
      ./hardware-configuration.nix
    ];

  boot.loader = {
    systemd-boot = {
            enable = true;
      configurationLimit = 15;
    };
    efi.canTouchEfiVariables = true;
  };

  networking = {
    hostName = "hermes-test1";
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

  users.users.giezac = {
    isNormalUser = true;
    description = "giezac";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      oh-my-zsh 
    ];
    password = "changeme";
    openssh.authorizedKeys.keys = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCZawwmpdesq0ZvtXTdPekpjK3OYiPONrKO0no625FqYG8A8fZY++cxjG4my6HgmoaBrZiWvRJTa0WfTfw9Tzx9xt/FKrCB4bk9G33WP+RJNF7AEo3wkGGBLHzxp9bnhzzxdJOQCV67DRDxQNjMiR5S/bkSU+QYPDq+MLLx8mFz8lfzOSThVgDLjOj7lsRAJcrFDawsjZYHjsVBdDfCkjXGPKT7/c90k0BOvOjnOZ4vEn1w2s/Neq0rDTJYDUSmu9SzW/+WkM1rZa4GS5QGFMJVrI1Ow3X8tiUYpAp1oa0MyIpRkpuP39W+I6qaRBW4/+lyJYWsLP09hU7K2wT6OGap forGitHub"
    ];
  };

  users.users.root.openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPmNXnRi9A/6hQL0wxpyti2Qo+Sd8LZt0uLu/hSJ91tH root@R210ii"
  ];


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
    #  };
    #};
};

  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

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
    fastfetch
    jq
    podman
    podman-desktop
    podman-compose
    screen
  ];

  nixpkgs.config.permittedInsecurePackages = [
      "qtwebengine-5.15.19"
  ];

#  boot.binfmt.emulatedSystems = [ 
#    "aarch64-linux"
#    "armv6l-linux"
#    "armv7l-linux"
#    "i386-linux"
#    "i486-linux"
#    "i586-linux"
#    "i686-linux"
#    "wasm32-wasi"
#    "wasm64-wasi"
#  ];

  nix.gc = {
    automatic = true;
    randomizedDelaySec = "5min";
  };

  services.openssh.enable = true;

  system.stateVersion = "25.11";

}
