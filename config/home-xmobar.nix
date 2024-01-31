{ config, lib, pkgs, ... }:

{
  programs = {
    xmobar = {
      enable = true;
      extraConfig = ''
        -- Xmobar (http://projects.haskell.org/xmobar/)
        -- This is one of the xmobar configurations for DTOS.
        -- This config is packaged in the DTOS repo as 'dtos-xmobar'

        Config { font            =   "FiraCode bold 9"
               , additionalFonts = [ "FiraCode regular 7"
                                   , "Font Awesome 6 Free Duotone 11"
                                   , "Font Awesome 6 Brands 11"
                                   , "Fira Code Nerd Font 11 "
                                   ]
               , bgColor      = "#282828"
               , fgColor      = "#ebdbb2"
               -- Position TopSize and BottomSize take 3 arguments:
               --   an alignment parameter (L/R/C) for Left, Right or Center.
               --   an integer for the percentage width, so 100 would be 100%.
               --   an integer for the minimum pixel height for xmobar, so 24 would force a height of at least 24 pixels.
               --   NOTE: The height should be the same as the trayer (system tray) height.
               , position     = TopSize L 100 30
               , lowerOnStart = True
               , hideOnStart  = False
               , allDesktops  = True
               , persistent   = True
               , iconRoot     = ".xmonad/xpm/"  -- default: "."
               , commands = [
                             Run Com "echo" ["<fn=3>\xf313</fn>"] "nix" 3600
                                -- Echos an "uP arrow" icon infront of the wireless output
                                -- Cpu usage in percent
                            , Run Cpu ["-t", "<fn=2>\xf4bc</fn>  <total>%","-H","50","--high","red"] 2
                                -- Cpu Frequency
                            , Run CpuFreq ["-t", "| <avg> GHz", "-L", "0", "-H", "2", "-l", "lightblue", "-n","#ebdbb2", "-h", "red", "-d", "2"] 2
                                -- Cpu Temperature
                            , Run MultiCoreTemp ["-t", "| <avg>°C","-L", "60", "-H", "80", "-l", "#b8bb26", "-n", "#fabd2f", "-h", "#fb4934","--", "--mintemp", "20", "--maxtemp", "100"] 50
                                -- Ram used number and percent
                            , Run Memory ["-t", "<fn=2>\xf061a</fn>  <used>M (<usedratio>%)"] 20
                                -- Disk space free
                            , Run DiskU [("/", "<fn=2>\xf02ca</fn> <free> free (<usedp>%)")] [] 60
                                -- Echos an "up arrow" icon in front of the uptime output.
                            , Run Com "echo" ["<fn=2>\xf1eb</fn>"] "netw" 3600
                                -- Echos an "uP arrow" icon infront of the wireless output
                            , Run Wireless "wlp166s0" ["-t", "<ssid>" ] 30
                                -- network
                            , Run Com "echo" ["<fn=2>\xf0aa</fn>"] "uparrow" 3600
                                -- Uptime
                            , Run Com "echo" ["<fn=2>\xf185</fn>"] "sun" 3600
                                -- Brightness
                            , Run Brightness ["-t", "<percent>% ", "--" , "-D", "intel_backlight"] 2
                                -- Echos a Volume Icon in front of the Volume
                            , Run Com "echo" ["<fn=2>\xf028</fn>"] "speak" 3600
                                -- Volume
                            , Run Volume "pipewire" "Master" [ "-t", "<volume>% <status>", "--", "-C", "#98971a", "-c", "#cc241d"] 2
                                -- Echos a "battery" icon in front of the pacman updates.
                            , Run Com "echo" ["<fn=2>\xf242</fn>"] "baticon" 3600
                                -- Battery
                            , Run BatteryP ["BAT1"] ["-t", "<left>% AC: <acstatus>", "--","-l", "#cc241d", "-m", "#fe8019", "-h", "#b8bb26", "-L", "10", "-H", "60"] 1
                                -- Time and date
                            , Run Com "echo" ["<fn=2>\xf017</fn>"] "clock" 3600
                                -- Echos an "uP arrow" icon infront of the wireless output
                            , Run Date " %b %e, %Y - %I:%M %P " "date" 50
                                -- Script that dynamically adjusts xmobar padding depending on number of trayer icons.
                                -- Prints out the left side items such as workspaces, layout, etc.
                            , Run UnsafeStdinReader
                            ]
               , sepChar = "%"
               , alignSep = "}{"
               , template = " <box type=Left width=3 mb=2 color=#458588><fc=#458588><action=`rofi -show combi`> %nix%  </action></fc></box>%UnsafeStdinReader% }{ <box type=Bottom width=2 mb=2 color=#fb4934><fc=#fb4934><action=`kitty -e btop`>  %cpu% %cpufreq% %multicoretemp% </action></fc></box>  <box type=Bottom width=2 mb=2 color=#fe8019><fc=#fe8019><action=`kitty -e btop`> %memory% </action></fc></box>  <box type=Bottom width=2 mb=2 color=#d79921><fc=#d79921><action=`kitty -e ncdu /`> %disku% </action></fc></box>  <box type=Bottom width=2 mb=2 color=#689d6a><fc=#689d6a><action=`kitty -e nmtui`> %netw%  %wlp166s0wi% </action></fc></box>  <box type=Bottom width=2 mb=2 color=#458588><fc=#458588> %sun% %bright%</fc></box>  <box type=Bottom width=2 mb=2 color=#83a598><fc=#83a598> %baticon%  %battery% </fc></box>  <box type=Bottom width=2 mb=2 color=#b16286><fc=#b16286><action=`alacritty -e alsamixer`> %speak%  %pipewire:Master%</action></fc></box>  <box type=Bottom width=2 mb=2 color=#d3869b><fc=#d3869b><action=`emacsclient -c -a 'emacs' --eval '(doom/window-maximize-buffer(dt/year-calendar))'`> %clock%%date%</action></fc></box>"

               }
      '';
    };
  };
}
