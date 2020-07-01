//
//  ProgressBar.swift
//  CID Gamified Training
//
//  Created by Enya Xing on 6/19/20.
//  Copyright © 2020 Alex. All rights reserved.
//

import SwiftUI

struct ProgressBar: View {
    @Binding var value: Int
    var body: some View {
        let percent: Float = Float(self.value) / 20
        return GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle().frame(width: geometry.size.width , height: geometry.size.height)
                    .opacity(0.9)
                    .foregroundColor(Color.progressBarBackground)
                
                Rectangle().frame(width: min(CGFloat(percent) * geometry.size.width, geometry.size.width), height: geometry.size.height)
                    .foregroundColor(Color.friendlyGreen)
                    .animation(.linear)
                    .cornerRadius(5.0)
            }.cornerRadius(5.0)
        }
    }
}

//struct ProgressBarStyle: ViewModifier {
//    func body(content: Content) -> some View {
//        ProgressBar(value: Binding.constant(5))
//
//    }
//}

struct ProgressBar_Previews: PreviewProvider {
    static var previews: some View {
        ProgressBar(value: Binding.constant(5))
            .frame(height: 50.0)
    }
}
