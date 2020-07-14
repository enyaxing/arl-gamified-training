//
//  Profile.swift
//  CID Gamified Training
//
//  Created by Alex on 6/22/20.
//  Copyright © 2020 Alex. All rights reserved.
//

import SwiftUI
import Firebase
import SwiftUICharts

/** Profile view for signed in user. */
struct Profile: View {
    
    /** UID of the user. */
    var uid: String

    /** Connection to firebase user collection. */
    let db = Firestore.firestore().collection("users")
    
    /** Reference to global user variable. */
    @EnvironmentObject var user: GlobalUser

    @State var prevSessionIds: [String] = []
    @State var prevSessions: [String: Session] = [:]
    @State var answers: [Answer] = []
    
    /** Name of the user. */
    @State var name = "test"
    
    /** Email of the user. */
    @State var email = "test"

    let endTimestamp = Timestamp()
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
                    HStack{
                        Text("Statistics")
                        .font(.headingFont)
                        NavigationLink(destination: StatDetail(prevSessions: self.prevSessionIds)){
                            Text("Details")
                        }
                    }
                    
                    HStack {
                        // Placeholder stats for now
                        StatBox(img_name: "coin", title: "\(self.user.totalSessions)", description: "sessions completed")
                        StatBox(img_name: "time", title: "\(format_time_interval(second: self.user.totalTime))", description: "time trained")
                    }
                    
                    HStack {
                        StatBox(img_name: "stopwatch", title: "\(String(format: "%.2f", self.user.avgResponseTime))s", description: "avg response time")
                        StatBox(img_name: "accuracy", title: "\(String(format: "%.2f", self.user.accuracy))%", description: "accuracy")
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
                            Text("\(self.prevSessions[sess]!.type)")
                            Spacer()
                            // Placeholder
                            Text("\(self.prevSessions[sess]!.points)")
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

    /** Gets list of sessions for this user from firebase. */
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
                    let type: String = document.get("type") as! String
                    self.prevSessions[document.documentID] = Session(points: points, timestamp: t, type: type)
                }
                self.prevSessionIds = ret.reversed()
            }
        }
    }

    /** Obtain user name and email from firebase. */
    func setHeader(doc: DocumentReference){
        doc.getDocument { (document, error) in
            if let document = document, document.exists {
                if document.get("name") != nil {
                    self.name = document.get("name") as! String
                }
                if document.get("user") != nil {
                    self.email = document.get("user") as! String
                }
                
                if document.get("totalTime") != nil {
                    self.user.totalTime = document.get("totalTime") as! TimeInterval
                }
                
                if document.get("avgResponseRate") != nil {
                    self.user.avgResponseTime = document.get("avgResponseRate") as! Double
                }
                
                if document.get("totalSessions") != nil {
                    self.user.totalSessions = document.get("totalSessions") as! Int
                }
                
                if document.get("accuracy") != nil {
                    self.user.accuracy = document.get("accuracy") as! Double
                }
            } else {
                print("Document does not exist")
            }
        }
    }

}

func format_time_interval(second: TimeInterval) -> String {
    let formatter = DateComponentsFormatter()
    formatter.unitsStyle = .positional
    formatter.allowedUnits = [.hour, .minute, .second]
    return formatter.string(from: second) ?? "0"
}

struct Profile_Previews: PreviewProvider {
    static var previews: some View {
        Profile(uid: "").environmentObject(GlobalUser())
    }
}
