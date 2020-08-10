# Summary
This folder contains files pertaining to the summary view.  In particular, these files are used during the end of training session page and when viewing past training sessions through the user profile.

## Summary.swift
This is the main summary view dispalyed as soon as a training session is completed or when viewing past sessions.  It displays overall accuracy and lets the user view specific questions by clicking on them.

### Fields
 - `answers:[Answer]` - List of answer from completed training session
 - `sess:String` - Firebase session reference
 - `hideback:Bool` - Hide back buton
 - `user:GlobalUser` - Reference to global user variable
 - `db:CollectionReference` - Connection to firebase user collection
 - `countdown:Bool` - Show countdown
 - `uid:String1 - UID of the user
 - `endTime:Timestamp` - Records timestamp of when the session has finished
 - `session:Session` - Session object to be summarized
 - `tagID:String` - Comment about the tag performance displayed at the top of the page
 
### Functions
 - `getAnswers(db: CollectionReference)` - Get the list of answers of session from Firebase
   - Parameters: `db:CollectionReference` - Reference to answers collection in Firebase
 - `updateStats(doc: DocumentReference)` - Update and save stats on Firebase
   - Parameters: `doc:DocumentReference` - Reference to user document in Firebase
 - `countCorrect(answer: [Answer]) -> Int` - Count the number of correct answers
   - Parameters: `answer:[Answer]` - List of answers for this summary
   - Return: Int representing number of correct answers
 - `incorrect(answer: [Answer]) -> Int` - Count the number of incorrect answers
   - Parameters: `answer:[Answer]` - List of answers for this summary
   - Return: Int representing the number of incorrect answers
 - `percentage(answer: [Answer]) -> Double` - Calculate percentage of correct answers
   - Parameters: `answer:[Answer]` - List of answers for this summary
   - Return: List of Doubles of length 2. Double[0] = percentage of friendly correct. Double[1] = percentage of enemy correct.
 - `pareImage(location:String) -> String` - Pare image reference to be saved on Firebase
   - Parameters: `location:String` - Represents complete file path
   - Return: String representing part of the file path starting with CID Images
 - `parseID(id: Int) -> String` - Parse question id to be saved on Firebase
   - Parameters: `id:Int` - Represents question number 0-19
   - Return: 2 digit String from 01-20
 - `readTags(answer [Answer]) -> String` - Generate tag comments based on the list of answers
   - Parameters: `answer:[Answer]` - List of answers for this summary
   - Return: String representing the comment to be displayed
 - `checkComplete(user: DocumentReference, uid: String, percentage: [Double], timeInterval: Double)` - Checks if the assignment is assigned by instructor and has been completed based on the requirements of the assignment
   - Parameters: `user:DocumentReference` - Reference to user document in Firebase; `uid:String` - UID of student; `percentage:[Double]` - Friendly and enemy accuracy percentages; `timeInterval:Double` - Time to complete session
    
### Dependencies
Answer.swift, User.swift, Session.swift, SummaryRow.swift, SummaryDetail.swift


## SummaryRow.swift
The individual rows in the summary view.  Displays the image of the vehicle in the question and whether the question was incorrect or correct.

### Fields
 - `answer:Answer` - One individual answer to be displayed
 
### Functions
 - `correct(answer: Answer) -> Bool` - Is the answer correct
   - Parameters: `answer:Answer` - Answer to check
   - Return: Bool representing whether the answer is correct or not
 - `color(answer: Answer) -> Color` - Background blue if correct and red if incorrect
   - Parameters: `answer:Answer` - Answer to check
   - Return: Color to be displayed as background

### Dependencies
Answer.swift


## SummaryDetail.swift
Detailed description of a single answer.  Also has AR/3D View option if 3D model exists for this vehicle.

### Fields
 - `answer:Answer` - A single answer to be displayed in detail
 - `back:Bool` - Hide navigation back button

### Dependencies
Answer.swift
