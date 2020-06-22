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
     
    /** Three second transition. */
    @State var time = 2
    
    /** Reference to global user variable. */
    @EnvironmentObject var user: User
    
    /** Timer that pings the app every second. */
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
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
                Spacer()
                NavigationLink(destination:
                    Group {
                        if self.countdown {
                            Countdown(playing: Binding.constant(true))
                            .onReceive(timer) { _ in
                                if self.time > 0 {
                                    self.time -= 1
                                } else {
                                    self.time = 2
                                    self.countdown.toggle()
                                }
                            }
                        } else {
                            if self.user.regular == "promotion" {
                                Training(stars: 0)
                            } else if self.user.regular == "prevention" {
                                Training(stars: 20)
                            } else if self.user.regular == "neutral" {
                                Training(stars: 0)
                        } else {
                            Rejection()
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
                Spacer()
                NavigationLink(destination:
                    Group {
                        if self.countdown {
                            Countdown(playing: Binding.constant(true))
                            .onReceive(timer) { _ in
                                if self.time > 0 {
                                    self.time -= 1
                                } else {
                                    self.time = 3
                                    self.countdown.toggle()
                                }
                            }
                        } else {
                            if self.user.regular == "promotion" {
                                Gonogo(stars: 0)
                            } else if self.user.regular == "prevention" {
                                Gonogo(stars: 20)
                            } else if self.user.regular == "neutral" {
                                Gonogo(stars: 0)
                            }
                            else {
                                Rejection()
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
            } .onAppear {
                newFocus(db: self.db, user: self.user, defaults: self.defaults)
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
func newFocus(db: CollectionReference, user: User, defaults: UserDefaults) {
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
        ContentView().environmentObject(User())
    }
}
