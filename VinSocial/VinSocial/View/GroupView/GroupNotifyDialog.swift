//
//  GroupNotifyDialog.swift
//  Suckhoe123
//
//  Created by Đinh Thái Sơn on 09/06/2023.
//

import SwiftUI

struct GroupNotifyDialog: View {
    @ObservedObject var viewModel: GroupViewModel
    var groupid: String
    let image: String
    let title: String
    let description: String
    let textButton1: String
    let textButton2: String
    @Binding var shown : Bool
    
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
                
                HStack(spacing: 5) {
                    Button(action: {
                        self.shown.toggle()
                    }, label: {
                        Text(textButton1)
                            .font(.headline)
                            .padding()
                            .foregroundColor(Color(red: 23/255, green: 136/255, blue: 192/255))
                            .frame(width: 100, height: 40)
                            .background(Color(red: 234/255, green: 240/255, blue: 255/255))
                            .cornerRadius(15)
                    })
                    
                    Button(action: {
                        self.shown.toggle()
                        viewModel.leaveGroup(act: "leave", groupid: groupid)
                        
                    }, label: {
                        Text(textButton2)
                            .font(.headline)
                            .padding()
                            .foregroundColor(.white)
                            .frame(width: 100, height: 40)
                            .background(Color(red: 242/255, green: 99/255, blue: 113/255))
                            .cornerRadius(15)
                    })
                }
            }
            .padding()
        }
        .frame(width: 250, height: 300)
        .overlay(
            RoundedRectangle(cornerRadius: 30)
                .stroke(Color.gray, lineWidth: 1)
                
        )
        .background(RoundedRectangle(cornerRadius: 30).fill(.white).shadow(radius: 10))
        .cornerRadius(30)
    }
}
