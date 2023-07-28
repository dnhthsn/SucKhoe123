//
//  CustomPasswordField.swift
//  Messenger
//
//  Created by Đinh Thái Sơn on 17/02/2023.
//

import SwiftUI

struct CustomPasswordField:View{
    let imageName: String
    let placeholderText:String
    @State private var isSecureField: Bool = true
    @Binding var text: String
    var body: some View{
        VStack{
            HStack{
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24,height: 24)
                    .foregroundColor(Color.gray)
                    .padding(.leading, 10)
                    .padding(.trailing, 5)
                Divider().frame(height: 20)
                if(isSecureField){
                    SecureField("", text: $text)
                        .accentColor(.black)
                        .placeholder(when: text.isEmpty) {
                            Text(placeholderText)
                                .foregroundColor(Color(red: 158/255, green: 158/255, blue: 158/255))
                        }
                        .foregroundColor(.gray)
                        .padding()
                }else{
                    TextField("", text: $text)
                        .accentColor(.black)
                        .placeholder(when: text.isEmpty) {
                            Text(placeholderText)
                                .foregroundColor(Color(red: 158/255, green: 158/255, blue: 158/255))
                        }
                        .foregroundColor(.gray)
                        .padding()
                }
                
                Button(action: {
                    isSecureField.toggle()
                }) {
                    Image(systemName: self.isSecureField ? "eye.slash" : "eye")
                        .foregroundColor(Color.gray)
                        .padding()
                }
               
            }.overlay(
                RoundedRectangle(cornerRadius: 6)
                    .stroke(Color(red: 158/255, green: 158/255, blue: 158/255), lineWidth: 1)
                    
            ).background(RoundedRectangle(cornerRadius: 6).fill(.white))
        }
    }
}

