{ config, lib, pkgs, ... }:

{
  programs = {
    git = {
      enable = true;
      extraConfig = {
        user = {
          email = "g3@yurek.me";
          name = "Gerald Lee Yurek III";
          signingKey = "F8F35646AAF1F6A3158E5E74D0CB3CB9B885EEFC";
        };
        core = { autocrlf = "input"; };
        init = { defaultBranch = "master"; };
      };
    };
  };
}
