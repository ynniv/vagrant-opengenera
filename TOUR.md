## Interface

You will need a three button mouse. This can be emulated on a Mac laptop by using BetterTouchTool to add a gesture making "Three Finger [Tap or Click]" activate "Middle Click".

Genera is infamous for having a keyboard with a lot of modifier keys. Fortunately Open Genera treats the left and right modifiers differently to provide most of them on a modern keyboard.

    <Control> [Either Control]
    <Shift>   [Either Shift]
    <Meta>    [Left Option / Alt]
    <Super>   [Left Super]
    <Hyper>   [Right Option / Alt]
    <Symbol>  [Right Super]

You are separated from Open Genera by an x86 emulation layer called snap4. Some remapping is done at this layer:

    <Select>   is [F1]
    <Function> is [F3]
    <Suspend>  is [F4]
    <Resume>   is [F5]
    <Abort>    is [F6]
    <Square>   is [F7]
    <Help>     is [F12]
    
    <Rubout>   is [Delete] (not Backspace)
    <Abort>    is [Keypad Minus]
    <Super>    is [Right Control]

You are also separated from Open Genera by a VNC session. Inside this session there are three windows managed by ratpoison (a keyboard oriented window manager).

    C-t 0 shows an xterm
    C-t 1 shows the xterm running snap4 / genera
    C-t 2 shows the Open Genera cold boot console
    C-t 3 shows the Open Genera main screen [default]

    C-t ? shows the ratpoison help screen

The VNC server also addionally remaps some keys for convenience:
    
    

On Mac OSX you can connect to the VNC session via the Finder by pressing Command-K and connecting to "vnc://localhost:5902". While this is convenient, you will be better served by RealVNC, which has a super-expert-advanced setting that will cause Left Command to send Super_L and Right Command to send Super_R. YOU WANT THIS. You can also use FunctionFlip to 

## Switching Applications in Genera

Type &lt;Select> ([F1]) followed by:

    [=] SELECT Key Selector
    [%] Metering Interface
    [C]onverse
    [D]ocument Examiner
    [E]ditor (Zmacs)
    [I]nspector
    [L]isp
    Z[m]ail
    [N]otifications
    [P]eek
    [Q] Frame-Up
    [T]erminal
    Flavor E[x]aminer
    [?] Select Key Help
