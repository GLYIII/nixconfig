{ config, lib, pkgs, ... }:

{
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      # Commands to run in interactive sessions can go here

      function fish_user_key_bindings
          # Execute this once per mode that emacs bindings should be used in
          fish_default_key_bindings -M insert

          # Then execute the vi-bindings so they take precedence when there's a conflict.
          # Without --no-erase fish_vi_key_bindings will default to
          # resetting all bindings.
          # The argument specifies the initial mode (insert, "default" or visual).
          fish_vi_key_bindings --no-erase insert
      end

      function fish_mode_prompt
          switch $fish_bind_mode
              case default
                  set_color --bold red
                  echo "|Nrm|"
              case insert
                  set_color --bold green
                  echo "|Ins|"
              case replace_one
                  set_color --bold green
                  echo "|Rep|"
              case visual
                  set_color --bold brmagenta
                  echo "|Vis|"
              case '*'
                  set_color --bold red
                  echo "|?|"
          end
          set_color normal
      end



      # Emulates vim's cursor shape behavior
      # Set the normal and visual mode cursors to a block
      set fish_cursor_default block
      # Set the insert mode cursor to a line
      set fish_cursor_insert line
      # Set the replace mode cursor to an underscore
      set fish_cursor_replace_one underscore
      # The following variable can be used to configure cursor shape in
      # visual mode, but due to fish_cursor_default, is redundant here
      set fish_cursor_visual block

      #function fish_right_prompt -d "Write out the right prompt"
      #    echo '|'
      #    date '+%S'
      #    echo '|'
      #end

      #set -gx PAGER 'less --wheel-lines=4 --mouse --use-color -Dd+b -Du+g -DE+r -DS+ky -J -N -M'
      set -Ux ALTERNATE_EDITOR "emacs --daemon"
      set -gx PAGER bat
      set -gx EDITOR emacsclient -nw
      set -gx LESSHISTFILE /dev/null
      set -gx DOOMDIR "/home/jy/.config/doom/"
      set -gx XDG_CONFIG_HOME "/home/jy/.config/"
      #set -gx PATH "/home/jy/.cargo/bin"

      set -gx INPUTRC "home/jy/.config/inputrc"
      # set -gx KITTY_LISTEN_ON "unix:/tmp/mykitty"

      set -gx xserverauthfile "/home/jy/.Xauthority"
      set -gx XAUTHORITY "/home/jy/.Xauthority"

      # NNN settings
      set -gx NNN_TMPFILE /tmp/nnn
      set -gx NNN_FIFO "/tmp/nnn.fifo"
      set -gx NNN_PLUG "f:finder;o:fzopen;p:mocplay;d:diffs;t:nmount;l:preview-tui;i:imgview;g:getplugs;e:suedit;z:zathura"
      set -gx NNN_OPENER nvim
      set -gx BLK 04
      set -gx CHR 04
      set -gx DIR 04
      set -gx EXE 04
      set -gx REG 07
      set -gx HARDLINK 00
      set -gx SYMLINK 06
      set -gx MISSING 00
      set -gx ORPHAN 01
      set -gx FIFO 0F
      set -gx SOCK 0F
      set -gx OTHER 02
      set -gx NNN_FCOLORS "$BLK$CHR$DIR$EXE$REG$HARDLINK$SYMLINK$MISSING$ORPHAN$FIFO$SOCK$OTHER"

      #Use zoxide as a cd replacement
      zoxide init fish --cmd cd | source

      #  if [ $TERM = linux ]
      #      then
      #      echo -en "\e]P0282828" #black
      #      echo -en "\e]P8928374" #darkgrey
      #      echo -en "\e]P1cc241d" #darkred
      #      echo -en "\e]P9fb4934" #red
      #      echo -en "\e]P298971a" #darkgreen
      #      echo -en "\e]PAb8bb26" #green
      #      echo -en "\e]P3d79921" #brown
      #      echo -en "\e]PBfabd2f" #yellow
      #      echo -en "\e]P4458588" #darkblue
      #      echo -en "\e]PC83a598" #blue
      #      echo -en "\e]P5b16286" #darkmagenta
      #      echo -en "\e]PDd3869b" #magenta
      #      echo -en "\e]P6689d6a" #darkcyan
      #      echo -en "\e]PE8ec07c" #cyan
      #      echo -en "\e]P7a89984" #lightgrey
      #      echo -en "\e]PFebdbb2" #white
      #      clear #for background artifacting
      #  end


      #PFetch Environment Variables
      set -gx PF_INFO "ascii title os shell wm pkgs uptime memory"
      set -gx PF_SEP ":"
      set -gx PF_COL1 4
      set -gx PF_COL2 8
      set -gx PF_COL3 6

      # Allow non-free software useage in nixos
      set -gx NIXPKGS_ALLOW_UNFREE 1
      # Change the build shell to fish becuase I use fish for my interative shell.
      # set -gx NIX_BUILD_SHELL fish

      # eval (zellij setup --generate-auto-start fish | string collect)
      set -gx ALTERNATE_EDITOR "emacs -nw"
      set -gx _JAVA_AWT_WM_NONREPARENTING 1
    '';
    functions = {
      bat = {
        body = "command bat -p -f  $argv;";
        description = "alias -> bat = bat -p -f";
        wraps = "bat";
      };
      c = {
        body = "tmux respawn-pane -k $argv;";
        description = "alias -> c = tmux respawn-pane -k";
        wraps = "tmux respawn-pane -k";
      };
      cs = {
        body = "cd $argv";
        description = "alias -> cs = cd";
        wraps = "cd";
      };
      dock = {
        body = ''
          # Setting all intervals to Zero
          xset dpms 0 0 0 &
          xset s 0 0 &
          # Turning them all off for good measure
          xset -dpms &
          xset s off &
          # Correctly position external monitor
          xrandr --output DP-1-2 --mode 2560x1440 --rate 60 --left-of eDP-1
        '';
        description =
          "Diables dpms and screensaver and correctly positions monitor";
      };
      e = {
        body = "emacsclient -nw $argv;";
        description = "alias -> e = emacsclient -nw";
        wraps = "emacsclient -nw";
      };
      exa = {
        body = "command exa --icons --all -l $argv;";
        description = "alias -> exa = exa --icons --all -l";
        wraps = " exa --icons --all -l";
      };
      fish_greeting = {
        body = ''
          pfetch
          echo Welcome to The (set_color red; echo "Friendly"; set_color blue; echo "Interactive"; set_color green; echo "SHell."; set_color normal)
          echo The date and time are (set_color yellow; echo "|" ;date +%D; echo "|";date +%r; echo "|"; set_color normal)
          echo and Today is (set_color yellow; date +%A.)
        '';
        description = "User defined fish greeting";
      };
      fish_prompt = {
        body = ''
          #Save the return status of the previous command
          set -l last_pipestatus $pipestatus
          set -lx __fish_last_status $status # Export for __fish_print_pipestatus.

          if functions -q fish_is_root_user; and fish_is_root_user
              printf '%s@%s %s%s%s# ' $USER (prompt_hostname) (set -q fish_color_cwd_root
                                                               and set_color $fish_color_cwd_root
                                                               or set_color $fish_color_cwd) \
                  (prompt_pwd) (set_color normal)
          else
              set -l status_color (set_color $fish_color_status)
              set -l statusb_color (set_color --bold $fish_color_status)
              set -l pipestatus_string (__fish_print_pipestatus "[" "]" "|" "$status_color" "$statusb_color" $last_pipestatus)

              printf ' %s %s@%s%s %s%s %s%s%s \n =|> ' (echo "[")(set_color yellow)(date "+%r")(set_color normal)(echo "]")(set_color brblue) \
                  $USER (prompt_hostname) (set_color cyan)(fish_git_prompt) (set_color $fish_color_cwd) $PWD $pipestatus_string (set_color normal)

          end
        '';
        description = "Informative Prompt";
      };
      fish_right_prompt = { body = ""; };
      gaa = {
        body = "git add -A $argv;";
        description = "alias -> gaa = git add -A";
        wraps = "git add -A";
      };
      ga = {
        body = "git add $argv;";
        description = "alias -> ga = git add";
        wraps = "git add";
      };
      gcm = {
        body = "git commit -a -S $argv;";
        description = "alias -> gcm = git commit -a -S";
        wraps = "git commit -a -S";
      };
      gp = {
        body = "git push $argv;";
        description = "alias -> gp = git push";
        wraps = "git push";
      };
      gpl = {
        body = "git pull $argv;";
        description = "alias -> gpl = git pull";
        wraps = "git pull";
      };
      gst = {
        body = "git status";
        description = "alias -> gst = git status";
        wraps = "git status";
      };
      info = {
        body = "pinfo $argv;";
        description = "alias -> info = pinfo";
        wraps = "pinfo";
      };
      jellyfin = {
        body = "ssh home -L localhost:8096:localhost:8096 -N $argv;";
        description =
          "alias -> jellyfin = ssh home -L localhost:8096:localhost:8096 -N";
        wraps = "ssh home -L localhost:8096:localhost:8096 -N";
      };
      jf = {
        body = "exa -l -a --icons $argv;";
        description = "alias -> jf = exa -l -a --icons";
        wraps = "exa -l -a --icons";
      };
      la = {
        body = "exa -l -a --icons $argv;";
        description = "alias -> la = exa -l -a --icons";
        wraps = "exa -l -a --icons";
      };
      less = {
        body =
          "command less --wheel-lines=4 --mouse --use-color -Dd+b -Du+g -DE+r -DS+ky - J -N -M  $argv;";
        description =
          "alias -> command less --wheel-lines=4 --mouse --use-color -Dd+b -Du+g -DE+r -DS+ky - J -N -M";
        wraps =
          "command less --wheel-lines=4 --mouse --use-color -Dd+b -Du+g -DE+r -DS+ky - J -N -M";
      };
      ls = {
        body = "exa --icons --all --long $argv;";
        description = "alias -> ls = exa --icons --all --long";
        wraps = "exa --icons --all --long";
      };
      mans = {
        body = ''
          if test "$TMUX"
              tmux split-pane -h
              tmux resize-pane -x 82
              tmux send-keys "man "$argv\n
              tmux select-pane -t 1
          else if test "$ZELLIJ"
              zellij action new-pane -d right -c -- man $argv
              zellij action resize -
              zellij action move-focus left
          end
        '';
        description = "open a man page off the side to save space";
        wraps = "";
      };
      mbsync = {
        body = "command mbsync -c /home/jy/.config/mbsync/mbsyncrc $argv;";
        description =
          "alias -> mbsync = command mbsync -c /home/jy/.config/mbsync/mbsyncrc $argv; ";
        wraps = "mbsync -c /home/jy/.config/mbsync/mbsyncrc";
      };
      mirrorscr = {
        body =
          "xrandr --output eDP-1 --rotate inverted && xrandr --output eDP-1 --reflect y $argv;";
        description =
          "alias -> mirrorscr = xrandr --output eDP-1 --rotate inverted && xrandr --output eDP-1 --reflect y $argv;";
        wraps =
          "xrandr --output eDP-1 --rotate inverted && xrandr --output eDP-1 --reflect y";
      };
      mon = {
        body = "";
        description = "";
        wraps = "";
      };
      nc = {
        body = ''
          if test "$TMUX"
              tmux send-keys ncmpcpp C-m
              tmux select-pane -t 1
              tmux split-window -v
              tmux send-keys ncmpcpp C-m
              tmux send-keys 9
              tmux send-keys u
              tmux send-keys "\\"
              tmux resize-pane -t 1 -y 63
              #tmux resize-pane -t 1 -x 290 -y 63
              tmux resize-pane -t 2 -y 24
              tmux select-pane -t 1
          else if test "$ZELLIJ"
              zellij action new-pane -d down -c -- ncmpcpp -s visualizer
              zellij action write-chars "\\"
              zellij action resize -
              zellij action resize -
              zellij action resize -
              zellij action resize -
              zellij action resize -
              zellij action move-focus up
              zellij action write-chars ncmpcpp\n
          end
        '';
        description =
          "uses a terminal multiplexer to put a spectrum analyzer at the bottom of window";
        wraps = "ncmpcpp";
      };
      n = {
        body = ''
              # Block nesting of nnn in subshells
              if test -n "$NNNLVL"
                  if [ (expr $NNNLVL + 0) -ge 1 ]
                      echo "nnn is already running"
          	    set -gx MANPAGER "bat "
                  else
          		set -gx MANPAGER "bat --style=full"
                  end
              end

              # The default behaviour is to cd on quit (nnn checks if NNN_TMPFILE is set)
              # To cd on quit only on ^G, remove the "-x" as in:
              #    set NNN_TMPFILE "$XDG_CONFIG_HOME/nnn/.lastd"
              if test -n "$XDG_CONFIG_HOME"
                  set -x NNN_TMPFILE "$XDG_CONFIG_HOME/nnn/.lastd"
              else
                  set -x NNN_TMPFILE "$HOME/.config/nnn/.lastd"
              end

              # Unmask ^Q (, ^V etc.) (if required, see `stty -a`) to Quit nnn
              # stty start undef
              # stty stop undef
              # stty lwrap undef
              # stty lnext undef

              nnn $argv

              if test -e $NNN_TMPFILE
                  source $NNN_TMPFILE
                  rm $NNN_TMPFILE
              end
        '';
        description = "support nnn quit and change directory";
        wraps = "nnn";
      };
      nnn = {
        body = "command nnn -a -H -e -i -x -U -d -P l $argv;";
        description = "alias -> nnn = command nnn -a -H -e -i -x -U -d -P l";
        wraps = "nnn";
      };
      nv = {
        body = "nv $argv;";
        description = "alias -> nv = nvim";
        wraps = "nvim";
      };
      pubip = {
        body = "curl https://ipinfo.io/ip ; echo $argv;";
        description = "retrieves the public ip of the computer";
        wraps = "curl https://ipinfo.io/ip ; echo $argv";
      };
      quit = {
        body = "exit $argv";
        description = "alias -> quit = exit ";
        wraps = "exit";
      };
      rdoc = {
        body = ''
          xdg-open file:///home/jy/.rustup/toolchains/stable-x86_64-unknown-linux-gnu/share/doc/rust/html/book/index.html &
          xdg-open file:///home/jy/.rustup/toolchains/stable-x86_64-unknown-linux-gnu/share/doc/rust/html/rust-by-example/index.html & xdg-open file:///home/jy/.rustup/toolchains/stable-x86_64-unknown-linux-gnu/share/doc/rust/html/std/index.html &
          xdg-open file:///home/jy/.rustup/toolchains/stable-x86_64-unknown-linux-gnu/share/doc/rust/html/index.html#the-rustc-book $argv;
        '';
        description =
          "Opens the main rust documentation with the user default browser";
        wraps = "xdg-open";
      };
      seedbox = {
        body = "ssh home -L localhost:8081:localhost:8081 -N $argv;";
        description =
          "alias -> seedbox = ssh home -L localhost:8081:localhost:8081 -N";
        wraps = "ssh home -L localhost:8081:localhost:8081 -N";
      };
      unmirrorscr = {
        body = ''
          xrandr --output eDP-1 --rotate normal &
          xrandr --output eDP-1 --reflect normal $argv
        '';
        description = "Unmirrors the screen";
        wraps =
          " xrandr --output eDP-1 --rotate normal & xrandr --output eDP-1 --reflect normal $argv";
      };
    };
  };
}
