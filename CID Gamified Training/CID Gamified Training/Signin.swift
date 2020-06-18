//
//  Signup.swift
//  CID Gamified Training
//
//  Created by Alex on 6/16/20.
//  Copyright © 2020 Alex. All rights reserved.
//

import SwiftUI
import Firebase

struct Signin: View {
    
    @State var email: String = ""
    @State var password: String = ""
    @State var signup = false
    @State var invalid = false
    @State var error = ""
    @State var uid = UserDefaults.standard.string(forKey: "uid") ?? ""
    let defaults = UserDefaults.standard
    
    var body: some View {
        
        Group {
            if uid != "" {
                ContentView(uid: $uid)
            } else if signup {
                Signup(signup: $signup, uid: $uid)
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
    
    func login(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if error != nil {
                self.error = error?.localizedDescription ?? ""
                self.invalid = true
            } else {
                self.uid = result!.user.uid
                self.defaults.set(self.uid, forKey: "uid")
            }
        }
    }
}

struct Signin_Previews: PreviewProvider {
    static var previews: some View {
        Signin()
    }
}
