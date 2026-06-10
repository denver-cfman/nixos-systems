{
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = "/dev/sda";
        content = {
          type = "table";
          format = "msdos"; # This sets the MBR partition table
          partitions = [
            {
              name = "root";
              start = "1M";
              end = "100%";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/";
                extraArgs = [ "-L" "nixos" ];
              };
            }
          ];
        };
      };
    };
  };
}
