{ config, pkgs, hermes-agent, lib, inputs, ... }:
{
  services.hermes-agent = {
    enable = true;
    settings = {
      model = { 
        default = "gemma4";
        provider = "custom";
        base_url = "http://10.0.60.5:11434/v1";
      };  
    };
    environmentFiles = [ ];
    addToSystemPackages = true;
  };
}
