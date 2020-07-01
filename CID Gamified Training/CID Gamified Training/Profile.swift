//
//  Profile.swift
//  CID Gamified Training
//
//  Created by Alex on 6/22/20.
//  Copyright © 2020 Alex. All rights reserved.
//

import SwiftUI
import Firebase

struct Profile: View {

    /** Reference to global user variable. */
    //@EnvironmentObject var user: GlobalUser

    var uid: String

    /** Connection to firebase user collection. */
    let db = Firestore.firestore().collection("users")

    @State var prevSessionIds: [String] = []
    @State var prevSessions: [String: Session] = [:]
    @State var answers: [Answer] = []
    @State var name = "test"
    @State var email = "test"

    let dateFormatter = DateFormatter()


    var body: some View {
        dateFormatter.dateFormat = "HH:mm dd MMM yy"

        return ScrollView {
            VStack {
                HStack(alignment: .center) {
                    VStack(alignment: .leading) {
                       Text(name)
                           .font(.headingFont)
                       HStack(alignment: .center){
                           Image("mail").resizable().frame(width: 24, height: 24)
                           Text(email)
                               .font(.bodyFontSmall)
                       }
                    }
                    Spacer()
                    Image("pfp-default").resizable().frame(width: 50, height: 50)
                }
                .padding()
                .frame(maxWidth: .infinity)
               
                Divider()
                
                VStack(alignment: .leading){
                    Text("Statistics")
                        .font(.headingFont)
                    HStack {
                        // Placeholder stats for now
                        StatBox(img_name: "coin", title: "1549", description: "avg points")
                        StatBox(img_name: "time", title: "97", description: "minutes trained")
                    }
                    
                    HStack {
                        StatBox(img_name: "stopwatch", title: ".25s", description: "avg response time")
                    }
                }
                .padding(.top)
                Text("Previous Sessions:")
                    .font(.headingFont)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 30)
                    .padding(.horizontal)
                ForEach(self.prevSessionIds, id: \.self) {sess in
                    NavigationLink(destination: Summary(answers: self.answers, sess: sess, countdown:Binding.constant(false), uid: self.uid, session: self.prevSessions[sess]!)){
                        HStack {
                            Text("\(self.dateFormatter.string(for: self.prevSessions[sess]?.timestamp.dateValue()) ?? "Unknown date")")
                                
                            Spacer()
                            // Placeholder
                            Text("TRAINING")
                            Spacer()
                            // Placeholder
                            Text("1603 pts")
                            Spacer()
                            Image("navigate_next").resizable().frame(width: 24, height: 24)
                        }
                        .foregroundColor(.black)
                        
                    }
                
                    .frame(maxWidth: UIScreen.screenWidth)
                    .frame(height: UIScreen.screenHeight / 30, alignment: .leading)
                    .padding(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10.0)
                            .stroke(Color.outlineGray, lineWidth: 2)
                            .shadow(color: Color.outlineGray, radius: 0, x: 0, y: 2)
                            
                    )
                }
                .padding(.horizontal)
                .padding(.vertical, 2)
                
                
                Spacer()
            }.onAppear{
                self.setHeader(doc: self.db.document(self.uid))
                self.getSessions(db: self.db.document(self.uid).collection("sessions"))
            }
        }
    }

    func getSessions(db: CollectionReference) {
        var ret: [String] = []
        db.getDocuments() {(query, err) in
            if err != nil {
                print("Error getting docs.")
            } else {
                for document in query!.documents {
                    ret.append(document.documentID)
                    let t: Timestamp = document.get("time") as! Timestamp
                    let points: Int = document.get("points") as! Int
                    self.prevSessions[document.documentID] = Session(points: points, timestamp: t)
                }
                self.prevSessionIds = ret.reversed()
            }
        }
    }

    /** Obtain field value from firebase user. */
    func setHeader(doc: DocumentReference){
        doc.getDocument { (document, error) in
            if let document = document, document.exists {
                if document.get("name") != nil {
                    self.name = document.get("name") as! String
                }
                if document.get("user") != nil {
                    self.email = document.get("user") as! String
                }
            } else {
                print("Document does not exist")
            }
        }
    }

}

struct Profile_Previews: PreviewProvider {
    static var previews: some View {
        Profile(uid: "").environmentObject(GlobalUser())
    }
}
