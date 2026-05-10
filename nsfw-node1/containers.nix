{ config, pkgs, lib, inputs, ... }:

let
  vncPassword = builtins.getEnv "VNC_PW";
  finalVncPw = if vncPassword != "" then vncPassword else "password";
  torbImageTag = builtins.getEnv "TORB_IMAGE_TAG";
  finalTorbImageTag = if torbImageTag != "" then torbImageTag else "aarch64-1.17.0-rolling-daily";
in
{
{
  virtualisation.arion.projects.arion-container-stack.settings = {
    # 1. FORCE GLOBAL NETWORK DEFINITION
    # This must be a direct child of 'settings'
    docker-compose.raw.networks.NSFW = {
      external = true;
    };

    # 2. DEFINE THE SERVICE
    services.nsfw-browser.service = {
      image = "kasmweb/tor-browser:" + finalTorbImageTag;
      
      # This points to the global 'NSFW' defined above
      networks = [ "NSFW" ];
      
      environment = {
        VNC_PW = finalVncPw;
        HTTP_PROXY = "http://10.0.90.3:8118";
        HTTPS_PROXY = "http://10.0.90.3:8118";
      };
    };
  };
};
}
