{ config, lib, pkgs, ... }:

{
  programs = {
    rofi = {
      enable = true;

      extraConfig = let
        # Use `mkLiteral` for string-like values that should show without
        # quotes, e.g.:
        # {
        #   foo = "abc"; => foo: "abc";
        #   bar = mkLiteral "abc"; => bar: abc;
        # };
        inherit (config.lib.formats.rasi) mkLiteral;
      in {

        modes = map mkLiteral [ "combi" "window" "filebrowser" ];
        fixed-num-lines = true;
        show-icons = true;
        terminal = "kitty";
        ssh-client = "ssh";
        ssh-command = "{terminal} -e {ssh-client} {host} [-p {port}]";
        run-command = "{cmd}";
        run-list-command = "";
        run-shell-command = "{terminal} -e {cmd}";
        window-command = "wmctrl -i -R {window}";
        window-match-fields = "all";
        # icon-theme = ;
        drun-match-fields = "name,generic,exec,categories,keywords";
        # drun-categories = ;
        drun-show-actions = false;
        drun-display-format =
          "{name} [<span weight='light' size='small'><i>({generic})</i></span>]";
        drun-url-launcher = "xdg-open";
        disable-history = false;
        ignored-prefixes = "";
        sort = false;
        sorting-method = "normal";
        case-sensitive = false;
        sidebar-mode = true;
        hover-select = false;
        eh = 1;
        auto-select = false;
        parse-hosts = false;
        parse-known-hosts = true;
        combi-modes = map mkLiteral [ "drun" "run" ];
        matching = "normal";
        tokenize = true;
        m = "-5";
        # filter = ;
        dpi = -1;
        threads = 0;
        scroll-method = 0;
        window-format = "{w}    {c}   {t}";
        click-to-exit = true;
        max-history-size = 25;
        combi-hide-mode-prefix = false;
        combi-display-format = "{mode} {text}";
        # cache-dir = ;
        window-thumbnail = false;
        drun-use-desktop-cache = false;
        drun-reload-desktop-cache = false;
        normalize-match = false;
        steal-focus = true;
        # application-fallback-icon = ;
        refilter-timeout-limit = 8192;
        xserver-i300-workaround = false;
        pid = "/run/user/1000/rofi.pid";
        display-window = "window";
        display-windowcd = "windowcd";
        display-run = "run";
        display-ssh = "ssh";
        display-drun = "run";
        display-combi = "run";
        display-keys = "keys";
        # display-filebrowser = ;
        kb-primary-paste = "Control+V,Shift+Insert";
        kb-secondary-paste = "Control+v,Insert";
        kb-clear-line = "Control+w";
        kb-move-front = "Control+a";
        kb-move-end = "Control+e";
        kb-move-word-back = "Alt+b,Control+Left";
        kb-move-word-forward = "Alt+f,Control+Right";
        kb-move-char-back = "Left,Control+b";
        kb-move-char-forward = "Right,Control+f";
        kb-remove-word-back = "Control+Alt+h,Control+BackSpace";
        kb-remove-word-forward = "Control+Alt+d";
        kb-remove-char-forward = "Delete,Control+d";
        kb-remove-char-back = "BackSpace,Shift+BackSpace,Control+h";
        kb-remove-to-eol = "Control+k";
        kb-remove-to-sol = "Control+u";
        kb-accept-entry = "Control+j,Control+m,Return,KP_Enter";
        kb-accept-custom = "Control+Return";
        kb-accept-custom-alt = "Control+Shift+Return";
        kb-accept-alt = "Shift+Return";
        kb-delete-entry = "Shift+Delete";
        kb-mode-next = "Shift+Right,Control+Tab";
        kb-mode-previous = "Shift+Left,Control+ISO_Left_Tab";
        kb-mode-complete = "Control+l";
        kb-row-left = "Control+Page_Up";
        kb-row-right = "Control+Page_Down";
        kb-row-up = "Up,Control+p";
        kb-row-down = "Down,Control+n";
        kb-row-tab = "";
        kb-element-next = "Tab,J";
        kb-element-prev = "ISO_Left_Tab,K";
        kb-page-prev = "Page_Up";
        kb-page-next = "Page_Down";
        kb-row-first = "Home,KP_Home";
        kb-row-last = "End,KP_End";
        kb-row-select = "Control+space";
        kb-screenshot = "Alt+S";
        kb-ellipsize = "Alt+period";
        kb-toggle-case-sensitivity = "grave,dead_grave";
        kb-toggle-sort = "Alt+grave";
        kb-cancel = "Escape,Control+g,Control+bracketleft";
        kb-custom-1 = "Alt+1";
        kb-custom-2 = "Alt+2";
        kb-custom-3 = "Alt+3";
        kb-custom-4 = "Alt+4";
        kb-custom-5 = "Alt+5";
        kb-custom-6 = "Alt+6";
        kb-custom-7 = "Alt+7";
        kb-custom-8 = "Alt+8";
        kb-custom-9 = "Alt+9";
        kb-custom-10 = "Alt+0";
        kb-custom-11 = "Alt+exclam";
        kb-custom-12 = "Alt+at";
        kb-custom-13 = "Alt+numbersign";
        kb-custom-14 = "Alt+dollar";
        kb-custom-15 = "Alt+percent";
        kb-custom-16 = "Alt+dead_circumflex";
        kb-custom-17 = "Alt+ampersand";
        kb-custom-18 = "Alt+asterisk";
        kb-custom-19 = "Alt+parenleft";
        kb-select-1 = "Super+1";
        kb-select-2 = "Super+2";
        kb-select-3 = "Super+3";
        kb-select-4 = "Super+4";
        kb-select-5 = "Super+5";
        kb-select-6 = "Super+6";
        kb-select-7 = "Super+7";
        kb-select-8 = "Super+8";
        kb-select-9 = "Super+9";
        kb-select-10 = "Super+0";
        ml-row-left = "ScrollLeft";
        ml-row-right = "ScrollRight";
        ml-row-up = "ScrollUp";
        ml-row-down = "ScrollDown";
        me-select-entry = "MousePrimary";
        me-accept-entry = "MouseDPrimary";
        me-accept-custom = "Control+MouseDPrimary";
        timeout = {
          action = "kb-cancel";
          delay = 0;
        };
        filebrowser = {
          directories-first = true;
          sorting-method = "name";
        };
      };
      font = "firacode 10";
      location = 0;
      pass = { enable = true; };
      plugins = with pkgs; [ rofi-calc ];
      terminal = "kitty";
      xoffset = 0;
      yoffset = 0;
      theme = let
        # Use `mkLiteral` for string-like values that should show without
        # quotes, e.g.:
        # {
        #   foo = "abc"; => foo: "abc";
        #   bar = mkLiteral "abc"; => bar: abc;
        # };
        inherit (config.lib.formats.rasi) mkLiteral;
      in {
        "*" = {
          # Theme settings
          highlight = mkLiteral "bold italic";
          scrollbar = true;

          # Gruvbox dark colors
          gruvbox-dark-bg0 = mkLiteral "#282828";
          gruvbox-dark-bg0-soft = mkLiteral "#32302f";
          gruvbox-dark-bg3 = mkLiteral "#665c54";
          gruvbox-dark-fg0 = mkLiteral "#fbf1c7";
          gruvbox-dark-fg1 = mkLiteral "#ebdbb2";
          gruvbox-dark-red-dark = mkLiteral "#cc241d";
          gruvbox-dark-red-light = mkLiteral "#fb4934";
          gruvbox-dark-yellow-dark = mkLiteral "#d79921";
          gruvbox-dark-yellow-light = mkLiteral "#fabd2f";
          gruvbox-dark-gray = mkLiteral "#a89984";

          # Theme colors
          background = mkLiteral "@gruvbox-dark-bg0";
          background-color = mkLiteral "@background";
          foreground = mkLiteral "@gruvbox-dark-fg1";
          border-color = mkLiteral "@gruvbox-dark-bg0";
          separatorcolor = mkLiteral "@gruvbox-dark-gray";
          scrollbar-handle = mkLiteral "@gruvbox-dark-gray";

          normal-background = mkLiteral "@background";
          normal-foreground = mkLiteral "@foreground";
          alternate-normal-background = mkLiteral "@gruvbox-dark-bg0-soft";
          alternate-normal-foreground = mkLiteral "@foreground";
          selected-normal-background = mkLiteral "@gruvbox-dark-bg3";
          selected-normal-foreground = mkLiteral "@gruvbox-dark-fg0";

          active-background = mkLiteral "@gruvbox-dark-yellow-dark";
          active-foreground = mkLiteral "@background";
          alternate-active-background = mkLiteral "@active-background";
          alternate-active-foreground = mkLiteral "@active-foreground";
          selected-active-background = mkLiteral "@gruvbox-dark-yellow-light";
          selected-active-foreground = mkLiteral "@active-foreground";

          urgent-background = mkLiteral "@gruvbox-dark-red-dark";
          urgent-foreground = mkLiteral "@background";
          alternate-urgent-background = mkLiteral "@urgent-background";
          alternate-urgent-foreground = mkLiteral "@urgent-foreground";
          selected-urgent-background = mkLiteral "@gruvbox-dark-red-light";
          selected-urgent-foreground = mkLiteral "@urgent-foreground";
        };

        "#window" = {
          background-color = mkLiteral "@background";
          border = 2;
          padding = 2;
          width = 600;
        };

        "#mainbox" = {
          border = 0;
          padding = 0;
        };

        "#message" = {
          border = mkLiteral "2px 0 0";
          border-color = mkLiteral "@separatorcolor";
          padding = mkLiteral "1px";
        };

        "#textbox" = {
          highlight = mkLiteral "@highlight";
          text-color = mkLiteral "@foreground";
        };

        "#listview" = {
          border = mkLiteral "2px solid 0 0";
          padding = mkLiteral "2px 0 0";
          border-color = mkLiteral "@separatorcolor";
          spacing = mkLiteral "2px";
          scrollbar = mkLiteral "@scrollbar";
        };

        "#element" = {
          border = 0;
          padding = mkLiteral "2px";
        };

        "#element.normal.normal" = {
          background-color = mkLiteral "@normal-background";
          text-color = mkLiteral "@normal-foreground";
        };

        "#element.normal.urgent" = {
          background-color = mkLiteral "@urgent-background";
          text-color = mkLiteral "@urgent-foreground";
        };

        "#element.normal.active" = {
          background-color = mkLiteral "@active-background";
          text-color = mkLiteral "@active-foreground";
        };

        "#element.selected.normal" = {
          background-color = mkLiteral "@selected-normal-background";
          text-color = mkLiteral "@selected-normal-foreground";
        };

        "#element.selected.urgent" = {
          background-color = mkLiteral "@selected-urgent-background";
          text-color = mkLiteral "@selected-urgent-foreground";
        };

        "#element.selected.active" = {
          background-color = mkLiteral "@selected-active-background";
          text-color = mkLiteral "@selected-active-foreground";
        };

        "#element.alternate.normal" = {
          background-color = mkLiteral "@alternate-normal-background";
          text-color = mkLiteral "@alternate-normal-foreground";
        };

        "#element.alternate.urgent" = {
          background-color = mkLiteral "@alternate-urgent-background";
          text-color = mkLiteral "@alternate-urgent-foreground";
        };

        "#element.alternate.active" = {
          background-color = mkLiteral "@alternate-active-background";
          text-color = mkLiteral "@alternate-active-foreground";
        };

        "#scrollbar" = {
          width = mkLiteral "8px";
          border = 0;
          handle-color = mkLiteral "@scrollbar-handle";
          handle-width = mkLiteral "8px";
          padding = 0;
        };

        "#mode-switcher" = {
          border = mkLiteral "2px 0 0";
          border-color = mkLiteral "@separatorcolor";
        };

        "#inputbar" = {
          spacing = 0;
          text-color = mkLiteral "@normal-foreground";
          padding = mkLiteral "2px";
          children = map mkLiteral [
            "prompt"
            "textbox-prompt-sep"
            "entry"
            "case-indicator"
          ];
        };

        "case-indicator,entry,prompt,button" = {
          spacing = 0;
          text-color = mkLiteral "@normal-foreground";
        };

        "#button.selected" = {
          background-color = mkLiteral "@selected-normal-background";
          text-color = mkLiteral "@selected-normal-foreground";
        };

        "#textbox-prompt-sep" = {
          expand = false;
          str = ":";
          text-color = mkLiteral "@normal-foreground";
          margin = mkLiteral "0 0.3em 0 0";
        };
        "element-text, element-icon" = {
          background-color = mkLiteral "inherit";
          text-color = mkLiteral "inherit";
        };
      };
    };
  };
}
