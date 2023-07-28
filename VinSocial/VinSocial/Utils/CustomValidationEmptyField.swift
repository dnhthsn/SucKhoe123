//
//  CustomValidationField.swift
//  Messenger
//
//  Created by Đinh Thái Sơn on 20/02/2023.
//

import SwiftUI

struct CustomValidationEmptyField:View{
    var imageName: String
    var validateText: String
    @Binding var text: String
    var body: some View{
//        if check {
            
        
        if (!text.isEmpty) {
                
            VStack {
                HStack{
                    Image(imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20,height: 20)
                        .foregroundColor(Color.gray)
                        .padding([.top, .leading, .bottom])
                    Text(LocalizedStringKey(validateText))
                        .foregroundColor(Color.gray)
                        .padding([.top, .trailing, .bottom])
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(Color(red: 253/255, green: 237/255, blue: 239/255), lineWidth: 2)
                        
                )
                .background(RoundedRectangle(cornerRadius: 6).fill(Color(red: 253/255, green: 237/255, blue: 239/255)))
            }
        }
//        }
        
    }
}
