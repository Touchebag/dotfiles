import XMonad
import XMonad.Hooks.ManageDocks
import XMonad.Layout.NoBorders

main :: IO()
main = do
   spawn "panel"
   xmonad $ defaultConfig
      { terminal    = myTerminal
      , modMask     = myModMask
      , borderWidth = myBorderWidth
      , manageHook  = myManageHook
      , layoutHook  = myLayoutHook
   }

myTerminal :: String
myTerminal = "xterm"

myModMask :: KeyMask
myModMask = mod4Mask

myBorderWidth :: Dimension
myBorderWidth = 1

myManageHook :: ManageHook
myManageHook = manageDocks

myLayoutHook = avoidStruts $ smartBorders $ tiled ||| Mirror tiled ||| Full
      where tiled = Tall 1 0.03 0.5
