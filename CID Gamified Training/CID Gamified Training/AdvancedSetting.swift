//
//  AdvancedSetting.swift
//  CID Gamified Training
//
//  Created by Alex on 7/16/20.
//  Copyright © 2020 Alex. All rights reserved.
//

import SwiftUI

struct AdvancedSetting: View {
    
    @Binding var accuracy: Int
    @Binding var time: Int
    
    var body: some View {
        VStack {
            Picker(selection: $accuracy, label: Text("Accuracy:")) {
                ForEach(Array(stride(from: 0, to: 105, by: 5)), id: \.self) { index in
                    Text("\(index)%").tag(index).id(UUID())
                }
            }
            Picker(selection: $time, label: Text("Time:")) {
                ForEach(Array(stride(from: 10, to: 305, by: 5)), id: \.self) { index in
                    Text("\(index) s").tag(index).id(UUID())
                }
            }
        }
    }
}

struct AdvancedSetting_Previews: PreviewProvider {
    static var previews: some View {
        AdvancedSetting(accuracy: Binding.constant(0), time: Binding.constant(60))
    }
}
