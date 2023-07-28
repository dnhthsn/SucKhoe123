//
//  DeleteChatDialog.swift
//  Messenger
//
//  Created by Đinh Thái Sơn on 01/03/2023.
//

import SwiftUI

struct CustomDeleteDialog: View {
    let title: String
    let description: String
    @Binding var shown : Bool
    @Binding var confirmDelete : Bool
    
    var body: some View {
        ZStack {
            VStack {
                Image("ic_recycle_bin")
                    .resizable()
                    .frame(width: 90, height: 90)
                    .padding(.top)
                
                Text(title)
                    .font(.title3)
                    .bold()
                
                Text(description)
                    .font(.caption)
                    .foregroundColor(.gray)
                    .frame(width: 200, alignment: .center)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: true, vertical: false)
                
                HStack {
                    Button(action: {
                        self.shown.toggle()
                        
                    }, label: {
                        Text(LocalizedStringKey("Label_No"))
                            .font(.headline)
                            .foregroundColor(Color(red: 23/255, green: 136/255, blue: 192/255))
                            .frame(width: 105, height: 50)
                            .background(Color(red: 223/255, green: 244/255, blue: 255/255))
                            .cornerRadius(30)
                            .padding()
                    })
                    
                    Button(action: {
                        self.shown.toggle()
                        self.confirmDelete = true
                    }, label: {
                        Text(LocalizedStringKey("Label_Delete"))
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(width: 105, height: 50)
                            .background(Color(red: 242/255, green: 99/255, blue: 113/255))
                            .cornerRadius(30)
                            .padding()
                    })
                }
            }
        }
        .background(.white)
        .cornerRadius(30)
    }
}

//struct DeleteChatDialog_Previews: PreviewProvider {
//    static var previews: some View {
//        DeleteChatDialog()
//    }
//}
