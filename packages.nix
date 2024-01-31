{ config, lib, pkgs, ... }:

{
  environment = {
    systemPackages = with pkgs; [
      ## File-System Related
      ncdu
      eza
      fd
      ripgrep
      zoxide
      bat
      zip
      unzip
      nnn
      tree
      ### Misc
      pass
      wget
      zellij
      calcurse
      bc
      pfetch
      onefetch
      neofetch
      pinfo
      minicom
      yt-dlp
      nixos-option
      btop
      gnutls
      hunspellDicts.en-us
      hunspell
      ### FS Tools
      fscrypt-experimental
      ntfs3g
      jfsutils
      exfat
      ventoy-bin
      p7zip
      rpi-imager
      xdg-user-dirs

      ## Terminals
      alacritty
      kitty

      ## Xorg Utilities and componenets
      xclip
      picom
      xdotool
      fontconfig
      ### Xorg Packages
      xorg.xev
      xorg.xkbcomp
      xorg.xmessage
      xorg.xprop
      xorg.xwininfo

      ##Image Viewers/Creators
      feh
      nsxiv
      ueberzug
      ### Screenshot Programs
      scrot
      flameshot

      ## Hardware Related Packages
      intel-gpu-tools
      acpi
      vaapiIntel
      mesa
      fprintd
      blugon
      inetutils
      bluez
      bluez-tools
      pciutils
      usbutils
      vulkan-tools
      libva-utils
      clinfo
      fw-ectool
      xboxdrv

      ## Misc Graphical Programs
      pinentry-gtk2
      openscad
      plover.dev
      firefox
      qutebrowser
      haskellPackages.xmobar
      rofi
      libreoffice-fresh
      zathura
      calibre
      spotify
      vmware-horizon-client

      ## Games
      prismlauncher
      runelite
      cataclysm-dda
      gzdoom

      ## Messager Clients
      signal-desktop
      discord
      element-desktop

      ## Audio/Video Players/Utilities
      ### Audio
      ncmpcpp
      mpc-cli
      mpd
      mplayer
      ### Audio Utilities
      alsa-lib
      alsa-firmware
      alsa-plugins
      alsa-utils
      pulsemixer
      ### Video Players
      mpv
      (pkgs.kodi.passthru.withPackages (kodiPkgs: with kodiPkgs; [ jellyfin ]))

      ## Programming Related
      ### QMK
      qmk
      dfu-util
      dfu-programmer
      ### Compilers/Interpreters & libraries
      texlive.combined.scheme-full
      gcc
      ghc
      haskellPackages.xmobar
      clang
      libgccjit
      sbcl
      jdk
      python3
      sqlite
      kotlin
      # (with pkgs;
      #   stdenv.mkDerivation {
      #     name = "nixJulia";
      #     src = /home/jy;
      #     buildInputs = with pkgs.python311Packages; [
      #       stdenv
      #       python3
      #       readline
      #       ipython
      #       (with builtins.getFlake "nixpkgs";
      #         with legacyPackages.x86_64-linux;
      #         julia-bin.withPackages [
      #           "Plots"
      #           "ElectricalEngineering"
      #           "Unitful"
      #           "PyPlot"
      #           "DifferentialEquations"
      #           "Conda"
      #         ])
      #       pyqt5
      #       qt5Full
      #       matplotlib
      #     ];
      #   })

      # (with builtins.getFlake "nixpkgs";
      #   with legacyPackages.x86_64-linux;
      #   julia-bin.withPackages.override {
      #     extraLibs = [ python311Packages.matplotlib ];
      #   } [
      #     "Plots"
      #     "ElectricalEngineering"
      #     "Unitful"
      #     "PyPlot"
      #     "DifferentialEquations"
      #     "Conda"
      #   ])
      ### Language Package Managers
      rustup
      cargo
      ### Language Utilites
      clang-tools
      bacon
      nixfmt
      ### Dev-ops
      git
      gdb
      gnumake
      cmake
      autoconf
      automake
    ];
  };
}
