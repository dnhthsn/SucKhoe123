//
//  CustomNotifyDialog.swift
//  VinSocial
//
//  Created by Đinh Thái Sơn on 22/03/2023.
//

import SwiftUI

struct CustomNotifyDialog2: View {
    let image: String
    let title: String
    let description: String
    let textButton1: String
    let textButton2: String
    @Binding var shown : Bool
    @Binding var action: Bool
    
    var body: some View {
        ZStack {
            VStack (spacing: 10) {
                Image(image)
                    .resizable()
                    .frame(width: 90, height: 90)
                    .padding(.top)
                
                Text(title)
                    .font(.title3)
                    .bold()
                
                Text(description)
                    .font(.system(size: 15))
                    .foregroundColor(.gray)
                    .frame(width: 220, alignment: .center)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: true, vertical: false)
                
                HStack {
                    Button(action: {
                        self.shown.toggle()
                    }, label: {
                        Text(textButton1)
                            .font(.headline)
                            .foregroundColor(Color(red: 23/255, green: 136/255, blue: 192/255))
                            .frame(width: 100, height: 40)
                            .background(Color(red: 234/255, green: 240/255, blue: 255/255))
                            .cornerRadius(15)
                            .padding(10)
                    })
                    
                    Button(action: {
                        self.shown.toggle()
                        self.action.toggle()
                    }, label: {
                        Text(textButton2)
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(width: 100, height: 40)
                            .background(Color(red: 23/255, green: 136/255, blue: 192/255))
                            .cornerRadius(15)
                            .padding(10)
                    })
                }
            }
            .padding()
        }
        .background(.white)
        .cornerRadius(30)
    }
}
