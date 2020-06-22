//
//  Signup.swift
//  CID Gamified Training
//
//  Created by Alex on 6/16/20.
//  Copyright © 2020 Alex. All rights reserved.
//

import SwiftUI
import Firebase

/** Sign up page. */
struct Signup: View {
    
    /** Text in name field. */
    @State var name: String = ""
    
    /** Text in email field. */
    @State var email: String = ""
    
    /** Text in password field. */
    @State var password: String = ""
    
    /** Is signup page shown. */
    @Binding var signup: Bool
    
    /** Credentials invalid and show alert.  */
    @State var invalid = false
    
    /** Error message for alert. */
    @State var error = ""
    
    /** Connection to firebase users collection. */
    let db = Firestore.firestore().collection("users")
    
    /** Reference to global users object. */
    @EnvironmentObject var user: User
    
    /** Save who is signed in locally. */
    let defaults = UserDefaults.standard
    
    @State var selection = "student"
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("Account Information")) {
                        TextField("Name", text: $name)
                        TextField("Email", text: $email)
                        SecureField("Password", text: $password)
                        Picker(selection: $selection, label: Text("Picker")) {
                            Text("student").tag("student").id(UUID())
                            Text("instructor").tag("instructor").id(UUID())
                        } .pickerStyle(SegmentedPickerStyle())
                    }
                    Button(action: {
                        self.createUser(email: self.email, password: self.password, name: self.name, selection: self.selection)
                    }) {
                        Text("Create Account")
                    }
                    Button(action: {
                        self.signup = false
                    }) {
                        Text("Already have an account? Sign in here!")
                    }
                }.navigationBarTitle("Sign Up")
            }.alert(isPresented: $invalid) {
                Alert(title: Text("Invalid Credentials"), message: Text(self.error), dismissButton: .default(Text("Dismiss"), action: {
                        self.invalid = false
            })
            )
            }
        }.onAppear {
            self.name = ""
            self.email = ""
            self.password = ""
        }
    }
    
    /** Create user function. */
    func createUser(email: String, password: String, name: String, selection: String) {
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if error != nil {
                self.error = error?.localizedDescription ?? ""
                self.invalid = true
            } else {
                self.user.uid = result!.user.uid
                self.defaults.set(result!.user.uid, forKey: "uid")
                self.db.document(result!.user.uid).setData([
                "name": name,
                "user": email,
                "pass": password,
                "uid": result!.user.uid,
                "userType": selection,
                "focus": "None"])
                newFocus(db: self.db, user: self.user, defaults: self.defaults)
                self.signup = false
            }
        }
    }
}

struct Signup_Previews: PreviewProvider {
    static var previews: some View {
        Signup(signup: Binding.constant(true)).environmentObject(User())
    }
}
