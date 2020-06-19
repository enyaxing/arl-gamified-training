//
//  ContentView.swift
//  CID Gamified Training
//
//  Created by Alex on 6/8/20.
//  Copyright © 2020 Alex. All rights reserved.
//
import SwiftUI
import Firebase

struct ContentView: View {
    
    let defaults = UserDefaults.standard
    let db = Firestore.firestore().collection("users")
    
    //@State var regular = "None"
    
    @State var back = false
    
    @State var error = ""
    
    @State var invalid = false
    
    @State var countdown = true
       
    @State var time = 3
    
    @EnvironmentObject var user: User
    
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
                                    self.time = 3
                                    self.countdown.toggle()
                                }
                            }
                        } else {
                            if self.user.regular == "promotion" {
                            Training(stars: 0, back: $back)
                            } else if self.user.regular == "prevention" {
                            Training(stars: 20, back: $back)
                            } else if self.user.regular == "neutral" {
                            Training(stars: 0, back: $back)
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
                            Gonogo(stars: 0, back: $back)
                            } else if self.user.regular == "prevention" {
                            Gonogo(stars: 20, back: $back)
                            } else if self.user.regular == "neutral" {
                            Gonogo(stars: 0, back: $back)
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
                    .padding()
                    .background(Color.white)
                    .cornerRadius(20)
                    Spacer()
                    NavigationLink(destination: Focus()) {
                        Text(self.user.regular)
                        .padding()
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
            self.newFocus(db: self.db, uid: self.user.uid)
        }
    }
    
    func logout() {
        do {
            try Auth.auth().signOut()
            self.user.uid = ""
            defaults.set("", forKey: "uid")
        } catch let error as NSError {
            self.error = error.localizedDescription
            self.invalid = true
        }
    }
    
    func newFocus(db: CollectionReference, uid: String) {
        db.document(uid).getDocument { (document, error) in
            if let document = document, document.exists {
                if document.get("focus") != nil {
                    self.user.regular = document.get("focus") as! String
                }
            } else {
                print("Document does not exist")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
