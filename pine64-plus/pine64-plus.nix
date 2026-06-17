# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, inputs, modulesPath, pkgs, ... }:

{
  imports =
    [
      ./containers.nix
      ./hardware-configuration.nix
      #./nfs-mounts.nix
      #./sd-image.nix
    ];

  image = {
    #compressImage = true;
    fileName = lib.mkForce "pine64-plus.img";
  };

  sdImage = {
    compressImage = true;
    imageName = lib.mkForce "pine64-plus.img";
    populateRootCommands = ''
    mkdir -p ./files/boot
    ${config.boot.loader.generic-extlinux-compatible.populateCmd} -c ${config.system.build.toplevel} -d ./files/boot
    '';
    populateFirmwareCommands = "";
  };

  hardware.enableRedistributableFirmware = lib.mkForce true;

  boot = {
    zfs.forceImportRoot = lib.mkForce false;
    kernelParams = [
      "console=ttyS1,115200n8"
      "cgroup_enable=cpuset"
      "cgroup_memory=1"
      "cgroup_enable=memory"
    ];

    loader = {
      grub.enable = lib.mkDefault false;
      generic-extlinux-compatible.enable = lib.mkDefault true;
      timeout = 2;
    };
    swraid.enable = lib.mkForce false;
  };

  # this is handled by nixos-hardware on Pi 4
  boot = {
    initrd.availableKernelModules = [
      "usbhid"
      "usb_storage"
    ];
  };

  networking = {
    hostName = "pine64-plus";
    #interfaces.end0.useDHCP = true;
    networkmanager = {
     enable = true;
     unmanaged = [ "type:wifi" ];
    };
    wireless.enable = lib.mkForce false;
  };

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

  users.users.giezac = {
    isNormalUser = true;
    home = "/home/giezac";
    description = "Me";
    password = "changeme";
    extraGroups = ["wheel" "networkmanager" "podman"];
    openssh = {
      authorizedKeys.keys = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCZawwmpdesq0ZvtXTdPekpjK3OYiPONrKO0no625FqYG8A8fZY++cxjG4my6HgmoaBrZiWvRJTa0WfTfw9Tzx9xt/FKrCB4bk9G33WP+RJNF7AEo3wkGGBLHzxp9bnhzzxdJOQCV67DRDxQNjMiR5S/bkSU+QYPDq+MLLx8mFz8lfzOSThVgDLjOj7lsRAJcrFDawsjZYHjsVBdDfCkjXGPKT7/c90k0BOvOjnOZ4vEn1w2s/Neq0rDTJYDUSmu9SzW/+WkM1rZa4GS5QGFMJVrI1Ow3X8tiUYpAp1oa0MyIpRkpuP39W+I6qaRBW4/+lyJYWsLP09hU7K2wT6OGap cool"
      ];
    };
  };

  security.sudo = {
    enable = true;
    wheelNeedsPassword = false;
  };

  services.getty.autologinUser = lib.mkForce "giezac";
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nixpkgs.config.permittedInsecurePackages = [
      #"qtwebengine-5.15.19"
  ];

  environment.systemPackages = with pkgs; [
    pfetch
    vim
    git
    wget
    btop
  ];

  nixpkgs.overlays = [
    (final: prev: {
      wpa_supplicant = prev.runCommand "empty-wpa-supplicant" {} "mkdir -p $out";
    })
  ];

  # Removes basic packages like nano, rsync, and strace
  environment.defaultPackages = [];

  documentation.enable = false;
  documentation.nixos.enable = false;

  virtualisation = {
    docker = {
      enable = false;
    };
    podman = {
      enable = true;
      dockerCompat = true;
      dockerSocket = {
        enable = true;
      };
      autoPrune = {
        dates = "weekly";
        flags = [ "--all" ];
        enable = true;
      };
    };
   oci-containers = {
    backend = "podman";
      containers = {
        #foo = {
        #  # ...
        #};
      };
   };
  };

  #disabledModules = [ "services/x11/desktop-managers/none.nix" ];

  nix.gc = {
    automatic = true;
    randomizedDelaySec = "5min";
  };

  services.openssh.enable = true;

  system.stateVersion = "26.05"; # Did you read the comment?

}
