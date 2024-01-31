{ config, lib, pkgs, ... }:

{

  services = {
    # Emacs as a server, to have better editor startup times
    # emacs = {
    #   enable = true;
    #   package = with pkgs;
    #     ((emacspackagesfor emacs).emacswithpackages (epkgs: [ epkgs.pdf-tools epkgs.org-pdftoolsepkgs.vterm ]));
    #   defaulteditor = true;

    # };
    # end emacs
    hardware = { bolt = { enable = true; }; };
    # Picom very cool
    # Xserver, the display protocol used on this config
    xserver = {
      enable = true;
      # Set the xkb layout to United States
      layout = "us";
      # Try and get rid of screen tearing
      # videoDrivers = [ "intel" ];
      videoDrivers = [ "modesetting" ];
      deviceSection = ''
        Option "DRI" "2"
        Option "TearFree" "true"
      '';
      libinput = {
        enable = true;
        touchpad = {
          disableWhileTyping = false;
          horizontalScrolling = false;
        };
      };
      # use "startx"
      displayManager = { startx = { enable = true; }; };
      # Have xmonad as the default window manager
      windowManager = {
        xmonad = {
          enable = true;
          extraPackages = hp: [ hp.xmonad hp.xmonad-contrib hp.xmonad-extras ];
        };
      };
    }; # End xserver

    # Enable printing
    printing = { enable = true; };
    avahi = {
      enable = true;
      nssmdns = true;
      # for a WiFi printer
      openFirewall = true;
    };
    # Enable use of pipewire, pipewire-pulse, and pipewire-alsa
    pipewire = {
      enable = true;
      # Drop-in support for ALSA
      alsa = {
        enable = true;
        support32Bit = true;
      };
      # Drop-in support for Pulse Audio
      pulse = { enable = true; };

      # config = {
      #   # Change the default sample rate to something higher in order to take advantage of a better DAC/AMP
      #   pipewire = {
      #     "context.properties" = {
      #       #"link.max-buffers" = 64;
      #       "link.max-buffers" =
      #         16; # version < 3 clients can't handle more than this
      #       "log.level" = 2; # https://docs.pipewire.org/page_daemon.html
      #       "default.clock.rate" = 192000; # 48000;
      #       #"default.clock.quantum" = 1024;
      #       #"default.clock.min-quantum" = 32;
      #       #"default.clock.max-quantum" = 8192;
      #     };
      #     # If you want to use JACK applications, uncomment this
      #     #jack.enable = true;
      #   };
      # };
    }; # End pipewire
    # Enable the Open SSH Daemon
    openssh = { enable = true; };

    # Enable use of a finger print reader through finger print daemon
    fprintd = { enable = true; };

    # Enable LVFS
    fwupd = {
      enable = true;
      package = pkgs.fwupd;
      # enableTestRemote = true;
      extraRemotes = [ "lvfs-testing" ];
    };
  }; # End Services
}
