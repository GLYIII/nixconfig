{ config, lib, pkgs, ... }:

{
  programs = {
    adb = { enable = true; };
    git = { enable = true; };
    mtr = { enable = true; };

    fish = {
      enable = true;
      useBabelfish = true;
    };

    # Enable steam, to play games
    steam = {
      enable = true;
      remotePlay = {
        # Open ports in the firewall for Steam Remote Play
        openFirewall = true;
      };
      dedicatedServer = {
        # Open ports in the firewall for Source Dedicated Server
        openFirewall = true;
      };
    };

    gnupg = {
      agent = {
        enable = true;
        enableSSHSupport = true;
        pinentryFlavor = "gtk2";
      };
    };
  }; # End programs
}
