//
//  TopDoctorView.swift
//  Suckhoe123
//
//  Created by Đinh Thái Sơn on 23/05/2023.
//

import SwiftUI

struct TopDoctorView: View {
    @ObservedObject var viewModel: BeautyViewModel
    @Environment(\.dismiss) var dismiss
    var topDoctors: [TopDoctor]
    @State var columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    dismiss()
                } label: {
                    Image("ic_back_arrow")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 26, height: 26)
                        .foregroundColor(Color.black)
                }
                
                Text("Top bác sĩ thẩm mỹ")
                    .foregroundColor(Color.black)
                    .font(.system(size: 20, weight: .bold))
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                
            }
            .padding([.leading, .trailing], 20)
            
            Rectangle().fill(Color(red: 0.957, green: 0.957, blue: 0.957)).frame(height: 4)
            
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(topDoctors) { topDoctor in
                        TopDoctorCell(viewModel: viewModel, topDoctor: topDoctor)
                    }
                }
            }
            .padding([.leading, .trailing], 20)
        }
        .gesture(
            DragGesture()
                .onEnded { gesture in
                    if gesture.translation.width > 100 {
                        dismiss()
                    }
                }
        )
    }
}
