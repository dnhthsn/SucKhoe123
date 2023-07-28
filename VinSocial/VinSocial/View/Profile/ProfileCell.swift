//
//  ProfileCell.swift
//  Messenger
//
//  Created by Đinh Thái Sơn on 27/02/2023.
//

import Foundation
import SwiftUI

struct ProfileCell: View {
    let viewModel: SettingsCellViewModel
    
    var body: some View {
        VStack {
            Image(systemName: viewModel.imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 22, height: 22)
                .padding(6)
                .background(viewModel.backgroundColor)
                .foregroundColor(.white)
                .cornerRadius(6)
            
            Text(viewModel.title)
                .font(.system(size: 15))
            
            Spacer()
                            
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding([.top, .horizontal])
    }
}
