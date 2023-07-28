//
//  CustomDialog.swift
//  VinSocial
//
//  Created by Đinh Thái Sơn on 21/03/2023.
//

import SwiftUI

struct CustomDialog: View {
    let title: String
    let description: String
    @Binding var shown : Bool
    @Binding var confirm : Bool
    
    var body: some View {
        ZStack {
            VStack (spacing: 10) {
                Image("bird")
                    .resizable()
                    .frame(width: 90, height: 90)
                    .padding(.top)
                
                Text(title)
                    .font(.title3)
                    .bold()
                
                Text(description)
                    .font(.caption)
                    .foregroundColor(.gray)
                    .frame(width: 220, alignment: .center)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: true, vertical: false)
                
                HStack {
                    Button(action: {
                        self.shown.toggle()
                        self.confirm = false
                    }, label: {
                        Text(LocalizedStringKey("Label_Close"))
                            .font(.headline)
                            .foregroundColor(Color(red: 23/255, green: 136/255, blue: 192/255))
                            .frame(width: 120, height: 50)
                            .background(Color(red: 223/255, green: 244/255, blue: 255/255))
                            .cornerRadius(15)
                            .padding([.leading, .bottom, .top])
                            .padding(.trailing, 5)
                    })
                    
                    Button(action: {
                        self.shown.toggle()
                        self.confirm = true
                    }, label: {
                        Text(LocalizedStringKey("Label_Confirm"))
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(width: 120, height: 50)
                            .background(Color(red: 23/255, green: 136/255, blue: 192/255))
                            .cornerRadius(15)
                            .padding([.trailing, .bottom, .top])
                            .padding(.leading, 5)
                    })
                }
            }
        }
        .background(.white)
        .cornerRadius(30)
    }
}

//struct CustomDialog_Previews: PreviewProvider {
//    static var previews: some View {
//        CustomDialog()
//    }
//}
