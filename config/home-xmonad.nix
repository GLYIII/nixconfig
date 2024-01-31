{ config, lib, pkgs, ... }:

{
  xsession = {
    windowManager = {
      xmonad = {
        enable = true;
        enableContribAndExtras = true;
        extraPackages = hp: [ hp.xmonad-contrib hp.xmonad-extras hp.xmonad ];
        config = pkgs.writeText "xmonad.hs" ''
            -- Base
          import XMonad
          import System.Directory
          import System.IO (hClose, hPutStr, hPutStrLn)
          import System.Exit (exitSuccess)
          import qualified XMonad.StackSet as W

              -- Actions
          import XMonad.Actions.CopyWindow (kill1)
          import XMonad.Actions.CycleWS (Direction1D(..), moveTo, shiftTo, WSType(..), nextScreen, prevScreen)
          import XMonad.Actions.GridSelect
          import XMonad.Actions.MouseResize
          import XMonad.Actions.Promote
          import XMonad.Actions.RotSlaves (rotSlavesDown, rotAllDown)
          import XMonad.Actions.WindowGo (runOrRaise)
          import XMonad.Actions.WithAll (sinkAll, killAll)
          import qualified XMonad.Actions.Search as S

              -- Data
          import Data.Char (isSpace, toUpper)
          import Data.Maybe (fromJust)
          import Data.Monoid
          import Data.Maybe (isJust)
          import Data.Tree
          import qualified Data.Map as M

              -- Hooks
          import XMonad.Hooks.DynamicLog (dynamicLogWithPP, wrap, xmobarPP, xmobarColor, shorten, PP(..))
          import XMonad.Hooks.EwmhDesktops  -- for some fullscreen events, also for xcomposite in obs.
          import XMonad.Hooks.ManageDocks (avoidStruts, docks, manageDocks, ToggleStruts(..))
          import XMonad.Hooks.ManageHelpers (isFullscreen, doFullFloat, doCenterFloat)
          import XMonad.Hooks.ServerMode
          import XMonad.Hooks.SetWMName
          import XMonad.Hooks.StatusBar
          import XMonad.Hooks.StatusBar.PP
          import XMonad.Hooks.WindowSwallowing
          import XMonad.Hooks.WorkspaceHistory

              -- Layouts
          import XMonad.Layout.Accordion
          import XMonad.Layout.GridVariants (Grid(Grid))
          import XMonad.Layout.SimplestFloat
          import XMonad.Layout.Spiral
          import XMonad.Layout.ResizableTile
          import XMonad.Layout.Tabbed
          import XMonad.Layout.ThreeColumns


              -- Layouts modifiers
          import XMonad.Layout.LayoutModifier
          import XMonad.Layout.LimitWindows (limitWindows, increaseLimit, decreaseLimit)
          import XMonad.Layout.MultiToggle (mkToggle, single, EOT(EOT), (??))
          import XMonad.Layout.MultiToggle.Instances (StdTransformers(NBFULL, MIRROR, NOBORDERS))
          import XMonad.Layout.NoBorders
          import XMonad.Layout.Renamed
          import XMonad.Layout.ShowWName
          import XMonad.Layout.Simplest
          import XMonad.Layout.Spacing
          import XMonad.Layout.SubLayouts
          import XMonad.Layout.WindowArranger (windowArrange, WindowArrangerMsg(..))
          import XMonad.Layout.WindowNavigation
          import qualified XMonad.Layout.ToggleLayouts as T (toggleLayouts, ToggleLayout(Toggle))
          import qualified XMonad.Layout.MultiToggle as MT (Toggle(..))

             -- Utilities
          import XMonad.Util.Dmenu
          import XMonad.Util.EZConfig (additionalKeysP, mkNamedKeymap)
          -- import XMonad.Util.Hacks (windowedFullscreenFixEventHook, javaHack, trayerAboveXmobarEventHook, trayAbovePanelEventHook, trayerPaddingXmobarEventHook, trayPaddingXmobarEventHook, trayPaddingEventHook)
          import XMonad.Util.Hacks (windowedFullscreenFixEventHook, javaHack )
          import XMonad.Util.NamedActions
          import XMonad.Util.NamedScratchpad
          import XMonad.Util.Run (runProcessWithInput, safeSpawn, spawnPipe)
          import XMonad.Util.SpawnOnce

             --Prompts
          import XMonad.Prompt
          import XMonad.Prompt.Man
          import XMonad.Prompt.Pass

          colorScheme = "gruvbox-dark"

            -- Black BG
          colorBack = "#282828"
            -- White FG
          colorFore = "#ebdbb2"

            -- Black
          color01 = "#282828"
            -- Red
          color02 = "#cc241d"
            -- Green
          color03 = "#98971a"
            -- Yellow
          color04 = "#d79921"
            -- Blue
          color05 = "#458588"
            -- Purple
          color06 = "#b16286"
            -- Aqua
          color07 = "#689d6a"
            -- Gray
          color08 = "#a89984"
            -- Gray
          color09 = "#928374"
            -- Bright Red
          color10 = "#fb4934"
            -- Bright Green
          color11 = "#b8bb26"
            -- Bright Yellow
          color12 = "#fabd2f"
            -- Bright Blue
          color13 = "#83a598"
            -- Bright Purple
          color14 = "#d3869b"
            -- Bright Aqua
          color15 = "#8ec07c"
            -- White
          color16 = "#ebdbb2"

          colorTrayer :: String
          colorTrayer = "--tint 0x282828"

          myFont :: String
          myFont = "xft:FiraCode:weight=regular:antialias=true:pixelsize=14:hinting=true"

          myModMask :: KeyMask
          myModMask = mod4Mask        -- Sets modkey to super/windows key
          -- myModMask = mod1Mask        -- Sets modkey to meta/alt key

          myTerminal :: String
          myTerminal = "kitty"    -- Sets default terminal

          myBrowser :: String
          myBrowser = "qutebrowser "  -- Sets qutebrowser as browser

          myEmacs :: String
          myEmacs = "emacsclient -c -a 'emacs' "  -- Makes emacs keybindings easier to type

          myEditor :: String
          myEditor = "emacsclient -c -a 'emacs' "  -- Sets emacs as editor
          -- myEditor = myTerminal ++ " -e vim "    -- Sets vim as editor

          myBorderWidth :: Dimension
          myBorderWidth = 2           -- Sets border width for windows

          myNormColor :: String       -- Border color of normal windows
          myNormColor   = colorBack   -- This variable is imported from Colors.THEME

          myFocusColor :: String      -- Border color of focused windows
          myFocusColor  = color15     -- This variable is imported from Colors.THEME

          myNewBg :: String
          myNewBg = "feh --randomize --no-fehbg --bg-fill /home/jy/Pictures/wallpapers/*"

          windowCount :: X (Maybe String)
          windowCount = gets $ Just . show . length . W.integrate' . W.stack . W.workspace . W.current . windowset

          myStartupHook :: X ()
          myStartupHook = do
            -- spawnOnce "picom"

            spawnOnce "feh  --no-fehbg --bg-fill /home/jy/Pictures/wallpapers/space.tif"  -- feh set random wallpaper

            setWMName "Xmnd"

          myNavigation :: TwoD a (Maybe a)
          myNavigation = makeXEventhandler $ shadowWithKeymap navKeyMap navDefaultHandler
           where navKeyMap = M.fromList [
                    ((0,xK_Escape), cancel)
                   ,((0,xK_Return), select)
                   ,((0,xK_slash) , substringSearch myNavigation)
                   ,((0,xK_Left)  , move (-1,0)  >> myNavigation)
                   ,((0,xK_h)     , move (-1,0)  >> myNavigation)
                   ,((0,xK_Right) , move (1,0)   >> myNavigation)
                   ,((0,xK_l)     , move (1,0)   >> myNavigation)
                   ,((0,xK_Down)  , move (0,1)   >> myNavigation)
                   ,((0,xK_j)     , move (0,1)   >> myNavigation)
                   ,((0,xK_Up)    , move (0,-1)  >> myNavigation)
                   ,((0,xK_k)     , move (0,-1)  >> myNavigation)
                   ,((0,xK_y)     , move (-1,-1) >> myNavigation)
                   ,((0,xK_i)     , move (1,-1)  >> myNavigation)
                   ,((0,xK_n)     , move (-1,1)  >> myNavigation)
                   ,((0,xK_m)     , move (1,-1)  >> myNavigation)
                   ,((0,xK_space) , setPos (0,0) >> myNavigation)
                   ]
                 navDefaultHandler = const myNavigation

          myColorizer :: Window -> Bool -> X (String, String)
          myColorizer = colorRangeFromClassName
                          (0x28,0x2c,0x34) -- lowest inactive bg
                          (0x28,0x2c,0x34) -- highest inactive bg
                          (0xc7,0x92,0xea) -- active bg
                          (0xc0,0xa7,0x9a) -- inactive fg
                          (0x28,0x2c,0x34) -- active fg

          -- gridSelect menu layout
          mygridConfig :: p -> GSConfig Window
          mygridConfig colorizer = (buildDefaultGSConfig myColorizer)
              { gs_cellheight   = 40
              , gs_cellwidth    = 200
              , gs_cellpadding  = 6
              , gs_navigate    = myNavigation
              , gs_originFractX = 0.5
              , gs_originFractY = 0.5
              , gs_font         = myFont
              }

          spawnSelected' :: [(String, String)] -> X ()
          spawnSelected' lst = gridselect conf lst >>= flip whenJust spawn
              where conf = def
                             { gs_cellheight   = 40
                             , gs_cellwidth    = 180
                             , gs_cellpadding  = 6
                             , gs_originFractX = 0.5
                             , gs_originFractY = 0.5
                             , gs_font         = myFont
                             }

          runSelectedAction' :: GSConfig (X ()) -> [(String, X ())] -> X ()
          runSelectedAction' conf actions = do
              selectedActionM <- gridselect conf actions
              case selectedActionM of
                  Just selectedAction -> selectedAction
                  Nothing -> return ()

          gsCategories =
            [
              ("Games",      "xdotool key super+alt+1")
            , ("Internet",   "xdotool key super+alt+3")
            , ("Multimedia", "xdotool key super+alt+4")
            , ("Office",     "xdotool key super+alt+5")
            , ("Settings",   "xdotool key super+alt+6")
            , ("System",     "xdotool key super+alt+7")
            , ("Utilities",  "xdotool key super+alt+8")
            ]

          gsGames =
            [
              ("GZDoom", "gzdoom")
            , ("Minecraft", "prismlauncher")
            , ("Cataclysm", "cataclysm-tiles")
            , ("Steam", "steam")
            ]

          gsInternet =
            [
              ("Firefox", "firefox")
            , ("Discord", "discord")
            , ("Qutebrowser", "qutebrowser")
            , ("Signal", "signal-desktop")
            ]

          gsMultimedia =
            [
              ("Ncmpcpp", (myTerminal ++ " -e ncmpcpp"))
            , ("Feh", "feh /home/jy/Pictures/*")
            , ("Calibre", "calibre")
            ]

          gsOffice =
            [
              ("LibreOffice", "libreoffice")
            , ("LO Base", "soffice --base")
            , ("LO Calc", "soffice --calc")
            , ("LO Draw", "soffice --draw")
            , ("LO Impress", "soffice --impress")
            , ("LO Math", "soffice --math")
            , ("LO Writer", "soffice --writer")
            ]

          gsSettings =
            [
              ("Volume" , (myTerminal ++ " -e alsamixer"))
            , ("Nmtui", (myTerminal ++ " -e nmtui"))
            ]

          gsSystem =
            [
              ("Btop", (myTerminal ++ " -e btop"))
            , ("Diskonaut", (myTerminal ++ " -e diskonaut"))
            ]

          gsUtilities =
            [
              ("EmacsClient", "emacsclient -c -a 'emacs'")
            , ("Emacs", "emacs")
            , ("Zathura", "zathura")
            ]

          myScratchPads :: [NamedScratchpad]
          myScratchPads = [ NS "terminal" spawnTerm findTerm manageTerm]
            where
              spawnTerm  = myTerminal ++ " -t scratchpad"
              findTerm   = title =? "scratchpad"
              manageTerm = customFloating $ W.RationalRect l t w h
                         where
                           h = 0.9
                           w = 0.9
                           t = 0.95 -h
                           l = 0.95 -w

          --Makes setting the spacingRaw simpler to write. The spacingRaw module adds a configurable amount of space around windows.
          mySpacing :: Integer -> l a -> XMonad.Layout.LayoutModifier.ModifiedLayout Spacing l a
          mySpacing i = spacingRaw False (Border i i i i) True (Border i i i i) True

          -- Below is a variation of the above except no borders are applied
          -- if fewer than two windows. So a single window has no gaps.
          mySpacing' :: Integer -> l a -> XMonad.Layout.LayoutModifier.ModifiedLayout Spacing l a
          mySpacing' i = spacingRaw True (Border i i i i) True (Border i i i i) True

          -- Defining a bunch of layouts, many that I don't use.
          -- limitWindows n sets maximum number of windows displayed for layout.
          -- mySpacing n sets the gap size around the windows.
          tall     = renamed [Replace "tall"]
                     $ limitWindows 5
                     $ smartBorders
                     $ windowNavigation
                     $ addTabs shrinkText myTabTheme
                     $ subLayout [] (smartBorders Simplest)
                     $ mySpacing 8
                     $ ResizableTall 1 (3/100) (1/2) []
          monocle  = renamed [Replace "monocle"]
                     $ smartBorders
                     $ windowNavigation
                     $ addTabs shrinkText myTabTheme
                     $ subLayout [] (smartBorders Simplest)
                     $ Full
          floats   = renamed [Replace "floats"]
                     $ smartBorders
                     $ simplestFloat
          grid     = renamed [Replace "grid"]
                     $ limitWindows 9
                     $ smartBorders
                     $ windowNavigation
                     $ addTabs shrinkText myTabTheme
                     $ subLayout [] (smartBorders Simplest)
                     $ mySpacing 8
                     $ mkToggle (single MIRROR)
                     $ Grid (16/10)
          spirals  = renamed [Replace "spirals"]
                     $ limitWindows 9
                     $ smartBorders
                     $ windowNavigation
                     $ addTabs shrinkText myTabTheme
                     $ subLayout [] (smartBorders Simplest)
                     $ mySpacing' 8
                     $ spiral (6/7)
          threeCol = renamed [Replace "threeCol"]
                     $ limitWindows 7
                     $ smartBorders
                     $ windowNavigation
                     $ addTabs shrinkText myTabTheme
                     $ subLayout [] (smartBorders Simplest)
                     $ ThreeCol 1 (3/100) (1/2)
          threeRow = renamed [Replace "threeRow"]
                     $ limitWindows 7
                     $ smartBorders
                     $ windowNavigation
                     $ addTabs shrinkText myTabTheme
                     $ subLayout [] (smartBorders Simplest)
                     -- Mirror takes a layout and rotates it by 90 degrees.
                     -- So we are applying Mirror to the ThreeCol layout.
                     $ Mirror
                     $ ThreeCol 1 (3/100) (1/2)
          tabs     = renamed [Replace "tabs"]
                     -- I cannot add spacing to this layout because it will
                     -- add spacing between window and tabs which looks bad.
                     $ tabbed shrinkText myTabTheme
          tallAccordion  = renamed [Replace "tallAccordion"]
                     $ Accordion
          wideAccordion  = renamed [Replace "wideAccordion"]
                     $ Mirror Accordion

          -- setting colors for tabs layout and tabs sublayout.
          myTabTheme = def { fontName            = myFont
                           , activeColor         = color15
                           , inactiveColor       = color08
                           , activeBorderColor   = color15
                           , inactiveBorderColor = colorBack
                           , activeTextColor     = colorBack
                           , inactiveTextColor   = color16
                           }

          -- Theme for showWName which prints current workspace when you change workspaces.
          myShowWNameTheme :: SWNConfig
          myShowWNameTheme = def
            { swn_font              = "xft:FiraCode:bold:size=60"
            , swn_fade              = 1.0
            , swn_bgcolor           = "#282828"
            , swn_color             = "#ebdbb2"
            }

          -- The layout hook
          myLayoutHook = avoidStruts
                         $ mouseResize
                         $ windowArrange
                         $ T.toggleLayouts floats
                         $ mkToggle (NBFULL ?? NOBORDERS ?? EOT) myDefaultLayout
            where
              myDefaultLayout = withBorder myBorderWidth tall
                                                     ||| noBorders monocle
                                                     ||| floats
                                                     ||| noBorders tabs
                                                     ||| grid
                                                     ||| spirals
                                                     ||| threeCol
                                                     ||| threeRow
                                                     ||| tallAccordion
                                                     ||| wideAccordion


          myWorkspaces = [" I ", " II ", " III ", " IV ", " V ", " VI ", " VII ", " VIII ", " IX "]
          -- myWorkspaces = [" 1 ", " 2 ", " 3 ", " 4 ", " 5 ", " 6 ", " 7 ", " 8 ", " 9 "]
          -- myWorkspaces = [" dev ", " www ", " sys ", " doc ", " vbox ", " chat ", " mus ", " vid ", " gfx "]
          -- myWorkspaces =
          --         " 1 : <fn=2>\xf111</fn> " :
          --         " 2 : <fn=2>\xf1db</fn> " :
          --         " 3 : <fn=2>\xf192</fn> " :
          --         " 4 : <fn=2>\xf025</fn> " :
          --         " 5 : <fn=2>\xf03d</fn> " :
          --         " 6 : <fn=2>\xf1e3</fn> " :
          --         " 7 : <fn=2>\xf07b</fn> " :
          --         " 8 : <fn=2>\xf21b</fn> " :
          --         " 9 : <fn=2>\xf21e</fn> " :
          --         []
          myWorkspaceIndices = M.fromList $ zipWith (,) myWorkspaces [1..] -- (,) == \x y -> (x,y)

          clickable ws = "<action=xdotool key super+"++show i++">"++ws++"</action>"
              where i = fromJust $ M.lookup ws myWorkspaceIndices

          myManageHook :: XMonad.Query (Data.Monoid.Endo WindowSet)
          myManageHook = composeAll
            -- 'doFloat' forces a window to float.  Useful for dialog boxes and such.
            -- using 'doShift ( myWorkspaces !! 7)' sends program to workspace 8!
            -- I'm doing it this way because otherwise I would have to write out the full
            -- name of my workspaces and the names would be very long if using clickable workspaces.
            [ className =? "confirm"         --> doFloat
            , className =? "file_progress"   --> doFloat
            , className =? "dialog"          --> doFloat
            , className =? "download"        --> doFloat
            , className =? "error"           --> doFloat
            , className =? "Gimp"            --> doFloat
            , className =? "notification"    --> doFloat
            , className =? "pinentry-gtk-2"  --> doFloat
            , isFullscreen -->  doFullFloat
            ] <+> namedScratchpadManageHook myScratchPads


          subtitle' ::  String -> ((KeyMask, KeySym), NamedAction)
          subtitle' x = ((0,0), NamedAction $ map toUpper
                                $ sep ++ "\n-- " ++ x ++ " --\n" ++ sep)
            where
              sep = replicate (6 + length x) '-'

          showKeybindings :: [((KeyMask, KeySym), NamedAction)] -> NamedAction
          showKeybindings x = addName "Show Keybindings" $ io $ do
            h <- spawnPipe $ "yad --text-info --fontname=\"SauceCodePro Nerd Font Mono 12\" --fore=#46d9ff back=#282c36 --center --geometry=1200x800 --title \"XMonad keybindings\""
            --hPutStr h (unlines $ showKm x) -- showKM adds ">>" before subtitles
            hPutStr h (unlines $ showKmSimple x) -- showKmSimple doesn't add ">>" to subtitles
            hClose h
            return ()

          myKeys :: XConfig l0 -> [((KeyMask, KeySym), NamedAction)]
          myKeys c =
            --(subtitle "Custom Keys":) $ mkNamedKeymap c $
            let subKeys str ks = subtitle' str : mkNamedKeymap c ks in
            subKeys "Xmonad Essentials"
            [ ("M-C-r",                   addName "Recompile XMonad"                       $ spawn "xmonad --recompile")
            , ("M-S-r",                   addName "Restart XMonad"                         $ spawn "xmonad --restart")
            , ("M-r r",                   addName "Restart"                                $ spawn "reboot")
            , ("M-r f",                   addName "Poweroff"                               $ spawn "poweroff")
            , ("M-S-q",                   addName "Quit XMonad"                            $ io exitSuccess)
            , ("M-c",                     addName "Kill focused window"                    $ kill1)
            , ("M-S-a",                   addName "Kill all windows on WS"                 $ killAll)
            , ("M-S-<Return>",            addName "Run prompt"                             $ spawn "rofi -show combi")
            ]

            ^++^ subKeys "Switch to workspace"
            [ ("M-1",                     addName "Switch to workspace 1"                  $ (windows $ W.greedyView $ myWorkspaces !! 0))
            , ("M-2",                     addName "Switch to workspace 2"                  $ (windows $ W.greedyView $ myWorkspaces !! 1))
            , ("M-3",                     addName "Switch to workspace 3"                  $ (windows $ W.greedyView $ myWorkspaces !! 2))
            , ("M-4",                     addName "Switch to workspace 4"                  $ (windows $ W.greedyView $ myWorkspaces !! 3))
            , ("M-5",                     addName "Switch to workspace 5"                  $ (windows $ W.greedyView $ myWorkspaces !! 4))
            , ("M-6",                     addName "Switch to workspace 6"                  $ (windows $ W.greedyView $ myWorkspaces !! 5))
            , ("M-7",                     addName "Switch to workspace 7"                  $ (windows $ W.greedyView $ myWorkspaces !! 6))
            , ("M-8",                     addName "Switch to workspace 8"                  $ (windows $ W.greedyView $ myWorkspaces !! 7))
            , ("M-9",                     addName "Switch to workspace 9"                  $ (windows $ W.greedyView $ myWorkspaces !! 8))]

            ^++^ subKeys "Send window to workspace"
            [ ("M-S-1",                   addName "Send to workspace 1"                    $ (windows $ W.shift $ myWorkspaces !! 0))
            , ("M-S-2",                   addName "Send to workspace 2"                    $ (windows $ W.shift $ myWorkspaces !! 1))
            , ("M-S-3",                   addName "Send to workspace 3"                    $ (windows $ W.shift $ myWorkspaces !! 2))
            , ("M-S-4",                   addName "Send to workspace 4"                    $ (windows $ W.shift $ myWorkspaces !! 3))
            , ("M-S-5",                   addName "Send to workspace 5"                    $ (windows $ W.shift $ myWorkspaces !! 4))
            , ("M-S-6",                   addName "Send to workspace 6"                    $ (windows $ W.shift $ myWorkspaces !! 5))
            , ("M-S-7",                   addName "Send to workspace 7"                    $ (windows $ W.shift $ myWorkspaces !! 6))
            , ("M-S-8",                   addName "Send to workspace 8"                    $ (windows $ W.shift $ myWorkspaces !! 7))
            , ("M-S-9",                   addName "Send to workspace 9"                    $ (windows $ W.shift $ myWorkspaces !! 8))]

            ^++^ subKeys "Move window to WS and go there"
            [ ("M-S-<Page_Up>",           addName "Move window to next WS"                 $ shiftTo Next nonNSP >> moveTo Next nonNSP)
            , ("M-S-<Page_Down>",         addName "Move window to prev WS"                 $ shiftTo Prev nonNSP >> moveTo Prev nonNSP)]

            ^++^ subKeys "Window navigation"
            [ ("M-n",                     addName "Move focus to next window"              $ windows W.focusDown)
            , ("M-S-n",                   addName "Move focus to prev window"              $ windows W.focusUp)
            , ("M-m",                     addName "Move focus to master window"            $ windows W.focusMaster)
            , ("M-S-j",                   addName "Swap focused window with next window"   $ windows W.swapDown)
            , ("M-S-k",                   addName "Swap focused window with prev window"   $ windows W.swapUp)
            , ("M-S-m",                   addName "Swap focused window with master window" $ windows W.swapMaster)
            , ("M-<Backspace>",           addName "Move focused window to master"          $ promote)
            , ("M-S-,",                   addName "Rotate all windows except master"       $ rotSlavesDown)
            , ("M-S-.",                   addName "Rotate all windows current stack"       $ rotAllDown)]

            ^++^ subKeys "Favorite programs"
            [ ("M-<Return>",              addName "Launch terminal"                        $ spawn (myTerminal ++ " -e zellij"))
            , ("M-b",                     addName "Launch web browser"                     $ spawn (myBrowser))
            , ("M-M1-h",                  addName "Launch btop"                            $ spawn (myTerminal ++ " -e btop"))
            , ("M-z",                     addName "Launch zathura"                         $ spawn "zathura")
            , ("M-S-b",                   addName "Change the background to something"     $ spawn myNewBg )  ]

            ^++^ subKeys "Monitors"
            [ ("M-.",                     addName "Switch focus to next monitor"           $ nextScreen)
            , ("M-,",                     addName "Switch focus to prev monitor"           $ prevScreen)]

            -- Switch layouts
            ^++^ subKeys "Switch layouts"
            [ ("M-<Tab>",                 addName "Switch to next layout"                  $ sendMessage NextLayout)
            , ("M-<Space>",               addName "Toggle noborders/full"                  $ sendMessage (MT.Toggle NBFULL) >> sendMessage ToggleStruts)]

            -- Window resizing
            ^++^ subKeys "Window resizing"
            [ ("M-h",                     addName "Shrink window"                          $ sendMessage Shrink)
            , ("M-l",                     addName "Expand window"                          $ sendMessage Expand)
            , ("M-M1-j",                  addName "Shrink window vertically"               $ sendMessage MirrorShrink)
            , ("M-M1-k",                  addName "Expand window vertically"               $ sendMessage MirrorExpand)]

            -- Floating windows
            ^++^ subKeys "Floating windows"
            [ ("M-f",                     addName "Toggle float layout"                    $ sendMessage (T.Toggle "floats"))
            , ("M-t",                     addName "Sink a floating window"                 $ withFocused $ windows . W.sink)
            , ("M-S-t",                   addName "Sink all floated windows"               $ sinkAll)
            ]

            -- Increase/decrease spacing (gaps)
            ^++^ subKeys "Window spacing (gaps)"
            [ ("C-M1-j",                  addName "Decrease window spacing"                $ decWindowSpacing 4)
            , ("C-M1-k",                  addName "Increase window spacing"                $ incWindowSpacing 4)
            , ("C-M1-h",                  addName "Decrease screen spacing"                $ decScreenSpacing 4)
            , ("C-M1-l",                  addName "Increase screen spacing"                $ incScreenSpacing 4)]

            -- Increase/decrease windows in the master pane or the stack
            ^++^ subKeys "Increase/decrease windows in master pane or the stack"
            [ ("M-S-<Up>",                addName "Increase clients in master pane"        $ sendMessage (IncMasterN 1))
            , ("M-S-<Down>",              addName "Decrease clients in master pane"        $ sendMessage (IncMasterN (-1)))
            , ("M-=",                     addName "Increase max # of windows for layout"   $ increaseLimit)
            , ("M--",                     addName "Decrease max # of windows for layout"   $ decreaseLimit)]

            -- Sublayouts
            -- This is used to push windows to tabbed sublayouts, or pull them out of it.
            ^++^ subKeys "Sublayouts"
            [ ("M-C-h",                   addName "pullGroup L"                            $ sendMessage $ pullGroup L)
            , ("M-C-l",                   addName "pullGroup R"                            $ sendMessage $ pullGroup R)
            , ("M-C-k",                   addName "pullGroup U"                            $ sendMessage $ pullGroup U)
            , ("M-C-j",                   addName "pullGroup D"                            $ sendMessage $ pullGroup D)
            , ("M-C-m",                   addName "MergeAll"                               $ withFocused (sendMessage . MergeAll))
          --, ("M-C-u",                   addName "UnMerge"                                $ withFocused (sendMessage . UnMerge))
            , ("M-C-/",                   addName "UnMergeAll"                             $ withFocused (sendMessage . UnMergeAll))
            , ("M-C-.",                   addName "Switch focus next tab"                  $ onGroup W.focusUp')
            , ("M-C-,",                   addName "Switch focus prev tab"                  $ onGroup W.focusDown')]

            -- Scratchpads
            -- Toggle show/hide these programs. They run on a hidden workspace.
            -- When you toggle them to show, it brings them to current workspace.
            -- Toggle them to hide and it sends them back to hidden workspace (NSP).
            ^++^ subKeys "Scratchpads"
            [ ("M-s t",                   addName "Toggle scratchpad terminal"             $ namedScratchpadAction myScratchPads "terminal")
            -- , ("M-s m",                   addName "Toggle scratchpad mocp"                 $ namedScratchpadAction myScratchPads "mocp")
            , ("M-s c",                   addName "Toggle scratchpad calculator"           $ namedScratchpadAction myScratchPads "calculator")]

            -- Controls for mocp music player (SUPER-u followed by a key)
            ^++^ subKeys "Music Player Daemon"
            [ ("M-u p",                   addName "MPD play"                               $ spawn "mpc --port 6666 play")
            , ("M-u l",                   addName "MPD next"                               $ spawn "mpc --port 6666 next")
            , ("M-u h",                   addName "MPD prev"                               $ spawn "mpc --port 6666 previous")
            , ("M-u <Space>",             addName "MPD toggle pause"                       $ spawn "mpc --port 6666 toggle")]

            ^++^ subKeys "GridSelect"
          --, ("C-g g",                   addName "Select apps"     $ runSelectedAction' defaultGSConfig gsCategories)
            [ ("M-g <Return>",            addName "Select favorite apps"                   $ spawnSelected'
                -- $ gsGames ++ gsEducation ++ gsInternet ++ gsMultimedia ++ gsOffice ++ gsSettings ++ gsSystem ++ gsUtilities)
                -- $ gsGames ++ gsInternet ++ gsSystem ++ gsUtilities)
                -- $ gsGames ++ gsInternet ++ gsMultimedia ++ gsOffice ++ gsSystem ++ gsUtilities)
                $ gsGames ++ gsInternet ++ gsMultimedia ++ gsOffice ++ gsSettings ++ gsSystem ++ gsUtilities)
            , ("M-g c",                   addName "Select favorite apps"                   $ spawnSelected' gsCategories)
            , ("M-g t",                   addName "Goto selected window"                   $ goToSelected $ mygridConfig myColorizer)
            , ("M-g b",                   addName "Bring selected window"                  $ bringSelected $ mygridConfig myColorizer)
            , ("M-g 1",                   addName "Menu of games"                          $ spawnSelected' gsGames)
            -- , ("M-g 2",                   addName "Menu of education apps"                 $ spawnSelected' gsEducation)
            , ("M-g 3",                   addName "Menu of Internet apps"                  $ spawnSelected' gsInternet)
            , ("M-g 4",                   addName "Menu of multimedia apps"                $ spawnSelected' gsMultimedia)
            , ("M-g 5",                   addName "Menu of office apps"                    $ spawnSelected' gsOffice)
            , ("M-g 6",                   addName "Menu of settings apps"                  $ spawnSelected' gsSettings)
            , ("M-g 7",                   addName "Menu of system apps"                    $ spawnSelected' gsSystem)
            , ("M-g 8",                   addName "Menu of utilities apps"                 $ spawnSelected' gsUtilities)]

            ^++^ subKeys "Pass"
            [ ("M-p",                     addName "retrieve a password"                    $ passPrompt def )
            , ("M-C-p",                   addName "Generate a Password"                    $ passGeneratePrompt def)
            , ("M-S-p",                   addName "A prompt to edit a given entry"         $ passEditPrompt def)
            , ("M-C-S-p",                 addName "A prompt to remove a password"          $ passRemovePrompt def) ]

            -- Emacs (SUPER-e followed by a key)
            ^++^ subKeys "Emacs"
            [ ("M-e e",                   addName "Emacsclient Dashboard"                  $ spawn myEmacs)
            , ("M-e t",                   addName "Open Emacs in a terminal"               $ spawn (myTerminal ++ " -e emacsclient -nw"))
            , ("M-e d",                   addName "Emacsclient Dired"                      $ spawn (myEmacs ++ ("--eval '(dired nil)'")))
            , ("M-e s",                   addName "Emacsclient Eshell"                     $ spawn (myEmacs ++ ("--eval '(eshell)'")))
            , ("M-e p",                   addName "Emacsclient Pass"                       $ spawn (myEmacs ++ ("--eval '(pass)'")))
            , ("M-e w",                   addName "Emacs Everywhere"                       $ spawn "emacsclient --eval '(emacs-everywhere)'")
            ]


            -- Multimedia Keys
            ^++^ subKeys "Multimedia keys"
            [ ("<XF86AudioPlay>",         addName "mpd play"                               $ spawn "mpc --port 6666 toggle")
            , ("<XF86AudioPrev>",         addName "mpd prev"                               $ spawn "mpc --port 6666 prev")
            , ("<XF86AudioNext>",         addName "mpd next"                               $ spawn "mpc --port 6666 next")
            , ("<XF86AudioMute>",         addName "Toggle audio mute"                      $ spawn "amixer set Master toggle")
            , ("<XF86AudioLowerVolume>",  addName "Lower vol"                              $ spawn "amixer set Master 2%-")
            , ("<XF86AudioRaiseVolume>",  addName "Raise vol"                              $ spawn "amixer set Master 2%+")
            , ("<XF86MonBrightnessUp>",   addName "Inc bright"                             $ spawn "xbacklight -inc 2")
            , ("<XF86MonBrightnessDown>", addName "Dec bright"                             $ spawn "xbacklight -dec 2")
            , ("<Print>", addName "Take screenshot (dmscripts)"                            $ spawn "dm-maim")
            ]
            -- The following lines are needed for named scratchpads.
              where nonNSP          = WSIs (return (\ws -> W.tag ws /= "NSP"))
                    nonEmptyNonNSP  = WSIs (return (\ws -> isJust (W.stack ws) && W.tag ws /= "NSP"))

          main :: IO ()
          main = do
            -- Launching three instances of xmobar on their monitors.
            -- xmproc0 <- spawnPipe ("xmobar -x 0 /home/jy/.config/xmobar/gruvbox-dark-xmobarrc")
            xmproc0 <- spawnPipe ("xmobar -x 0 /home/jy/.config/xmobar/gruvbox-dark-xmobarrc")
            xmproc1 <- spawnPipe ("xmobar -x 2 /home/jy/.config/xmobar/gruvbox-dark-xmobarrc")
            xmproc2 <- spawnPipe ("xmobar -x 1 /home/jy/.config/xmobar/gruvbox-dark-xmobarrc")

            -- the xmonad, ya know...what the WM is named after!
            xmonad $ addDescrKeys' ((mod4Mask, xK_F1), showKeybindings) myKeys $ ewmh $ docks $ def
              { manageHook         = myManageHook <+> manageDocks
              , handleEventHook    = windowedFullscreenFixEventHook <> swallowEventHook (className =? "Alacritty"  <||> className =? "st-256color" <||> className =? "XTerm") (return True)
              , modMask            = myModMask
              , terminal           = myTerminal
              , startupHook        = myStartupHook
              , layoutHook         = showWName' myShowWNameTheme $ myLayoutHook
              , workspaces         = myWorkspaces
              , borderWidth        = myBorderWidth
              , normalBorderColor  = myNormColor
              , focusedBorderColor = myFocusColor
              , logHook = dynamicLogWithPP $  filterOutWsPP [scratchpadWorkspaceTag] $ xmobarPP
                  { ppOutput = \x -> hPutStrLn xmproc0 x   -- xmobar on monitor 1
                                  >> hPutStrLn xmproc1 x   -- xmobar on monitor 2
                                  >> hPutStrLn xmproc2 x   -- xmobar on monitor 3
                  , ppCurrent = xmobarColor color13 "" . wrap
                                ("<box type=Bottom width=2 mb=2 color=" ++ color13 ++ ">") "</box>"
                    -- Visible but not current workspace
                  , ppVisible = xmobarColor color15 "" . clickable
                    -- Hidden workspace
                  , ppHidden = xmobarColor color10 "" . wrap
                               ("<box type=Top width=2 mt=2 color=" ++ color10 ++ ">") "</box>" . clickable
                    -- Hidden workspaces (no windows)
                  , ppHiddenNoWindows = xmobarColor color15 ""  . clickable
                    -- Title of active window
                  , ppTitle = xmobarColor color03 "" . shorten 80
                    -- Separator character
                  , ppSep =  "<fc=" ++ color09 ++ "> <fn=1>|</fn> </fc>"
                    -- Urgent workspace
                  , ppUrgent = xmobarColor color02 "" . wrap "!" "!"
                    -- Adding # of windows on current workspace to the bar
                  , ppExtras  = [windowCount]
                    -- order of things in xmobar
                  , ppOrder  = \(ws:l:t:ex) -> [ws,l]++ex++[t]
                  }
              }
        '';
      };
    };
  };
}
