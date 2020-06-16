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
                        self.createUser(email: self.email, password: self.password)
                    }) {
                        Text("Create Account")
                    }
                }.navigationBarTitle("Sign Up")
            }
        }
    }
    
    func createUser(email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if error != nil {
                print(error?.localizedDescription ?? "")
                self.show = false
            } else {
                self.show = true
            }
        }
    }
}

struct Signup_Previews: PreviewProvider {
    static var previews: some View {
        Signup(show: Signin().$show)
    }
}
