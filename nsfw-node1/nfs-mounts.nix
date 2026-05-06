{ config, pkgs, inputs, ... }:

{
  ### NFS Stuff
  #services.rpcbind.enable = true;
  #fileSystems."/mnt/nsfw-storage" = {
  #  device = "192.168.1.250:/mnt/Big10TBPool/HomeLab/nsfw-storage/transmission-temp";
  #  fsType = "nfs";
  #  options = [ "x-systemd.automount" "noauto" "x-systemd.idle-timeout=600" ];
  #};
}
