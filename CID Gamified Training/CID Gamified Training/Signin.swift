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
    @State var show = false
    
    var body: some View {
        
        Group {
            if show {
                ContentView()
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
                        }.navigationBarTitle("Sign in")
                    }
                }
            }
        }
    }
    
    func login(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if error != nil {
                print(error?.localizedDescription ?? "")
                self.show = false
            } else {
                self.show = true
            }
        }
    }
}



struct Signin_Previews: PreviewProvider {
    static var previews: some View {
        Signin()
    }
}
