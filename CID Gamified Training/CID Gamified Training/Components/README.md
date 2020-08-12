# arl-gamified-training

X-Force Summer 2020

# Components

## ProgressBar.swift

Contains the progress bar shown in training and go/no-go sessions. The current total is set to 20, the number of vehicles that show per session.

### Fields

- `value: Int` - Current progress bar value

## StatBox.swift

Contains the StatBox seen in profile views and assignment details. To use it, pass in the image icon name along with a description.

### Fields

- `img_name: String` - Name of the image icon to display
- `description: String` - Description of the statistic
- `item: Text?` - Optional default item description
- `user:GlobalUser` - Reference to global user variable

## RadioButtons.swift

### Fields
- `curResponse: Int` - Stores the user's current selected response
- `questionCount: Int` - References the question that the user is currently on
- `responseDescription: [[String]]` - Description for each response as it varies by question

### Functions
- `getResponseDescription(_ num: Int) -> String - Returns the correct response description based on current response. Based on responseDescription values. 
  - Parameters: `num: Int` - Current number for the level of agreement for the question
  - Return value: `String` - Returns correct response description for the current question and agreement level
