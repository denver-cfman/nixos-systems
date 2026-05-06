{ config, pkgs, lib, inputs, ... }:

{
  boot.supportedFilesystems = lib.mkAfter [ "nfs" ];
  services.rpcbind.enable = lib.mkForce true;
  ### NFS Stuff
  #services.rpcbind.enable = true;
  #fileSystems."/mnt/nsfw-storage" = {
  #  device = "192.168.1.250:/mnt/Big10TBPool/HomeLab/nsfw-storage/transmission-temp";
  #  fsType = "nfs";
  #  options = [ "x-systemd.automount" "noauto" "x-systemd.idle-timeout=600" ];
  #};
}
