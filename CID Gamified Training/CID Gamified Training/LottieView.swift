//
//  LottieView.swift
//  CID Gamified Training
//
//  Created by Christine Lou on 6/10/20.
//  Copyright © 2020 Alex. All rights reserved.
//

import SwiftUI
import Lottie

struct LottieView: UIViewRepresentable {
    typealias UIViewType = UIView
    var filename: String
    @Binding var playing: Bool
    
    func makeUIView(context:   UIViewRepresentableContext<LottieView>) -> UIView{
            let view = UIView(frame: .zero)
            let animationView = AnimationView()
            let animation = Animation.named(filename)
            animationView.animation = animation
            animationView.contentMode = .scaleAspectFit
        animationView.play { (finished) in
            Thread.sleep(forTimeInterval: 0.5)
            self.playing = false
        }
            
            animationView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(animationView)
            NSLayoutConstraint.activate([
                animationView.widthAnchor.constraint(equalTo: view.widthAnchor),
                animationView.heightAnchor.constraint(equalTo: view.heightAnchor)
            ])
            return view
        }
    
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<LottieView>) {
        
    }
}
