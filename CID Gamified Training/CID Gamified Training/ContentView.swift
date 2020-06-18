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
                            Training(stars: 0, back: $back, type: $regular)
                        } else if self.regular == "prevention" {
                            Training(stars: 20, back: $back, type: $regular)
                        } else if self.regular == "neutral" {
                            TrainingNeutral(back: $back, type: $regular)
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
                            Gonogo(stars: 0, back: $back, type: $regular)
                        } else if self.regular == "prevention" {
                            Gonogo(stars: 20, back: $back, type: $regular)
                        } else if self.regular == "neutral" {
                            GonogoNeutral(back: $back, type: $regular)
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
            self.uid = ""
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
        ContentView(uid: Binding.constant(""))
    }
}
