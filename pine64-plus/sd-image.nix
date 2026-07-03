# This module extends the official sd-image.nix with the following:
# - ability to add options to the config.txt firmware
{
  config,
  lib,
  pkgs,
  ...
}: {
  options.sdImage = with lib; {
    extraFirmwareConfig = mkOption {
      type = types.attrs;
      default = {};
      description = lib.mdDoc ''
        Extra configuration to be added to config.txt.
      '';
    };
  };

}
