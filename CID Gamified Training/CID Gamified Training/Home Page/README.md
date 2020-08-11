# arl-gamified-training
X-Force Summer 2020

# Home Page

## ContentView.swift
Contains the home page of the app. Features include a questionnaire, forced choice training session, and go/no-go training session. Users also have the option to sign out, change their focus style, view their settings, and see their personal profiles.

### Fields

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


