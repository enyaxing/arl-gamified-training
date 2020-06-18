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
    
    @State var regular = "None"
    
    @State var back = false
    
    @Binding var show: Bool
    
    @State var error = ""
    
    @State var invalid = false
    
    @Binding var uid: String
    
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
                
                NavigationLink(destination: Question(curResponse: 0, regular: $regular, uid: $uid)) {
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
                        if self.regular == "promotion" {
                            Countdown(back: $back, playing: Binding.constant(true))
//                            Training(back: $back)
                        } else if self.regular == "prevention" {
                             Countdown(back: $back, playing: Binding.constant(true))
//                            TrainingPrevention(back: $back)
                        } else if self.regular == "equal" {
                            Countdown(back: $back, playing: Binding.constant(true))
//                            TrainingNeutral(back: $back)
                        } else {
                            Rejection()
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
                        if self.regular == "promotion" {
                            Gonogo(back: $back)
                        } else if self.regular == "prevention" {
                            GonogoPrevention(back: $back)
                        } else if self.regular == "equal" {
                            GonogoNeutral(back: $back)
                        }
                        else {
                            Rejection()
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
                    NavigationLink(destination: Focus(regular: $regular, uid: $uid)) {
                        Text(self.regular)
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
            self.newFocus(db: self.db, uid: self.uid)
        }
    }
    
    func logout() {
        do {
            try Auth.auth().signOut()
            self.show = false
        } catch let error as NSError {
            self.error = error.localizedDescription
            self.invalid = true
        }
    }
    
    func newFocus(db: CollectionReference, uid: String) {
        db.document(uid).getDocument { (document, error) in
            if let document = document, document.exists {
                if document.get("focus") != nil {
                    self.regular = document.get("focus") as! String
                }
            } else {
                print("Document does not exist")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(show: Binding.constant(true), uid: Binding.constant(""))
    }
}
