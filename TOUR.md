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

## Getting to Documentation

After setting up your site, open the Document Examiner using <Select>[F1]-D. You should see a list of documents on the right under the heading Current Candidates. Left Click on [Genera User's Guide] and move your mouse over the lower part of the leftmost scroll bar, at which point a horizontal line should appear across the document. In this context Left Clicking will scroll down and Right Clicking will scroll up. This is briefly documented in the status bar at the bottom of the screen, which also tells you how Left and Right Click decide how much to scroll, and that Middle Clicking jumps to the percentage of the scroll bar you are hovering over.

If you are looking for help on a specific topic, Left Click [Show Candidates] and type a topic. Results that match the topic will replace the Current Candidates list. To return to the original list, Left Click [Reselect Candidates] and then Left Click "Table of contents for the document set". For a snazzy display, Middle Click on a candidate to see a graph of its topics, and continue Middle Clicking on branches.

## Multitasking

When following a guide, it's useful to have both the documentation and a listener on the screen. Shift-Right Click anywhere, then Left click [Split Screen], [Existing Window], then [Standard Document Examiner 1]. A preview box will appear with the caption "Standard Document Examiner 1". Again click [Existing Window], then [Dynamic Lisp Listener 1]. Finally click [Do It] to apply the changes.

This creates a 50/50 split of documentation and listener, which makes the documentation pretty small. Shift-Right click the listener window and Left click [Shape]. Move the mouse around a little to see that the upper left corner is pinned while the mouse moves the lower right corner. Now hold shift and see the top left corner moving with the mouse, which lets us place it lower on the screen. Once the top left corner is low enough (ignoring horizontal position) release shift and click (ignoring the placement of the lower right corner) to set the new window size. Now Shift-Right click the documentation window and Left click [Expand] to expand the top window until it touches the lower window. Finally Shift-Right click the lower window and click [Expand] to expand it horizontally and vertically until it fills all the space not occupied by the upper window.

## Notes

Internet hosts are specified as strings of the format "INTERNET|8.8.8.8" (capitalization is irrelevant).
