//
//  Signup.swift
//  CID Gamified Training
//
//  Created by Alex on 6/16/20.
//  Copyright © 2020 Alex. All rights reserved.
//

import SwiftUI
import Firebase

/** Sign in page. */
struct Signin: View {
    
    /** Text in the email field. */
    @State var email: String = ""
    
    /** Text in the password field. */
    @State var password: String = ""
    
    /** Switch to signup view. */
    @State var signup = false
    
    /** Credentials invalid and show alert. */
    @State var invalid = false
    
    /** Error message for alert. */
    @State var error = ""
    
    /** Refernce to global user variable. */
    @EnvironmentObject var user: GlobalUser
    
    /** Save who is logged in locally. */
    let defaults = UserDefaults.standard
    
    /** Connection to firebase user collection. */
    let db = Firestore.firestore().collection("users")
    
    var body: some View {
        Group {
            if user.uid != "" {
                if user.userType == "student" {
                    ContentView()
                } else {
                    Instructor()
                }
            } else if signup {
                Signup(signup: $signup)
            } else {
                NavigationView {
                    VStack {
                        Form {
                            Section(header: Text("Account Information")) {
                                TextField("Email", text: $email)
                                SecureField("Password", text: $password)
                            }
                            Button(action: {
                                self.login(email: self.email, password: self.password)
                            }) {
                                Text("Sign in")
                            }
                            Button(action: {
                                self.signup = true
                            }) {
                                Text("New User? Sign up Here!")
                            }
                        }.navigationBarTitle("Sign in")
                    }
                }
            }
        }.alert(isPresented: $invalid) {
            Alert(title: Text("Invalid Credentials"), message: Text(self.error), dismissButton: .default(Text("Dismiss"), action: {
            self.invalid = false
        })
        )
        }.onAppear {
            self.email = ""
            self.password = ""
        }
    }
    
    /** Login function*/
    func login(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if error != nil {
                self.error = error?.localizedDescription ?? ""
                self.invalid = true
            } else {
                self.user.uid = result!.user.uid
                self.defaults.set(result!.user.uid, forKey: "uid")
                newFocus(db: self.db, user: self.user, defaults: self.defaults)
                obtainFields(db: self.db, user: self.user, defaults: self.defaults)
            }
        }
    }
}

struct Signin_Previews: PreviewProvider {
    static var previews: some View {
        Signin().environmentObject(GlobalUser())
    }
}
