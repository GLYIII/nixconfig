{ config, lib, pkgs, ... }:

{
  home-manager = {
    useUserPackages = true;
    users.jy = { config, lib, pkgs, ... }: {
      imports = [ ./config/home-fish.nix ];
      home.packages = with pkgs; [ ];
      home = { stateVersion = "23.11"; };
      services = { emacs = { enable = true; }; };
      programs = {
        emacs = {
          enable = true;
          extraPackages = epkgs: [
            epkgs.pdf-tools
            epkgs.org-pdftools
            epkgs.vterm
          ];
        };
      };
    };
  };
}
