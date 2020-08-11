# arl-gamified-training
X-Force Summer 2020

# Games
The files in this folder deals with the functioning of the game itself.

## Gonogo.swift

The go/no-go format allows users only one option (enemy) when an image appears. If the user does not respond within three seconds, the app will assume the user has selected to identify the vehicle as friendly. The session will then proceed to the next question. There are twenty total questions. 

### Fields
- `summary:Bool` - Show summary view
- `points:Int` - Points
- `answers:[Answer]` - List of answers
- `countdown:Bool` - Show countdown
- `startTimestamp:Timestamp` - Records the start of the session 

### Functions
 - `enemyActionButton()` - Action performed when enemy button clicked.
 - `headline()` - Questions remaining and time remaining.
 - `calculateTimeScore(timeElapsed: Double)` - Uses an exponential function to map time to points.
 - `selectRandom()` - Randomly select enemy:friendly at 4:1 ratio.
 
### Dependencies
Answer.swift

## GonogoTutorial.swift

Users also have the option of walking through a tutorial mode of the go/no-go format, where the app introduces all the features the user will see in this style of training session.

### Fields
- `summary:Bool` - Show summary view
- `points:Int` - Points
- `type:String` - Type
- `answers:[Answer]` - List of answers
- `countdown:Bool` - Show countdown
- `showAboutView: Bool` - Whether we should show the about view
- `activeAboutType: AboutType` - Which about descriptor is active
- `aboutDescription: String` - Current description
- `aboutTitle: String` - Current title
- `tutorialFirstRound: Bool` - Whether the tutorial basics have already been completed
- `startTimestamp:Timestamp` - Records the start of the session 

### Functions
 - `enemyActionButton()` - Action performed when enemy button clicked.
 - `setCorrectDescriptor()` - Sets the correct descriptor based on the current activeAboutType.
 - `changeAboutView(curAboutType: AboutType)` - Takes in an AboutType and sets it as the current activeAboutType. Also sets the descriptor and makes the
    about view show
 - `headline()` - Questions remaining and time remaining.

## Instructions.swift

After a user selects a training session, the first page they will see is an instructions page with some helpful tips before they begin.

## Training.swift

The forced choice format allows users two options (friendly/enemy) when an image appears. The session will not proceed unless the user responds to the current image. There are twenty total questions. 

## TrainingTutorial.swift

Users also have the option of walking through a tutorial mode of the forced choice format, where the app introduces all the features the user will see in this style of training session.
