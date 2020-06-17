//
//  Signup.swift
//  CID Gamified Training
//
//  Created by Alex on 6/16/20.
//  Copyright © 2020 Alex. All rights reserved.
//

import SwiftUI
import Firebase

struct Signup: View {
    
    @State var name: String = ""
    @State var email: String = ""
    @State var password: String = ""
    @Binding var show: Bool
    @Binding var signup: Bool
    @State var invalid = false
    @State var error = ""
    let db = Firestore.firestore().collection("users")
    @Binding var uid: String
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("Account Information")) {
                        TextField("Name", text: $name)
                        TextField("Email", text: $email)
                        SecureField("Password", text: $password)
                    }
                    Button(action: {
                        self.createUser(email: self.email, password: self.password, name: self.name)
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
        }
    }
    
    func createUser(email: String, password: String, name: String) {
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if error != nil {
                self.show = false
                self.error = error?.localizedDescription ?? ""
                self.invalid = true
            } else {
                self.uid = result!.user.uid
                self.db.document(self.uid).setData([
                "name": name,
                "user": email,
                "pass": password,
                "uid": result!.user.uid])
                self.signup = false
                self.show = true
            }
        }
    }
}

struct Signup_Previews: PreviewProvider {
    static var previews: some View {
        Signup(show: Binding.constant(false), signup: Binding.constant(true), uid: Binding.constant(""))
    }
}
