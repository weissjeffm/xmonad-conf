-- default desktop configuration for Fedora

import System.Posix.Env (getEnv)
import Data.Maybe (maybe)

import XMonad
import XMonad.Config.Desktop
import XMonad.Config.Gnome


import XMonad.Util.EZConfig
import Graphics.X11.ExtraTypes.XF86
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Util.SpawnOnce
import XMonad.Layout.Spiral
import XMonad.Util.Run(spawnPipe)
import System.IO
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.SetWMName
-- import XMonad.Layout.Rename
import XMonad.Layout.NoBorders

myLayoutHook =  Full ||| Mirror (spiral (6/7)) ||| mytall ||| Mirror (mytall)
 where
   mytall = Tall nmaster delta ratio
   nmaster = 1
   ratio = 1/2
   delta = 2/100

main = do
     xmproc <- spawnPipe "/usr/bin/xmobar /home/jweiss/.xmonad/.xmobarrc"
     xmonad (gnomeConfig
             { modMask = mod4Mask
              ,terminal = "gnome-terminal --hide-menubar"
              ,layoutHook = smartBorders (avoidStruts myLayoutHook)
              ,startupHook = mystartuphook <+> startupHook gnomeConfig
              ,manageHook = manageDocks <+> manageHook defaultConfig
              ,handleEventHook = fullscreenEventHook
              ,focusedBorderColor = "#99FF99"
              ,normalBorderColor = "#292929"
              ,logHook = dynamicLogWithPP xmobarPP
                         { ppOutput = hPutStrLn xmproc
                          ,ppTitle = xmobarColor "white" "" . shorten 50
                         }
             }
             `additionalKeys`
             [
               ((mod4Mask, xK_u), spawn "dmenu_run")
              ,((mod4Mask .|. shiftMask, xK_z), spawn "xscreensaver-command -lock; sleep 1; xset dpms force off")
              ,((mod4Mask .|. shiftMask, xK_f), spawn "nautilus")
              ,((mod4Mask .|. shiftMask, xK_s), spawn "gnome-screenshot -i")
              ,((mod4Mask .|. shiftMask, xK_i), spawn "/home/jweiss/dock-in.sh")
              ,((mod4Mask, xF86XK_MonBrightnessDown), spawn "xbacklight -10")
              ,((mod4Mask, xF86XK_MonBrightnessUp), spawn "xbacklight +10")
              ,((mod4Mask .|. shiftMask, xK_o), spawn "/home/jweiss/dock-out.sh")
              ,((mod4Mask .|. shiftMask, xK_m), spawn "/home/jweiss/bin/mailrun.sh")

             ] )

mystartuphook = setWMName "LG3D" <+>
                spawnOnce "xsetroot -gray" <+>
                spawnOnce "stalonetray -i 17 -s 17" <+>
                spawnOnce "xscreensaver" <+>
                spawnOnce "setxkbmap -option ctrl:nocaps" <+> -- capslock -> ctrl
                spawnOnce "xset r rate 180 45" -- keyboard repeat rate
