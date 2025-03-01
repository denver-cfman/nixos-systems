###
{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  # boot.loader.grub.efiInstallAsRemovable = true;
  # boot.loader.systemd-boot.enable = true; 
  boot.loader.grub.device = "/dev/sda";  
  boot.loader.grub.efiSupport = false;
  boot.loader.grub.useOSProber = true;
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Define on which hard drive you want to install Grub.
  #boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only

  swapDevices = [{
    device = "/swapfile";
    size = 32 * 1024; # 32GB
  }];


  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  networking = {
    hostName = "remote-nas1";
    domain = "giezenconsulting.com";
    enableIPv6 = false;
    useDHCP = true;
    networkmanager.enable = false;
    firewall = {
      enable = true;
      allowedTCPPorts = [ 22 ];
      allowedUDPPorts = [ config.services.tailscale.port ];
      trustedInterfaces = [ "tailscale0" ];
    };
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
    description = "giezac";
    extraGroups = [ "wheel" ];
    packages = with pkgs; [];
    password = "changeme";
    openssh.authorizedKeys.keys = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCZawwmpdesq0ZvtXTdPekpjK3OYiPONrKO0no625FqYG8A8fZY++cxjG4my6HgmoaBrZiWvRJTa0WfTfw9Tzx9xt/FKrCB4bk9G33WP+RJNF7AEo3wkGGBLHzxp9bnhzzxdJOQCV67DRDxQNjMiR5S/bkSU+QYPDq+MLLx8mFz8lfzOSThVgDLjOj7lsRAJcrFDawsjZYHjsVBdDfCkjXGPKT7/c90k0BOvOjnOZ4vEn1w2s/Neq0rDTJYDUSmu9SzW/+WkM1rZa4GS5QGFMJVrI1Ow3X8tiUYpAp1oa0MyIpRkpuP39W+I6qaRBW4/+lyJYWsLP09hU7K2wT6OGap forGitHub"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPmNXnRi9A/6hQL0wxpyti2Qo+Sd8LZt0uLu/hSJ91tH giezac@R210ii"
    ];
  };

  users.users.root.openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPmNXnRi9A/6hQL0wxpyti2Qo+Sd8LZt0uLu/hSJ91tH root@R210ii"
  ];


  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim
    unzip
    jq  
    rsync
    mdadm
    tailscale
    neofetch
    htop
    btop
    #btop-rocm
    usbtop
    iftop
    iotop
    #sysdig
    s-tui
    fastfetch
    ipfetch
  ];

  services.tailscale = {
    enable = true;
    useRoutingFeatures = "server";
    interfaceName = "tailscale0";
    port = 41641;
  };

  services.openssh = {
    enable = true;
    # require public key authentication for better security
    settings.PasswordAuthentication = false;
    settings.KbdInteractiveAuthentication = false;
    #settings.PermitRootLogin = "yes";
  };



  # create a oneshot job to authenticate to Tailscale
  systemd.services.tailscale-autoconnect = {
    description = "Automatic connection to Tailscale";

    # make sure tailscale is running before trying to connect to tailscale
    after = [ "network-pre.target" "tailscale.service" ];
    wants = [ "network-pre.target" "tailscale.service" ];
    wantedBy = [ "multi-user.target" ];

    # set this service as a oneshot job
    serviceConfig.Type = "oneshot";

    # have the job run this shell script
    script = with pkgs; ''
      # wait for tailscaled to settle
      sleep 2

      # check if we are already authenticated to tailscale
      status="$(${tailscale}/bin/tailscale status -json | ${jq}/bin/jq -r .BackendState)"
      if [ $status = "Running" ]; then # if so, then do nothing
        exit 0
      fi

      # otherwise authenticate with tailscale
      ${tailscale}/bin/tailscale up -authkey nodekey:a71c52d468cdf2ee6426311fdd06fd6b2d73c46422117e343dc3b959348e6b0e 
    '';
  };



  # nixpkgs.overlays = [ (final: prev: /* overlay goes here */) ];


  system.autoUpgrade.enable = true;
  system.autoUpgrade.allowReboot = true;

  system.stateVersion = "24.11"; # Did you read the comment?

}
