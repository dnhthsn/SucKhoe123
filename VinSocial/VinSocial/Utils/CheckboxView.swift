//
//  CheckboxView.swift
//  Messenger
//
//  Created by Đinh Thái Sơn on 10/02/2023.
//

import Foundation
import SwiftUI

struct CheckBoxView: ToggleStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        Button {
            configuration.isOn.toggle()
        } label: {
            Image(configuration.isOn ? "ic_check_on" : "ic_check_off")
                .resizable()
                .frame(width: 18, height: 18)
        }
    }
    
}
