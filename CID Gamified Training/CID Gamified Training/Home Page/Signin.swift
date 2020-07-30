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
    
    /** Used for log in and new user button to float up. */
    @State private var bottomPadding: CGFloat = 0
    
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
                ZStack {
                    VStack {
                        Text("Sign In")
                            .font(.custom("Helvetica-Bold", size: 30))

                            .foregroundColor(.white)
                            .padding(.top, 40.0)
                        
                        TextField("Email", text: $email)
                            .padding(.horizontal, 30.0)
                            .padding(.vertical)
                            .font(.custom("Helvetica", size: 16))
                            .background(
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(Color(#colorLiteral(red: 0.10196078568696976, green: 0.10196078568696976, blue: 0.10980392247438431, alpha: 1)))
                                    .frame(width: 343, height: 50)
                                    .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.25)), radius:4, x:0, y:4)
                            )

                        SecureField("Password", text: $password)
                            .padding(.horizontal, 30.0)
                            .padding(.vertical)
                            .font(.custom("Helvetica", size: 16))
                            .background(
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(Color(#colorLiteral(red: 0.10196078568696976, green: 0.10196078568696976, blue: 0.10980392247438431, alpha: 1)))
                                    .frame(width: 343, height: 50)
                                    .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.25)), radius:4, x:0, y:4)
                            )
                        
                        Spacer()
                        Spacer()
                        VStack {
                            Button(action: {
                                self.login(email: self.email, password: self.password)
                            }) {
                                Text("LOG IN")
                                    .font(.custom("Helvetica-Bold", size: 16)).foregroundColor(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)))
                                    .multilineTextAlignment(.center)
                                    .background(//Rectangle 9
                                        RoundedRectangle(cornerRadius: 40)
                                            .fill(Color.armyGreen)
                                            .frame(width: 229, height: 46)
                                            .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.25)), radius:4, x:0, y:4)
                                    )
                            }
                                .padding()
                            
                            Button(action: {
                                self.signup = true
                            }) {
                                Text("New User? Sign up Here!")
                                    .font(.custom("Helvetica-Bold", size: 16))
                                    .foregroundColor(Color.armyGreen)
                            }
                                .padding()
                        }
                    }
                    .modifier(AdaptsToKeyboard())
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
                self.email = ""
                self.password = ""
            }
        }
    }
}

struct Signin_Previews: PreviewProvider {
    static var previews: some View {
        Signin().environmentObject(GlobalUser())
            .environment(\.colorScheme, .dark)
    }
}
