{ config, lib, pkgs, ... }:

{
  programs = {
    bat = {
      enable = true;
      config = {
        theme = "gruvbox-dark";
        style = "plain";
        paging = "auto";
        pager = "less --RAW-CONTROL-CHARS --wheel-lines=4 --mouse --use-color -Dd+b -Du+g -DE+r -DS+ky -J -M";
        italic-text = "always";
      };
    };
  };
}
