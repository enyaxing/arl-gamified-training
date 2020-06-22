//
//  CardView.swift
//  CID Gamified Training
//
//  Created by Alex on 6/22/20.
//  Copyright © 2020 Alex. All rights reserved.
//

import SwiftUI

struct CardView: View {
    
    var folder: String
    
    var body: some View {
        HStack {
        Image(uiImage: UIImage(imageLiteralResourceName: getImage()))
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(width: 40, height: 40)
        Text(folder)
        Spacer()
        } .frame(width: 150, height: 40)
        .background(Color.gray)
    }
    
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
        CardView(folder: "AAV")
    }
}
