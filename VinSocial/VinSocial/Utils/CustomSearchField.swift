//
//  CustomSearchField.swift
//  Messenger
//
//  Created by Đinh Thái Sơn on 21/02/2023.
//

import SwiftUI

struct CustomSearchField:View{
    let imageName: String
    let placeholderText:String
    let isSecureField: Bool
    @Binding var text: String
    var body: some View{
        VStack{
            HStack{
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30,height: 30)
                    .foregroundColor(Color.gray)
                    .padding(.horizontal,10)
                
                if(isSecureField){
                    SecureField(placeholderText, text: $text)
                        .foregroundColor(.gray)
                        .padding([.top, .bottom], 10)
                }else{
                    TextField(placeholderText, text: $text)
                        .foregroundColor(.gray)
                        .padding([.top, .bottom], 10)
                }
               
            }.overlay(
                RoundedRectangle(cornerRadius: 30)
                    .stroke(Color.secondary.opacity(0.5), lineWidth: 2)
                    
            ).background(RoundedRectangle(cornerRadius: 30).fill(.white))
        }
    }
}

