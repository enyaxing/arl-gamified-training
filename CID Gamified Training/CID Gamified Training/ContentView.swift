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
                                .navigationBarTitle("")
                                .navigationBarHidden(true)
                            } else {
                                Countdown(playing: self.$countdown, instructions: $instructions)
                                .navigationBarTitle("")
                                .navigationBarHidden(true)
                            }
                        } else {
                            if self.user.regular == "promotion" {
                                Training(points: 0, type: "Training", countdown: $countdown)
                            } else if self.user.regular == "prevention" {
                                Training(points: 2000, type: "Training", countdown: $countdown)
                            } else if self.user.regular == "neutral" {
                                Training(points: 0, type: "Training", countdown: $countdown)
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
                 NavigationLink(destination:
                    Group {
                        if self.user.regular == "promotion" {
                            TrainingTutorial(points: 0, type: "Training", countdown: $countdown, showAboutView: true)
                     } else if self.user.regular == "prevention" {
                            TrainingTutorial(points: 2000, type: "Training", countdown: $countdown, showAboutView: true)
                     } else if self.user.regular == "neutral" {
                            TrainingTutorial(points: 0, type: "Training", countdown: $countdown, showAboutView: true)
                    }}) {
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
                                .navigationBarTitle("")
                                .navigationBarHidden(true)
                            } else {
                                Countdown(playing: self.$countdown, instructions: $instructions)
                                .navigationBarTitle("")
                                .navigationBarHidden(true)
                            }
                        } else {
                            if self.user.regular == "promotion" {
                                Gonogo(points: 0, type: "Gonogo", countdown: $countdown)
                            } else if self.user.regular == "prevention" {
                                Gonogo(points: 3200, type: "Gonogo", countdown: $countdown)
                            } else if self.user.regular == "neutral" {
                                Gonogo(points: 0, type: "Gonogo", countdown: $countdown)
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
                NavigationLink(destination:
                    Group {
                        if self.user.regular == "promotion" {
                            GonogoTutorial(points: 0, type: "Gonogo", countdown: $countdown, showAboutView: true)
                        } else if self.user.regular == "prevention" {
                            GonogoTutorial(points: 2000, type: "Gonogo", countdown: $countdown, showAboutView: true)
                        } else if self.user.regular == "neutral" {
                            GonogoTutorial(points: 0, type: "Gonogo", countdown: $countdown, showAboutView: true)
                    }}) {
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
                    NavigationLink(destination: Profile(uid: self.user.uid)) {
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
            self.user.avgResponseTime = 0.00
            self.user.totalSessions = 0
            self.user.totalTime = 0
            
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

func obtainFields(db: CollectionReference, user: GlobalUser, defaults: UserDefaults) {
    db.document(user.uid).getDocument { (document, error) in
        if let document = document, document.exists {
            if document.get("avgResponseTime") != nil {
                user.avgResponseTime = document.get("avgResponseTime") as! Double
            }
            
            if document.get("totalSessions") != nil {
                user.totalSessions = document.get("totalSessions") as! Int
            }
            
            if document.get("avgResponseTime") != nil {
                user.avgResponseTime = document.get("avgResponesTime") as! Double
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
