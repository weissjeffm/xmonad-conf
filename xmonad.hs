-- default desktop configuration for Fedora

import System.Posix.Env (getEnv)
import Data.Maybe (maybe)

import XMonad
import XMonad.Config.Desktop
import XMonad.Config.Gnome
import XMonad.Config.Kde
import XMonad.Config.Xfce
import XMonad.Util.EZConfig
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Layout.Spiral
import XMonad.Util.Run(spawnPipe)
import System.IO
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.SetWMName

myLayoutHook =  Full ||| Mirror (spiral (6/7)) ||| mytall
 where
   mytall = Tall nmaster delta ratio
   nmaster = 1
   ratio = 1/2
   delta = 1/100

main = do
     session <- getEnv "DESKTOP_SESSION"
     xmproc <- spawnPipe "/usr/bin/xmobar /home/jweiss/.xmonad/.xmobarrc"
     xmonad $ (maybe desktopConfig desktop session)
             { modMask = mod4Mask
              ,terminal = "gnome-terminal --hide-menubar" 
              ,layoutHook = avoidStruts myLayoutHook
              ,startupHook = setWMName "LG3D"
              ,manageHook = manageDocks <+> manageHook defaultConfig
              ,handleEventHook = fullscreenEventHook
              ,focusedBorderColor = "#00FF00"
              ,logHook = dynamicLogWithPP xmobarPP
                         { ppOutput = hPutStrLn xmproc
                          ,ppTitle = xmobarColor "white" "" . shorten 50
                         }
             }    
             `additionalKeys`
             [ ((mod4Mask, xK_u), spawn "dmenu_run")
             ] 


desktop "gnome" = gnomeConfig
desktop "kde" = kde4Config
desktop "xfce" = xfceConfig
desktop _ = desktopConfig
