
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ 
      (modulesPath + "/profiles/qemu-guest.nix")
    ];

  boot.initrd.availableKernelModules = [ "ata_piix" "uhci_hcd" "virtio_pci" "virtio_scsi" "sd_mod" "sr_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  boot.zfs.forceImportRoot = lib.mkDefault false; 

  #fileSystems."/" =
  #  { 
  #    device = lib.mkDefault "/dev/disk/by-uuid/bcd35b4a-71f2-4610-91ea-eea524b016dd";
  #    fsType = "ext4";
  #  };

  #fileSystems."/" = {
  #  device = lib.mkForce "/dev/disk/by-label/nixos";
  #  fsType = "ext4";
  #  neededForBoot = true; 
  #};
  
  #fileSystems."/boot" =
  ##  { device = "/dev/disk/by-label/ESP";
  #    fsType = "vfat";
  #  };

  swapDevices = [ ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
