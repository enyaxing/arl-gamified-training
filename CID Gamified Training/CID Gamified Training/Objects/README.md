# Objects
This folder contains the self-defined objects used throughout the app.

## Answer.swift
Represents an answer to a question. Primarily used to store answers during session and display during summary.

### Fields
 - `id:Int` - Question number
 - `expected:String` - Expected response
 - `received:String` - Received response
 - `image - String` - Path to image to display
 - `vehicleName:String` - Vehicle name
 - `time:Double` - Time to answer question


## Assignment.swift
Represents a single assignment.

### Fields
 - `name:String` - Name of assignment
 - `library[Card]` - List of unselected vehicles
 - `friendly:[Card]` - List of friendly vehicles
 - `enemy:[Card]` - List of enemy vehicles
 - `friendlyAccuracy:Double` - Required accuracy for friendly vehicles
 - `enemyAccuracy:Double` - Required accuracy for enemy vehicles
 - `time:Double` - Required time of completion

### Dependencies
Card.swift


## Card.swift
Card object that tracks vehicle name and lets cards be comparable.

### Fields
 - `id:UUID()` - ID of the card
 - `name:String` - Name of the vehicle on the card

### Functions
 - `< (lhs: Card, rhs: Card) -> Bool` - Card comparator function


## Session.swift
Object representing a session. Tracks session points, time of session, and type of session.

### Fields
 - `points:Int` - Points collected in a session
 - `timestamp:Timestamp` - Timestamp of the session
 - `type:String` - Type of session (Forced Choice, Go/No-Go, Tutorial)


## Tags.swift
Tag object to read tags from tags.json

### Fields
 - `image:String` - Image that is tagged
 - `tags:[String]` - List of tags
 

## User.swift
Global user class to store user uid and regular focus type.

### Fields
 - `uid:String` - uid of the user
 - `regular:String` - Regulatory focus value of the user
 - `userType:String` - Is the user a student or an instructor
 - `totalTime:TimeInterval` - Total time played
 - `avgResponseTime:Double` - average response time in seconds
 - `totalSessions:Int` - Total number of sessions completed
 - `accuracy:Double` - Response accuracy


## Model.swift
Model represents photo to be displayed during training. Also has reference to list of friendly and enemy vehicles for training.

### Fields
 - `id:UUID()` - ID variable for loops
 - `imageURL:String` - File name in directory
 - `vehicleName:String` - Photo vehicle name
 - `friendly:[Model]` - List of friendly vehicles
 - `foe:[Model]` - List of enemy vehicles
 - `friendlyFolder:[Card]` - List of friendly photo folders
 - `enemyFolder:[Card]` - List of enemy photo folders
 - `unselectedFolder:[Card]` - List of unselected photo folders
 
### Functions
 - `settingLoad(name: String) -> [Model]` - Load the friendly and enemy model arrays with friendlyFolder and enemyFolder card arrays
   - Parameters: `name:String` - either "friendly" or "enemy" indicating which should be loaded
   - Return: An array of Models to be used in the training games
 - `initial(uid: String)` - Syncs the enemy and friendly settings with the ones present in Firebase
   - Parameters: `uid:String` - The user's uid
 - `check(name: String, arr:[Card]) -> Bool` - Checks if a certain vehicle is present in a folder
   - Parameters: `name:String` - Vehicle to search for; `arr:[Card]` - Represents a folder either enemy or friendly
 - `dirLoad() -> [Card]` - How to read file names in directory. Loads the unselected array
   - Return: An array of Cards representing the unselected vehicles
