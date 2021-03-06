import Data.Map (Map, fromList)
import System.IO

import XMonad
import XMonad.Actions.Navigation2D
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.SetWMName
import XMonad.Hooks.UrgencyHook
import XMonad.Layout.Fullscreen
import XMonad.Layout.Grid
import XMonad.Layout.LayoutModifier
import XMonad.Layout.NoBorders
import XMonad.StackSet hiding (workspaces)
import XMonad.Util.Run

-- {{{ Bar stuff
-- Data structure to make handling dzen config easier
data Bar = Bar
  { barFont   :: String
  , barFg     :: String
  , barBg     :: String
  , barHeight :: Int
  , barWidth  :: Int
  , barX      :: Int
  , barY      :: Int
  , barAlign  :: String
  }

-- Outputs a string with the format of the Bar
barToString :: Bar -> String
barToString bar =  " -fn " ++ barFont bar
                ++ " -fg " ++ barFg bar
                ++ " -bg " ++ barBg bar
                ++ " -h "  ++ show (barHeight bar)
                ++ " -w "  ++ show (barWidth bar)
                ++ " -x "  ++ show (barX bar)
                ++ " -y "  ++ show (barY bar)
                ++ " -ta " ++ barAlign bar

-- Default dzen config
dzenConfig :: Bar
dzenConfig = Bar
  { barFont   = "'-*-fixed-*-*-*-*-14-*-*-*-*-*-*-*'"
  , barFg     = "'#c5c8c6'"
  , barBg     = "'#232c31'"
  , barHeight = 18
  , barWidth  = 1216
  , barX      = 0
  , barY      = 0
  , barAlign  = "c"
  }

-- Custom config for the Conky bar
dzenConky :: Bar
dzenConky = dzenConfig
  { barWidth  = 550
  , barX      = 748
  , barAlign  = "r"
  }

-- Custom config for the main bar
dzenLogHook :: Bar
dzenLogHook = dzenConfig
  { barWidth  = 748
  , barX      = 0
  , barAlign  = "l"
  }
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

myLogHook :: Handle -> X()
myLogHook d = dynamicLogWithPP $ defaultPP
    { ppOutput = hPutStrLn d
    , ppCurrent = dzenColor "#000000" "#cccccc"
    , ppOrder = \(w:_:t:_) -> [w,t]
    }

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
  , ((0, 0x1008ff12), spawn "amixer set Master toggle")
  , ((0, 0x1008ff11), spawn "amixer set Master 5%-")
  , ((0, 0x1008ff13), spawn "amixer set Master 5%+")

  -- Manual brightness controls (Yes, I know it looks like crap)
  , ((0, 0x1008ff02), spawn "sudo awk '{print $0 + 500}' /sys/class/backlight/intel_backlight/brightness | sudo tee /sys/class/backlight/intel_backlight/brightness")
  , ((0, 0x1008ff03), spawn "sudo awk '{print $0 - 500}' /sys/class/backlight/intel_backlight/brightness | sudo tee /sys/class/backlight/intel_backlight/brightness")

  -- Touchpad toggle. Also moves cursor out of the way
  , ((0, 0x1008ffa9), spawn "xdotool mousemove 2000 0; synclient TouchpadOff=$(synclient -l | grep -c 'TouchpadOff.*=.*0')")
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
  [((myModKey .|. shiftMask, xK_p), spawn "if type xmonad; then xmonad --recompile && xmonad --restart; else xmessage xmonad not in \\$PATH: \"$PATH\"; fi")]
    -- US layout
    where symList = [xK_1, xK_2, xK_3, xK_4, xK_5, xK_6, xK_7, xK_8, xK_9, xK_0]
    -- US layout numberswap
    -- where symList = [ xK_exclam , xK_at , xK_numbersign , xK_dollar , xK_percent , xK_asciicircum , xK_ampersand , xK_asterisk , xK_parenleft , xK_parenright ]
    -- Dvorak layout
    -- where symList = [ xK_ampersand , xK_bracketleft , xK_braceleft , xK_braceright , xK_parenleft , xK_equal , xK_asterisk , xK_parenright , xK_plus , xK_braceright ]
--}}}

main :: IO()
main = do
  spawn "panel_trayer"
  d <- spawnPipe $ "dzen2 -e 'button2=;' -p" ++ barToString dzenLogHook
  spawn conkyCmd
  xmonad $ withUrgencyHook NoUrgencyHook $ defaultConfig
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
      , logHook            = myLogHook d
      , handleEventHook    = docksEventHook
      , startupHook        = myStartupHook
      }
  where conkyCmd = "conky -c ~/scripts/panel_conky | dzen2 -e 'button2=;' -p" ++ barToString dzenConky

