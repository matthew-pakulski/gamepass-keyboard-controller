# gamepass-keyboard-controller
Use your keyboard to play games on GamePass on the browser without a controller.

This program allows you to map keys on your keyboard to buttons on the on-screen controller for Xbox GamePass games running in the browser.

# Prerequisites

## Usage
This program works on Windows Only.

## Development
This program uses AutoIt v3 beta.
Compiling requires using the beta version of AutoIt to enable the `map` datastructure language feature.

# Instructions
1. Go to xbox.com/play. Sign in, and choose a game to play that has touch controls enabled, eg Octopath Traveler™.

2. Enable the touch controls by using the browser as a touch screen device. In Chrome or Edge, open the Device Toolbar with Ctrl+Shift+M. Choose a resolution that works best for you (switching to landscape is usually necessary). You should now have on-screen buttons that are clickable with your mouse or touch screen to play the game.

3. In your game, change the settings to use the basic controller. Otherwise, some games will change where the buttons are depending on what you're doing. Return to your game.

4. Open the program. The first time opening, you'll be required to configure the button locations on screen. This step only needs to be completed once, however you may rerun the setup if you need to adjust the button locations (x,y coordinates on screen). You'll be prompted to move your mouse to each button location on screen, then press Enter on your keyboard to close the prompt and store the button coordinate location. Only the D-Pad is currently supported, not the Left or Right thumbsticks.

5. Begin playing!

# Default button mapping

These are not currently configurable. There's currently no support

| Xbox button | Keyboard key |
| - | - |
| Left | s |
| Right | f |
| Up | e |
| Down | d |
| a | k |
| x | j |
| b | l |
| y | i |
| start | h |
| select | g |
| Left Trigger | w |
| Left Bumper | r |
| Right Trigger | o |
| Right Bumper | u |
| Left Thumb Stick | not supported |
| Right Thumb Stick | not supported |


# Limitations
Since this is using an on-screen keyboard by using your mouse, and there is only one mouse - that means, you can only use one button at a time. This will make certain games impossible to play.

The Thumbsticks are not currently supported.

# Notes
While the program is running, it captures the keyboard button presses.

You can pause the program by pressing the `Pause Break` keyboard button, or `Esc` to terminate.
