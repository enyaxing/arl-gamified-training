# Assignments
The files in this folder deal with setting the vehicles to appear as friendly or enemy during the practice sessinos as well as creating assignments on the instructor side that can be practiced by the students.


## Setting.swift
From the student's POV, this page allows you to select which vehicles to practice.  There is a reset button which resets to the default assignment, a save button which saves the current assignment, a random button which creates a random assignment, and an assignment button which lists specific assignments created by the instructor.
From the instrucotr's POV, this is the create assignments page which allows the instructor to create and save an assignment for a specific class to practice.

### Fields
 - `library:[Card]` - Library of unselected folders
 - `friendly:[Card]` - List of friendly folders
 - `enemy:[Card]` - List of enemy folders
 - `alert:Bool` - Show alert
 - `db:CollectionReference` - Connection to firebase user collection
 - `user:GlobalUser` - Reference to global user variable
 - `name:String` - Assignment name
 - `friendlyAccuracy:Int` - Required friendly accuracy pergentage
 - `enemyAccruacy:Int` - Required enemy accuracy percentage
 - `time:Int` - Required time of assignment completion
 - `classes:DocumentReference` - Document reference to class in Firebase
 - `alertTitle:String` - Title of alert
 - `alertMessage: String` - Alert message

### Functions
 - `save()` - If student, saves the current settings to be used in training games. If instructor, saves the current settings as an assignment.
 - `getClass()` - Gets the class of the student.
 - `random()` - Generates a random assignment. Selects one enemy and one friendly vehicle uniformly at random.

### Dependencies
Card.swift, User.swift, Assignments.swift, CardView.swift, AdvancedSetting.swift


## CardView.swift
Displays the vehicle names and image when shown in the settings and assignments pages.  Colors the background gray, blue, or red depending on whether the vehicle is unselected, frienldy, or enemy respectively.

### Fields
 - `folder:String` - Name of vehicle folder
 - `back:Color` - Background color
 
### Functions
 - `getImage() -> String` - Retrieve image from folder name
   - Return: String representing the path to the image


## Assignments.swift
Displays the list of assignments available to either the instructor or the student.  If the user is an instructor, he/she will be given the option to create more assignments.

### Fields
 - `db:CollectionReference` - Connection to firebase user collection
 - `user:GlobalUser` - Reference to global user variable
 - `assignments:[String:Assignment]` - Mapping from assignment name to assignment
 - `classes:DocumentReference` - Document reference to class in Firebase

### Functions
 - `getassignments(db: CollectionReference)` - Gets list of sessions for this user from firebase
   - Parameters: `db:CollectionReference` - Assignments collection in Firebase
 - `strCards(arr: [String]) -> [Card]` - Converts a list of string to a list of cards
   - Parameters: `arr:[String]` List of strings to be converted
   - Return: Resulting list of cards

### Dependencies
Assignment.swift, AssignmentDetail.swift, Card.swift, User.swift


## AssignmentDetails.swift
View that displays detailed information about a specific assignment. Displays enemy and friendly vehicles as well as required accuracy rates and time for assignment.

### Fields
 - `assignment:Assignment` - Assignment to be displayed in detail
 - `alert:Bool` - Show alert
 - `db:CollectionReference` - Connection to firebase user collection
 - `user:GlobalUser` - Reference to global user variable
 - `doc:DocumentReference` - Document reference to class in Firebase
 - `alertTitle:String` - Title of alert
 - `error: String` - Alert message
 - `assignments:[String:Assignment]` - Mapping from assignment name to assignment

### Dependencies
Assignment.swift, StatBox.swift, CardView.swift, Students.swift, User.swift, Model.swift


## AdvancedSetting.swift
View lets instructor select accuracy and time requirements for assignments.

### Fields
 - `friendlyAccuracy:Int` - Required friendly accuracy pergentage
 - `enemyAccruacy:Int` - Required enemy accuracy percentage
 - `time:Int` - Required time of assignment completion
 
## StudentCard.Swift
Student row display when showing assignment progress.  Displays the student name and either INCOMPLETE or COMPLETE depending on if the assignment is completed by this student.

### Fields
 - `name:String` - Student name
 - `id:String` - Student id
 - `doc"DocumentReference` - Reference to assignment document
 - `complete:Bool` - Is the assignment completed by this student
 
### Functions
 - `checkStudent(doc: DocumentReference)` - Checks if assignment is completed by this student
   - Parameters: `doc:DocumentReference` - Reference to assignment document
