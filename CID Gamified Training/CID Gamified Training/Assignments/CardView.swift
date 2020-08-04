//
//  CardView.swift
//  CID Gamified Training
//
//  Created by Kyle Lui on 6/22/20.
//  Copyright © 2020 X-Force. All rights reserved.
//

import SwiftUI

/** View of individual cards in settings page. */
struct CardView: View {
    
    /** Name of vehicle folder. */
    var folder: String
    
    /** Background color. */
    var back: Color
    
    var body: some View {
        RoundedRectangle(cornerRadius: 40)
        .fill(back).frame(width: 175, height: 50).overlay(
            HStack {
                Image(uiImage: UIImage(imageLiteralResourceName: getImage()))
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 40, height: 40)
                Text(folder)
                Spacer()
            } .frame(width: 150, height: 40)
            .offset(x: 10)
        )
    }
    
    /** Retrieve image from folder name.
     Return:
        String representing the path to the image. */
    func getImage() -> String {
        let fm = FileManager.default
        let path = Bundle.main.resourcePath! + "/CID Images"
        var ret = ""
        do {
            let items = try fm.contentsOfDirectory(atPath: path + "/" +  self.folder)
            ret = path + "/" + self.folder + "/" + items[0]
        } catch {
            print("error")
        }
        return ret
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(folder: "AAV", back: Color.gray)
    }
}
