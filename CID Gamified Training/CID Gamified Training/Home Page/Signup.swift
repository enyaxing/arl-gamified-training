//
//  Signup.swift
//  CID Gamified Training
//
//  Created by Kyle Lui on 6/16/20.
//  Copyright © 2020 X-Force. All rights reserved.
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
    @EnvironmentObject var user: GlobalUser
    
    /** Save who is signed in locally. */
    let defaults = UserDefaults.standard
    
    @State var selection = "student"
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Name", text: $name)
                    .inputStyle()
                TextField("Email", text: $email)
                    .inputStyle()
                SecureField("Password", text: $password)
                    .inputStyle()
                Picker(selection: $selection, label: Text("Picker")) {
                    Text("student").tag("student").id(UUID())
                    Text("instructor").tag("instructor").id(UUID())
                }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal)
                Spacer()
                Button(action: {
                    self.createUser(email: self.email, password: self.password, name: self.name, selection: self.selection)
                }) {
                    Text("Create Account")
                        .customRoundedButtonStyle()
                } .padding()
                Button(action: {
                    self.signup = false
                }) {
                    Text("Already have an account? Sign in here!")
                        .font(.custom("Helvetica-Bold", size: 16))
                        .foregroundColor(Color.armyGreen)
                } .padding()
            } .navigationBarTitle("Sign Up")
                .alert(isPresented: $invalid) {
                    Alert(title: Text("Invalid Credentials"), message: Text(self.error), dismissButton: .default(Text("Dismiss"), action: {
                            self.invalid = false
                }))}
        }.onAppear {
            self.name = ""
            self.email = ""
            self.password = ""
        }
    }
    
    /** Create user function.
     Parameters:
        email - String representing email of user
        password - String representing password of user
        name - String representing name of user
        selection - String representing user type either "student" or "instructor" */
    func createUser(email: String, password: String, name: String, selection: String) {
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if name.isEmpty {
                self.error = "Please enter a valid name to continue."
                self.invalid = true
            } else if error != nil {
                self.error = error?.localizedDescription ?? ""
                self.invalid = true
            }
            else {
                self.user.uid = result!.user.uid
                self.defaults.set(result!.user.uid, forKey: "uid")
                self.db.document(result!.user.uid).setData([
                "name": name,
                "user": email,
                "pass": password,
                "uid": result!.user.uid,
                "userType": selection,
                "focus": "None",
                "totalTime": 0.00,
                "totalSessions": 0,
                "accuracy": 0.00])
                newFocus(db: self.db, user: self.user, defaults: self.defaults)
                obtainFields(db: self.db, user: self.user, defaults: self.defaults)
                self.signup = false
            }
        }
    }
}

struct Signup_Previews: PreviewProvider {
    static var previews: some View {
        Signup(signup: Binding.constant(true)).environmentObject(GlobalUser())
    }
}
