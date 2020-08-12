# arl-gamified-training

X-Force Summer 2020

# Questionnaire

## Focus.swift

Page for the focus selector on the main screen. Allows for switch between gain, loss, and neutral frames. Affects the game elements of training and go/no-go. This is included as part of a development tool, and the ability to switch focus is not meant to be in an actual release to keep training optimal.

### Fields

- `selection: String` - Which option is currently selected from the picker.
- `user: GlobalUser` - Reference to global user variable
- `db: CollectionReference` - Reference to Firebase users collection
- `defaults` - Save defaults locally (i.e. who is signed in)

## Question.swift

Contains the questionnaire page. Users can take the 11-question questionnaire, and a prevention and promotion score will be generated. From there, a confidence interval will be calculated and the frame type that is predicted to be most beneficial for the user will be selected and used.

### Fields

- `db: CollectionReference` - Reference to Firebase users collection
- `user: GlobalUser` - Reference to Firebase users collection
- `defaults` - Save defaults locally (i.e. who is signed in)
- `questions: [String]` - List of questions for the quiz
- `responses: [Int: Int]` - Dictionary mapping of responses. The key is question number, value is response value
- `questionCount: Int` - Integer that keeps track of which question the user is on
- `curResponse: Int` - Integer that tracks the user's current response
- `showAlert: Bool` - Boolean that determines whether an alert should be shown or not
- `activeAlert: activeAlert` - sets the current activeAlert is an enum of the following cases: `showFinishedAlert`, `alreadyCompletedAlert`, `noAnswerSelectedAlert`
- `presentationMode: Binding<PresentationMode>` - environment variable used to dismiss view

### Functions

### Dependencies

## Rejection.swift

Contains the rejection page that will be presented if a user attempts to begin a training or go/no-go session without first taking the questionnaire.
