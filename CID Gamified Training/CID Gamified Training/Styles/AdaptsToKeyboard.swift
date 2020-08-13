//
//  AdaptsToKeyboard.swift
//  CID Gamified Training
//
//  Created by Enya Xing on 7/30/20.
//  Copyright © 2020 Alex. All rights reserved.
//

import SwiftUI
import Combine

/** Allows button at the bottom of the screen to bump up in response to open keyboard. */ 
struct AdaptsToKeyboard: ViewModifier {
    @State var currentHeight: CGFloat = 0

    func body(content: Content) -> some View {
        content
            .padding(.bottom, self.currentHeight)
            .animation(.easeOut(duration: 0.16))
            .onAppear(perform: {
                NotificationCenter.Publisher(center: NotificationCenter.default, name: UIResponder.keyboardWillShowNotification)
                    .merge(with: NotificationCenter.Publisher(center: NotificationCenter.default, name: UIResponder.keyboardWillChangeFrameNotification))
                    .compactMap { notification in
                        notification.userInfo?["UIKeyboardFrameEndUserInfoKey"] as? CGRect
                }
                .map { rect in
                    rect.height
                }
                .subscribe(Subscribers.Assign(object: self, keyPath: \.currentHeight))

                NotificationCenter.Publisher(center: NotificationCenter.default, name: UIResponder.keyboardWillHideNotification)
                    .compactMap { notification in
                        CGFloat.zero
                }
                .subscribe(Subscribers.Assign(object: self, keyPath: \.currentHeight))
            })
    }
}
