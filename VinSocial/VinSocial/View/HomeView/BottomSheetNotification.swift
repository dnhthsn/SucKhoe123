//
//  SwiftUIView.swift
//  Messenger
//
//  Created by Đinh Thái Sơn on 28/02/2023.
//

import SwiftUI

struct BottomSheetNotification: View {
    //@State var actionDelete: Bool = false
    @Binding var actionDelete : Bool
    @Binding var confirmDelete: Bool
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            VStack(spacing: 15) {
                HStack {
                    Image("ic_mark_as_read")
                        .resizable()
                        .frame(width: 35, height: 25)
                    
                    Text(LocalizedStringKey("Label_Mark_All_As_Read"))
                        .font(.title3)
                        .padding(.leading, 10)
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                HStack {
                    Image("ic_red_delete_chat")
                        .resizable()
                        .frame(width: 35, height: 35)
                    
                    Text(LocalizedStringKey("Label_Delete_All"))
                        .font(.title3)
                        .padding(.leading, 10)
                        .foregroundColor(Color(red: 239/255, green: 60/255, blue: 77/255))
                        .frame(maxWidth: .infinity, alignment: .leading)
                }.onTapGesture {
                    actionDelete.toggle()
                    dismiss()
                }
                
                
                
                Spacer()
            }
            .padding(20)
            .padding(.top, 40)
            .background(Color.white)
        }
        .shadow(radius: 20)
        .background(Color.white)
        .cornerRadius(40)
    }
}
