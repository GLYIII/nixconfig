# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, ... }:

{
  imports = [ # Include the results of the hardware scan.
    <nixos-hardware/framework/13-inch/12th-gen-intel>
    <home-manager/nixos>
    ./hardware-configuration.nix
    ./services.nix
    ./packages.nix
    ./programs.nix
    ./home-managr.nix
  ];

  boot = {
    loader = {
      systemd-boot = { enable = true; };
      efi = { canTouchEfiVariables = true; };
    };
    kernelParams = [ "video=eDP-1:2256x1504@60" "video=DP-1-3:2560x1440@144" ];
    extraModprobeConfig = "options bluetooth disable_ertm=1 ";
  }; # End boot

  networking = {
    networkmanager = { enable = true; };
    nameservers = [ "1.1.1.1" "8.8.8.8" ];
    #Elizabeth Diana Tracy
    hostName = "edt";
    firewall = { enable = false; };
  }; # End networking

  time = { timeZone = "America/New_York"; };

  i18n = { defaultLocale = "en_US.UTF-8"; };

  console = {
    # font = "Lat2-Terminus16";
    useXkbConfig = true; # use xkbOptions in tty.
    colors = [
      "282828" # black
      "cc241d" # darkred
      "98971a" # darkgreen
      "d79921" # brown
      "458588" # darkblue
      "b16286" # darkmagenta
      "689d6a" # darkcyan
      "a89984" # lightgrey
      "928374" # darkgrey
      "fb4934" # red
      "b8bb26" # green
      "fabd2f" # yellow
      "83a598" # blue
      "d3869b" # magenta
      "8ec07c" # cyan
      "ebdbb2" # white
    ];
  }; # End console

  security = {
    rtkit = { enable = true; };
    tpm2 = { enable = true; };
  };

  # Add system fonts
  fonts = {
    packages = with pkgs; [ fira-code fira-code-symbols font-awesome lato ];
    fontconfig = { enable = true; };
  }; # End fonts

  fileSystems = {
    "/home/jy/usb" = {
      device = "/dev/disk/by-uuid/62CF-B0FE";
      fsType = "vfat";
      options = [ "defaults" "user" "rw" "utf8" "noauto" "umask=000" ];
    };
    "/home/jy/RP2040/device" = {
      device = "/dev/disk/by-uuid/5A46-E323";
      fsType = "vfat";
      options = [ "defaults" "user" "rw" "utf8" "noauto" "umask=000" ];
    };

  };

  # define the user "jy"
  users = {
    users = {
      #Jerry Yurek
      jy = {
        isNormalUser = true;
        shell = pkgs.fish;
        extraGroups = [
          "wheel" # Enable Sudo, Su, Doas
          "networkmanager" # Allow main user to use nmclu, nmtui
          "video" # Allow display use
          "audio" # Allow Audio use
          "input" # Allow keyboard use
          "disk" # Allow disk use
          "storage" # Allow storage use
          "jy" # Make a Jy user group
          "plugdev" # because adb bullshit
          "adbusers" # because adb bullshit
          "users" # Add jy to users group
          "dialout" # Allow jy to use serial
        ];
        openssh = {
          authorizedKeys = {
            keys = [
              "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDVErtOUTrNW7PD8AJojna95RiFPE7424B6NaR0IGy63 alarm@danctnix"
            ];
          };
        };
      };
    };
  }; # End users

  xdg = {
    mime = {
      defaultApplications = {
        "application/pdf" = "org.pwmt.zathura.desktop";
        "application/epub" = "org.pwmt.zathura.desktop";
        "application/epub+zip" = "org.pwmt.zathura.desktop";
        "text/html" = "org.qutebrowser.qutebrowser.desktop";
        "x-scheme-handler/http" = "org.qutebrowser.qutebrowser.desktop";
        "x-scheme-handler/https" = "org.qutebrowser.qutebrowser.desktop";
        "x-scheme-handler/about" = "org.qutebrowser.qutebrowser.desktop";
        "x-scheme-handler/unknown" = "org.qutebrowser.qutebrowser.desktop";
      };
    };
  };

  # Mesa's compute implementation is dead and not good, and my current laptop uses intel graphics
  hardware = {
    opengl = {
      extraPackages = [ pkgs.intel-compute-runtime pkgs.intel-media-driver ];
    };
    cpu = { intel = { updateMicrocode = true; }; };
    # xpadneo = { enable = true; };
    xone = { enable = true; };
    keyboard = { qmk = { enable = true; }; };
  };
  powerManagement = { enable = true; };
  # Decrease time for the finger print reader to start up
  systemd = {
    services = {
      fprintd = {
        wantedBy = [ "multi-user.target" ];
        serviceConfig = { Type = "simple"; };
      };
    };
  };
  documentation = {
    dev.enable = true;
    doc.enable = true;
    enable = true;
    man.enable = true;
    info.enable = true;
    nixos.enable = true;
  };
  system = {
    # Copy the NixOS configuration file and link it from the resulting system
    # (/run/current-system/configuration.nix). This is useful in case you
    # accidentally delete configuration.nix.
    copySystemConfiguration = true;

    # This value determines the NixOS release from which the default
    # settings for stateful data, like file locations and database versions
    # on your system were taken. It‘s perfectly fine and recommended to leave
    # this value at the release version of the first install of this system.
    # Before changing this value read the documentation for this option
    # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
    stateVersion = "23.11"; # Did you read the comment?

  };
  nix = {
    # Enable use of experimental features in nix
    settings = { experimental-features = "nix-command flakes"; };
  };
  # Allow non-free nix packages to be installed
  nixpkgs = { config = { allowUnfree = true; }; };
}
