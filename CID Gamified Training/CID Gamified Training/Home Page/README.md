# arl-gamified-training
X-Force Summer 2020

# Home Page

## ContentView.swift
Contains the home page of the app. Features include a questionnaire, forced choice training session, and go/no-go training session. Users also have the option to sign out, change their focus style, view their settings, and see their personal profiles.

### Fields
- `back:Bool` - Hide navigation back bar
- `error:String` - Error message for alerts
- `invalid:Bool` - Is log-out invalid?
- `countdown:Bool` - current state of transition
- `instructions:Bool` - show instructions
- `user:GlobalUser` - Reference to global user variable

### Functions
- `logout()` - Logout function
- `newFocus(db: CollectionReference, user: GlobalUser, defaults: UserDefaults)` - Obtain focus value from Firebase user
- `obtainFields(db: CollectionReference, user: GlobalUser, defaults: UserDefaults)` - Obtain overall statistics from Firebase


## Signin.swift
Users are able to sign in with an email and a password.

### Fields
- `email: String` - Text in the email field
- `var password: String` - Text in the password field
- `signup:Bool` - switch to sign-up view
- `invalid:Bool` - credentials invalid and show alert
- `error:String` - error message for alert
- `user:GlobalUser` - Refernce to global user variable
- `bottomPadding: CGFloat` - Used for log in and new user button to float up

### Functions
- `login(email: String, password: String)` - Login function 

## Signup.swift
New users are able create an account with an email and a password.

### Fields
- `name:String` - Text in name field
- `email:String` - Text in email field
- `password:String` - Text in password field  
- `signup:Bool` - Is the sign-up page shown?
- `invalid:Bool` - Credentials invalid and show alert
- `error:String` - Error message for alert
- `user:GlobalUser` - Reference to global users object
- `selection:String` - student or instructor?

### Functions
- `createUser(email: String, password: String, name: String, selection: String)` - Create user function
   
