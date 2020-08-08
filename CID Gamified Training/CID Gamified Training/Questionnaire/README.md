# arl-gamified-training

X-Force Summer 2020

## Questionnaire

### `Focus.swift`

Page for the focus selector on the main screen. Allows for switch between gain, loss, and neutral frames. Affects the game elements of training and go/no-go. This is included as part of a development tool, and the ability to switch focus is not meant to be in an actual release to keep training optimal.

### `Question.swift`

Contains the questionnaire page. Users can take the 11-question questionnaire, and a prevention and promotion score will be generated. From there, a confidence interval will be calculated and the frame type that is predicted to be most beneficial for the user will be selected and used.

### `Rejection.swift`

Contains the rejection page that will be presented if a user attempts to begin a training or go/no-go session without first taking the questionnaire.
