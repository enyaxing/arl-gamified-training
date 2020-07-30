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
                Spacer()
                Image("title")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 350)
                Spacer()
                NavigationLink(destination: Question(curResponse: 0)) {
                    Text("Questionairre")
                        .customRoundedButtonWithStrokeStyle()
                }
                ZStack {
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
                                Training(points: 0, countdown: $countdown)
                            } else if self.user.regular == "prevention" {
                                Training(points: 2000, countdown: $countdown)
                            } else if self.user.regular == "neutral" {
                                Training(points: 0, countdown: $countdown)
                        }
                    }
                }) {
                    Text("Training")
                        .frame(maxWidth: .infinity)
                        .customRoundedButtonWithStrokeStyle()
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
                        Image("info3")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(Color.white)
                        .cornerRadius(20)
                }
                 .offset(x: 125)
            }
            ZStack {
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
                                Gonogo(points: 0, countdown: $countdown)
                            } else if self.user.regular == "prevention" {
                                Gonogo(points: 3200, countdown: $countdown)
                            } else if self.user.regular == "neutral" {
                                Gonogo(points: 0, countdown: $countdown)
                            }
                        }
                    }) {
                    Text("Go/No-Go")
                        .customRoundedButtonWithStrokeStyle()
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
                        Image("info3")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(Color.white)
                        .cornerRadius(20)
                }
                    .offset(x: 125)
                
                Spacer()
                } 
                Spacer()
                Spacer()
                HStack {
                    Button(action: {
                        self.logout()
                    }) {
                        Text("Sign out")
                         .font(.custom("Helvetica Neue Bold", size: 15))
                         .foregroundColor(Color.white)
                    }
                    .padding(10)
                    .background(Color(UIColor.lightGray))
                    .cornerRadius(20)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.white, lineWidth: 5)
                    )
                    Spacer()
                    NavigationLink(destination: Focus()) {
                        Text(self.user.regular.capitalized)
                        .font(.custom("Helvetica Neue Bold", size: 15))
                        .padding(10)
                        .foregroundColor(Color.white)
                        .cornerRadius(20)
                    }
                    .background(Color(UIColor.lightGray))
                    .cornerRadius(20)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.white, lineWidth: 5)
                    )
                    Spacer()
                    NavigationLink(destination: Setting()) {
                        Text("Settings")
                        .font(.custom("Helvetica Neue Bold", size: 15))
                        .padding(10)
                        .foregroundColor(Color.white)
                        .cornerRadius(20)
                    }
                    .background(Color(UIColor.lightGray))
                    .cornerRadius(20)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.white, lineWidth: 5)
                    )
                    Spacer()
                    NavigationLink(destination: Profile(uid: self.user.uid)) {
                    Text("Profile")
                    .font(.custom("Helvetica Neue Bold", size: 15))
                    .padding(10)
                    .foregroundColor(Color.white)
                    .cornerRadius(20)
                    }
                    .background(Color(UIColor.lightGray))
                    .cornerRadius(20)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.white, lineWidth: 5)
                    )
                }
                .padding()
            }
            .background(Image("black").resizable().scaledToFill().edgesIgnoringSafeArea(.all))
            .alert(isPresented: $invalid) {
                Alert(title: Text("Error Signing Out"), message: Text(self.error), dismissButton: .default(Text("Dismiss"), action: {
                        self.invalid = false
                    }))
            }
//            .onAppear{
//                initial(uid: self.user.uid)
//            }
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
            
            if document.get("accuracy") != nil {
                user.avgResponseTime = document.get("accuracy") as! Double
            }
        } else {
            print("Document does not exist")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(GlobalUser())
        .previewDevice(PreviewDevice(rawValue: "iPhone XS Max"))
    }
}
