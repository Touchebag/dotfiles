import Data.Map (Map, fromList)
import System.IO

import XMonad
import XMonad.Actions.Navigation2D
import XMonad.Actions.Volume
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.StatusBar
import XMonad.Hooks.StatusBar.PP
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.SetWMName
import XMonad.Hooks.UrgencyHook
import XMonad.Layout.Fullscreen
import XMonad.Layout.Grid
import XMonad.Layout.LayoutModifier
import XMonad.Layout.NoBorders
import XMonad.StackSet hiding (workspaces)
import XMonad.Util.Run
import XMonad.Util.Loggers

-- {{{ Bar stuff
myXmobarPP :: PP
myXmobarPP = def
    { ppSep             = magenta " • "
    , ppTitleSanitize   = xmobarStrip
    , ppCurrent         = wrap (cyan "[") (cyan "]")
    , ppHidden          = grey
    , ppUrgent          = red . wrap (yellow "!") (yellow "!")
    , ppOrder           = \[ws, _, window, _] -> [ws, window]
    , ppExtras          = [logTitles formatFocused formatUnfocused]
    }
  where
    formatFocused   = wrap (white    "[") (white    "]") . magenta . ppWindow
    formatUnfocused = wrap (grey "[") (grey "]") . blue . ppWindow

    -- Windows should have *some* title, which should not not exceed a sane length.
    ppWindow :: String -> String
    ppWindow = xmobarRaw . (\w -> if null w then "untitled" else w) . shorten 30

    blue, grey, magenta, red, white, yellow :: String -> String
    magenta  = xmobarColor "#ff00ff" ""
    blue     = xmobarColor "#0000ff" ""
    cyan     = xmobarColor "#00ffff" ""
    white    = xmobarColor "#ffffff" ""
    yellow   = xmobarColor "#ffff00" ""
    red      = xmobarColor "#ff0000" ""
    grey     = xmobarColor "#999999" ""
-- }}}

--{{{ Xmonad stuff
myTerminal :: String
myTerminal = "urxvt"

myModKey :: KeyMask
myModKey = mod4Mask

myBorderWidth :: Dimension
myBorderWidth = 1

myManageHook :: ManageHook
myManageHook = composeAll
  [ className =? "Skype"       --> doShift "3"
  , className =? "Firefox"     --> doShift "1"
  , className =? "Wine"        --> doShift "4"
  , className =? "Steam"       --> doShift "4"
  , className =? "Gimp"        --> doShift "4"
  , className =? "Krita"       --> doShift "4"
  , className =? "Battle.net"  --> doShift "4"
  , className =? "Hearthstone" --> doShift "4"

  , className =? "Wine"        --> doFloat
  , className =? "feh"         --> doFloat
  , className =? "Hearthstone" --> doFloat
  ]

-- Border colour of windows
winBorderFocused, winBorderNormal :: String
winBorderFocused = "#00ff00"
winBorderNormal = "#333333"

myLayoutHook :: ModifiedLayout AvoidStruts (ModifiedLayout SmartBorder (Choose Grid Full)) Window
myLayoutHook = avoidStruts $ smartBorders $ GridRatio (4/3) ||| Full

myStartupHook :: X()
myStartupHook = setWMName "LG3Dj"

myWorkspaces :: [WorkspaceId]
myWorkspaces = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"]
-- }}}

--{{{ Keymaps
myKeyMaps :: XConfig Layout -> Map (KeyMask, KeySym) (X ())
myKeyMaps conf = fromList $
  -- Program shortcuts
  [ ((myModKey, xK_r), spawn "dmenu_run")
  , ((myModKey, xK_f), safeSpawnProg myTerminal)

  -- Movement keys
  , ((myModKey, xK_h), windowGo L False)
  , ((myModKey, xK_l), windowGo R False)
  , ((myModKey, xK_j), windowGo D False)
  , ((myModKey, xK_k), windowGo U False)

  -- Screen lock
  , ((myModKey .|. shiftMask, xK_l), spawn "slimlock")

  -- Misc keys
  , ((myModKey, xK_q), kill) --Close current window
  , ((myModKey, xK_t), withFocused $ windows . XMonad.StackSet.sink) --Push window back into tiling
  , ((myModKey, xK_equal), sendMessage Expand) --Selfexplanatory
  , ((myModKey, xK_minus), sendMessage Shrink) --See above

  , ((myModKey, xK_Return), windows swapMaster) --Swaps current and master windows
  , ((myModKey .|. shiftMask, xK_j), windows swapUp) --Shifts window up in tiling
  , ((myModKey .|. shiftMask, xK_k), windows swapDown) --Shifts window down in tiling
  , ((myModKey, xK_space), sendMessage NextLayout) --Rotate through avaliable layouts
  , ((myModKey .|. shiftMask, xK_space), setLayout $ XMonad.layoutHook conf) --Resets the layout to deafult

  -- Audio controls
  , ((0, XF8AudioMute        , mutevolume 3)
  , ((0, XF8AudioLowerVolumelowervolume , lowervolume 3)
  , ((0, XF8AudioRaiseVolume , raisevolume 3)

  -- Manual brightness controls (Yes, I know it looks like crap)
  , ((0, 0x1008ff02), spawn "sudo awk '{print $0 + 500}' /sys/class/backlight/intel_backlight/brightness | sudo tee /sys/class/backlight/intel_backlight/brightness")
  , ((0, 0x1008ff03), spawn "sudo awk '{print $0 - 500}' /sys/class/backlight/intel_backlight/brightness | sudo tee /sys/class/backlight/intel_backlight/brightness")

  -- Touchpad toggle. Also moves cursor out of the way
  , ((0, XF86XK_TouchpadToggle), spawn "~/toggle_touchpad.sh")
  ]

  ++
  -- Keys for switching workspaces
  [((myModKey, k), windows (XMonad.StackSet.greedyView i))
    | (i, k) <- zip (XMonad.workspaces conf) symList
  ]

  ++
  -- Keys for shifting windows. Current workspace follows shifted window
  [((myModKey .|. shiftMask, k), windows (XMonad.StackSet.shift i) >> windows (XMonad.StackSet.greedyView i))
    | (i, k) <- zip (XMonad.workspaces conf) symList
  ]

  ++
  -- Keys for switching monitors
  [((myModKey, k), screenWorkspace sc >>= flip whenJust (windows . f))
    | (k, sc) <- zip [xK_i, xK_o, xK_p] [0..]
    , (f, m) <- [(view, 0)]
  ]

  ++
  -- Recompile Xmonad
  [((myModKey .|. shiftMask, xK_p), spawn "if type xmonad; then pkill xmobar || xmonad --recompile && xmonad --restart; else xmessage xmonad not in \\$PATH: \"$PATH\"; fi")]
    where symList = [xK_1, xK_2, xK_3, xK_4, xK_5, xK_6, xK_7, xK_8, xK_9, xK_0]
--}}}

myConfig = def
  { terminal           = myTerminal
  , focusFollowsMouse  = False
  , focusedBorderColor = winBorderFocused
  , normalBorderColor  = winBorderNormal
  , modMask            = myModKey
  , keys               = myKeyMaps
  , borderWidth        = myBorderWidth
  , workspaces         = myWorkspaces
  , manageHook         = fullscreenManageHook <+> manageDocks <+> myManageHook
  , layoutHook         = lessBorders OnlyScreenFloat myLayoutHook
  , startupHook        = myStartupHook
  }

main :: IO()
-- main = do
main = xmonad
        . withEasySB (statusBarProp "xmobar" (pure myXmobarPP)) defToggleStrutsKey
        $ myConfig
