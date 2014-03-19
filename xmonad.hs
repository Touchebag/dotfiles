import Data.Map (Map, fromList, union)

import XMonad
import XMonad.Actions.Navigation2D
import XMonad.Hooks.ManageDocks
import XMonad.Layout.NoBorders
import XMonad.Util.Run

main :: IO()
main = do
   spawn "panel"
   xmonad $ defaultConfig
      { terminal           = myTerminal
      , focusFollowsMouse  = False
      , focusedBorderColor = winBorderFocused
      , normalBorderColor  = winBorderNormal
      , modMask            = myModKey
      , keys               = union myKeyMaps . keys defaultConfig
      , borderWidth        = myBorderWidth
      , manageHook         = myManageHook <+> manageDocks
      , layoutHook         = myLayoutHook
   }

myTerminal :: String
myTerminal = "xterm"

myModKey :: KeyMask
myModKey = mod4Mask

myBorderWidth :: Dimension
myBorderWidth = 1

myManageHook :: ManageHook
myManageHook = composeAll
   [ className =? "Skype"           --> doShift "3"
   , className =? "Firefox"         --> doShift "1"

   , className =? "Wine"            --> doFloat
   ]

winBorderFocused, winBorderNormal :: String
winBorderFocused = "#ffffff"
winBorderNormal = "#333333"

myLayoutHook = avoidStruts $ smartBorders $ tiled ||| Mirror tiled ||| Full
      where tiled = Tall 1 0.03 0.5

--{{{ Keymaps
myKeyMaps :: Map (KeyMask, KeySym) (X ())
myKeyMaps = fromList $
   [ ((myModKey, xK_r), spawn "dmenu_run")
   , ((myModKey, xK_f), safeSpawnProg myTerminal)
   , ((myModKey, xK_e), safeSpawnProg "firefox")
   
   , ((myModKey, xK_h), windowGo L False)
   , ((myModKey, xK_l), windowGo R False)
   , ((myModKey, xK_j), windowGo D False)
   , ((myModKey, xK_k), windowGo U False)
   
   , ((myModKey, xK_q), kill)
   , ((myModKey, xK_p), spawn "if type xmonad; then xmonad --recompile && xmonad --restart; else xmessage xmonad not in \\$PATH: \"$PATH\"; fi")
   , ((myModKey, xK_equal), sendMessage Expand)
   , ((myModKey, xK_minus), sendMessage Shrink)
   ]
--}}}
