## Interface

You will need a three button mouse. This can be emulated on a Mac laptop by using BetterTouchTool to add a gesture making "Three Finger [Tap or Click]" activate "Middle Click".

Genera is infamous for having a keyboard with a lot of modifier keys. Fortunately Open Genera treats the left and right modifiers differently to provide most of them on a modern keyboard. In addition, the Alpha-on-x86 emulation layer (snap4) provides some remappings. The end result is something like this:

    <Control>  [Control]
    <Shift>    [Shift]
    <Meta>     [Left Alt]
    <Super>    [Right Alt]
    <Symbol>   [Right Super]
    <Hyper>    [No Binding]

    <Select>   [F1]
    <Function> [F3]
    <Suspend>  [F4]
    <Resume>   [F5]
    <Abort>    [F6]
    <Square>   [F7]
    <Help>     [F12]
    
    <Rubout>   [Delete] (not the key next to Equals)

You are also separated from Open Genera by a VNC session. Inside this session there are three windows managed by ratpoison (a keyboard oriented window manager).

    C-t 0 shows an xterm
    C-t 1 shows the xterm running snap4 / genera
    C-t 2 shows the Open Genera cold boot console
    C-t 3 shows the Open Genera main screen [default]

    C-t ? shows the ratpoison help screen

### Mac Tips

You can connect to the VNC session via the Finder by pressing Command-K and connecting to "vnc://localhost:5902". While this is convenient, you will be better served by RealVNC, which has a super-expert-advanced setting that will allow you to map Left Option to Alt_L (Meta) and Right Option to Alt_R (Super). YOU WANT THESE.

On a laptop the fn key turns Backspace into Delete (IMPORTANT), Left Arrow into Home, Right Arrow into End, Up Arrow into Page Up, and Down Arrow into Page Down.

## Switching Applications in Genera

Type &lt;Select> ([F1]) followed by:

    [=] SELECT Key Selector
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
