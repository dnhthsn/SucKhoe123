//
//  CustomTextField.swift
//  Messenger
//
//  Created by Stealer Of Souls on 2/7/23.
//

import SwiftUI

struct CustomTextField:View{
    let imageName: String
    let placeholderText:String
    let isSecureField: Bool
    @Binding var text: String
    
    @FocusState private var isKeyboardShowing: Bool
    
    var body: some View{
        VStack{
            HStack{
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 16,height: 20)
                    .foregroundColor(Color.gray)
                    .padding(.horizontal,10)
                Divider().frame(height: 20)
                if(isSecureField){
                    SecureField("", text: $text)
                        .accentColor(.black)
                        .foregroundColor(Color.black)
                        .placeholder(when: text.isEmpty) {
                            Text(placeholderText)
                                .foregroundColor(Color(red: 158/255, green: 158/255, blue: 158/255))
                        }
                        .padding()
                }else{
                    TextField("", text: $text)
                        .accentColor(.black)
                        .foregroundColor(Color.black)
                        .placeholder(when: text.isEmpty) {
                            Text(placeholderText)
                                .foregroundColor(Color(red: 158/255, green: 158/255, blue: 158/255))
                        }
                        .padding()
                }
               
            }
            .overlay(
                RoundedRectangle(cornerRadius: 6)
                    .stroke(Color(red: 158/255, green: 158/255, blue: 158/255), lineWidth: 1)
                    
            )
            .background(RoundedRectangle(cornerRadius: 6).fill(.white))
        }
    }
}
