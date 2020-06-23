//
//  ContentView.swift
//  CID Gamified Training
//
//  Created by Alex on 6/8/20.
//  Copyright © 2020 Alex. All rights reserved.
//
import SwiftUI
import Firebase

/** Main menu view. */
struct ContentView: View {
    
    /** Save defaults locally (ie. who is signed in). */
    let defaults = UserDefaults.standard
    
    /** Connection to firebase user collection. */
    let db = Firestore.firestore().collection("users")
    
    /** Hide navigation back bar. */
    @State var back = false
    
    /** Error message for alerts. */
    @State var error = ""
    
    /** Is logout invalid. */
    @State var invalid = false
    
    /** Should countdown play?  */
    @State var countdown = true
    
    /** Show instructions. */
    @State var instructions = true
    
    /** Reference to global user variable. */
    @EnvironmentObject var user: GlobalUser
    
    var body: some View {
        NavigationView {
            VStack(alignment: .center) {
                Text("ARL Gamified Training")
                    .font(.largeTitle)
                    .fontWeight(.black)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(20)
                Spacer()
                NavigationLink(destination: Question(curResponse: 0)) {
                    Text("Questionairre")
                        .font(.largeTitle)
                        .fontWeight(.black)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(20)
                }
                HStack {
                NavigationLink(destination:
                    Group {
                        if self.user.regular != "promotion" && self.user.regular != "prevention" && self.user.regular != "neutral" {
                            Rejection()
                        }
                        else if self.countdown {
                            if self.instructions {
                                Instructions(type: 1, instructions: $instructions)
                            } else {
                                Countdown(playing: self.$countdown, instructions: $instructions)
                            }
                        } else {
                            if self.user.regular == "promotion" {
                                Training(stars: 0, countdown: $countdown)
                            } else if self.user.regular == "prevention" {
                                Training(stars: 20, countdown: $countdown)
                            } else if self.user.regular == "neutral" {
                                Training(stars: 0, countdown: $countdown)
                        }
                    }
                }) {
                    Text("Training")
                        .font(.largeTitle)
                        .fontWeight(.black)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(20)
                }
                 NavigationLink(destination: Text("first view")) {
                    Image("info")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .background(Color.white)
                    .cornerRadius(20)
                }
            }
            HStack {
                Spacer()
                NavigationLink(destination:
                    Group {
                        if self.user.regular != "promotion" && self.user.regular != "prevention" && self.user.regular != "neutral" {
                            Rejection()
                        }
                        else if self.countdown {
                            if self.instructions {
                                Instructions(type: 2, instructions: $instructions)
                            } else {
                                Countdown(playing: self.$countdown, instructions: $instructions)
                            }
                        } else {
                            if self.user.regular == "promotion" {
                                Gonogo(stars: 0, countdown: $countdown)
                            } else if self.user.regular == "prevention" {
                                Gonogo(stars: 20, countdown: $countdown)
                            } else if self.user.regular == "neutral" {
                                Gonogo(stars: 0, countdown: $countdown)
                            }
                        }
                    }) {
                    Text("Go/NoGo")
                        .font(.largeTitle)
                        .fontWeight(.black)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(20)
                }
                NavigationLink(destination: Text("second view")) {
                    Image("info")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .background(Color.white)
                    .cornerRadius(20)
                }
                Spacer()
                } 
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        self.logout()
                    }) {
                        Text("Sign out")
                    }
                    .padding(10)
                    .background(Color.white)
                    .cornerRadius(20)
                    Spacer()
                    NavigationLink(destination: Focus()) {
                        Text(self.user.regular)
                        .padding(10)
                        .background(Color.white)
                        .cornerRadius(20)
                    }
                    Spacer()
                    NavigationLink(destination: Setting()) {
                        Text("Settings")
                        .padding(10)
                        .background(Color.white)
                        .cornerRadius(20)
                    }
                    Spacer()
                    NavigationLink(destination: Profile()) {
                    Text("Profile")
                    .padding(10)
                    .background(Color.white)
                    .cornerRadius(20)
                    }
                    Spacer()
                }
            }
            .background(Image("background"))
            .alert(isPresented: $invalid) {
                Alert(title: Text("Error Signing Out"), message: Text(self.error), dismissButton: .default(Text("Dismiss"), action: {
                        self.invalid = false
                    }))
            }
        }
    }
    
    /** Logout function. */
    func logout() {
        do {
            try Auth.auth().signOut()
            self.user.uid = ""
            self.user.userType = "student"
            defaults.set("", forKey: "uid")
            defaults.set("student", forKey: "userType")
        } catch let error as NSError {
            self.error = error.localizedDescription
            self.invalid = true
        }
    }
}

/** Obtain focus value from firebase user. */
func newFocus(db: CollectionReference, user: GlobalUser, defaults: UserDefaults) {
    db.document(user.uid).getDocument { (document, error) in
        if let document = document, document.exists {
            if document.get("focus") != nil {
                user.regular = document.get("focus") as! String
                defaults.set(user.regular, forKey: "focus")
            }
            if document.get("userType") != nil {
                user.userType = document.get("userType") as! String
                defaults.set(user.userType, forKey: "userType")
            }
        } else {
            print("Document does not exist")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(GlobalUser())
    }
}
