import Data.Map (Map, fromList, union)
import System.IO

import XMonad
import XMonad.Actions.Navigation2D
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.UrgencyHook
import XMonad.Layout.LayoutModifier
import XMonad.Layout.NoBorders
import XMonad.Util.Run

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

barToString :: Bar -> String
barToString bar =  " -fn " ++ barFont bar
                ++ " -fg " ++ barFg bar
                ++ " -bg " ++ barBg bar
                ++ " -h "  ++ show (barHeight bar)
                ++ " -w "  ++ show (barWidth bar)
                ++ " -x "  ++ show (barX bar)
                ++ " -y "  ++ show (barY bar)
                ++ " -ta " ++ barAlign bar

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

myTerminal :: String
myTerminal = "xterm"

myModKey :: KeyMask
myModKey = mod4Mask

myBorderWidth :: Dimension
myBorderWidth = 1

myManageHook :: ManageHook
myManageHook = composeAll
   [ className =? "Skype"   --> doShift "3"
   , className =? "Firefox" --> doShift "1"
   , className =? "Wine"    --> doShift "4"
   , className =? "Steam"   --> doShift "4"

   , className =? "Wine"    --> doFloat
   , className =? "feh"     --> doFloat
   , className =? "Steam"   --> doFloat
   ]

winBorderFocused, winBorderNormal :: String
winBorderFocused = "#ffffff"
winBorderNormal = "#333333"

myLayoutHook :: ModifiedLayout AvoidStruts (ModifiedLayout SmartBorder (Choose Tall (Choose (Mirror Tall) Full))) Window
myLayoutHook = avoidStruts $ smartBorders $ tiled ||| Mirror tiled ||| Full
      where tiled = Tall 1 0.03 0.5

myLogHook :: Handle -> X()
myLogHook d = dynamicLogWithPP $ defaultPP
      { ppOutput = hPutStrLn d
      , ppCurrent = dzenColor "#000000" "#cccccc"
      , ppOrder = \(w:_:t:_) -> [w,t]
      }

--{{{ Keymaps
myKeyMaps :: Map (KeyMask, KeySym) (X ())
myKeyMaps = fromList
   [ ((myModKey, xK_r), spawn "dmenu_run")
   , ((myModKey, xK_f), safeSpawnProg myTerminal)
   , ((myModKey, xK_e), safeSpawnProg "firefox")

   , ((myModKey, xK_h), windowGo L False)
   , ((myModKey, xK_l), windowGo R False)
   , ((myModKey, xK_j), windowGo D False)
   , ((myModKey, xK_k), windowGo U False)

   , ((myModKey .|. shiftMask, xK_l), spawn "slimlock")

   , ((myModKey, xK_q), kill)
   , ((myModKey, xK_p), spawn "if type xmonad; then xmonad --recompile && xmonad --restart; else xmessage xmonad not in \\$PATH: \"$PATH\"; fi")
   , ((myModKey, xK_equal), sendMessage Expand)
   , ((myModKey, xK_minus), sendMessage Shrink)
   ]
--}}}

main :: IO()
main = do
   spawn "panel_trayer"
   d <- spawnPipe $ "dzen2 -p" ++ barToString dzenLogHook
   spawn conkyCmd
   xmonad $ withUrgencyHook NoUrgencyHook $ defaultConfig
      { terminal           = myTerminal
      , focusFollowsMouse  = False
      , focusedBorderColor = winBorderFocused
      , normalBorderColor  = winBorderNormal
      , modMask            = myModKey
      , keys               = union myKeyMaps . keys defaultConfig
      , borderWidth        = myBorderWidth
      , manageHook         = manageDocks <+> myManageHook
      , layoutHook         = myLayoutHook
      , logHook            = myLogHook d
      }
   where conkyCmd = "conky -c ~/scripts/panel_conky | dzen2 -p" ++ barToString dzenConky

dzenConky :: Bar
dzenConky = dzenConfig
   { barWidth  = 616
   , barX      = 600
   , barAlign  = "r"
   }

dzenLogHook :: Bar
dzenLogHook = dzenConfig
   { barWidth  = 616
   , barX      = 0
   , barAlign  = "l"
   }
