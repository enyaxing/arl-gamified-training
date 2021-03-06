# arl-gamified-training

X-Force Summer 2020

## Styles

## AdaptsToKeyboard.swift

A view modifier that allows elements to be pushed up in the screen if a text input box is selected and the keyboard shows on screen. Currently used for the login page where the login button will move up.

### Fields

- `currentHeight: CGFloat` - set to 0 initially, keeps track of the current height value and adjusts according to keyboard position

### `ButtonStyle.swift`

Stores several button modifiers used. `FriendlyButtonStyle` is used for the friendly button in game sessions, and `EnemyButtonStyle` is used for the enemy button. `CustomDefaultButtonStyle` is in the same style as the other two, but is intended for other colored custom buttons.

### `Style.swift`

Created to store other custom style elements for the app theme. Stores custom colors, fonts, and other button view modifiers.
