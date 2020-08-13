# Instructor
This folder contains files pertaining to the instructor side of the iOS app.  This mainly includes displaying and editing classes and students within classes.

## Instructor.swift
Instructor page first displayed when an instructor signs in.  It displays a list of classes available to the instructor and allows to instructor to edit classes or view individual classes.

### Fields
 - `defaults:UserDefaults` - Save defaults locally
 - `db:CollectionReference` - Reference to user collection on Firebase
 - `error:String` - Error message for alerts
 - `invalid:Bool` - Is logout invalid
 - `user:GlobalUser` - Reference to global user variable
 - `name:String` - Instructor name
 - `email:String` - Instructor email
 - `classes:[String:DocumentReference]` - Dictionary of student IDs to student names
 
### Functions
 - `logout()` - Logout function
 - `getClasses(db: CollectionReference)` - Gets list of session for this user from Firebase
   - Parameters: `db:CollectionReference` - Reference to the classes collection in Firebase
 - `setheader(doc: CollectionReference)` - Obtain name and email from Firebase
   - Parameters: `doc:CollectionReference` - Reference to the user document

### Dependencies
User.swift, Students.swift, EditClasses.swift, Focus.swift


## Students.swift
Displays the lists of all students in a particular class.  This class is also repurposed when displaying students for an assignment progress page.

### Fields
 - `db:CollectionReference` - Reference to user collection on Firebase
 - `user:GlobalUser` - Reference to global user variable
 - `students[String:String]` - Dictionary of student IDs to student names
 - `doc:DocumentReference` - Reference to the class being displayed
 - `name:String` - Name of the class or the assignment.
 - `assignment:DocumentReference` - Reference of the assignment to be displayed
 
### Functions
 - `getStudents(doc: DocumentReference)` - Obtain students from Firebase
   - Parameters: `doc:DocumentReference` - Reference to class document

### Dependencies
User.swift, Profile.swift, EditStudents.swift, Assignments.swift, StudentCard.swift


## EditClasses.swift
View that lets you add and remove classes.

### Fields
 - `classes:String` - Class name in the text input field
 - `db:CollectionReference` - Reference to user collection on Firebase
 - `user:GlobalUser` - Reference to global user variable
 - `alert:Bool` - Show alert
 - `alertTitle:String` - Alert title
 - `error:String` - Error message for alert
 - `found:Bool` - Has the user been found
 - `listClass:[String:DocumentReference]` - Mapping from class name to class documentReference in Firebase
 
### Functions
 - `add(classes: String)` - Add class to instructor profile
   - Parameters: `classes:String` - Class name to create
 - `remove(classes: String)` - Remove class from instructor profile
   - Parameters: `classes:String` - Class name to remove

### Dependencies
User.swift


## EditStudent.swift
View that lets you add and remove students.

### Fields
 - `email:String` - Email in the text input field
 - `db:CollectionReference` - Reference to user collection on Firebase
 - `user:GlobalUser` - Reference to global user variable
 - `alert:Bool` - Show alert
 - `alertTitle:String` - Alert title
 - `error:String` - Error message for alert
 - `found:Bool` - Has the user been found
 - `classes:DocumentReference` - Reference to class document in Firebase
 
### Functions
 - `add(email: String)` - Add student with email to class
   - Parameters: `email:String` - Email to add
 - `remove(email: String)` - Remove student with email from class
   - Parameters: `email:String` - Email to remove

### Dependencies
User.swift
