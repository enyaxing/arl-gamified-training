//
//  ButtonStyle.swift
//  CID Gamified Training
//
//  Created by Enya Xing on 6/19/20.
//  Copyright © 2020 Alex. All rights reserved.
//

import Foundation
import SwiftUI

struct FriendlyButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
          .frame(width: 150, height: 55, alignment: .center)
          .font(Font.actionButtonFont)
          .foregroundColor(.white)
          .background(Color.friendlyGreen)
          .cornerRadius(10.0)
          .shadow(color: Color.friendlyGreenShadow, radius: 0, x: 0, y: 4)
    }
}


struct EnemyButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
          .frame(width: 150, height: 55, alignment: .center)
          .font(Font.actionButtonFont)
          .foregroundColor(.white)
          .background(Color.enemyRed)
          .cornerRadius(10.0)
          .shadow(color: Color.enemyRedShadow, radius: 0, x: 0, y: 4)
  }
}

