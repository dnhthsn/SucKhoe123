//
//  GroupChatNameView.swift
//  Messenger
//
//  Created by Đinh Thái Sơn on 28/02/2023.
//

import SwiftUI

struct GroupChatNameView: View {
    @State var groupChatName: String = ""
    @State var userSelected : [UserObject]
    @State var showChatView = false
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel  = GroupChatNameViewModel()
    @Binding var isActiveViewAddMember : Bool
    var body: some View {
      
            ZStack{
                VStack {
                    TextField("" ,text: $groupChatName)
                        .placeholder(when: groupChatName.isEmpty) {
                            Text(LocalizedStringKey("Placeholder_Type_Name_Group"))
                                .foregroundColor(.blue)
                        }
                        .foregroundColor(.blue)
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(Color(red: 223/255, green: 244/255, blue: 255/255), lineWidth: 2)
                                
                        ).background(RoundedRectangle(cornerRadius: 6).fill(Color(red: 223/255, green: 244/255, blue: 255/255)))
                    
                    Text(LocalizedStringKey("Label_Member_Count"))
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    ScrollView {
                        LazyVStack{
                                ForEach(userSelected) { user in
                                    MemberCell(user: user,isCreateGroup: true)
                                }
                        }
                        
                    }.tag(0)
                    
                    Spacer()
                    
                    
                   
                }
                .navigationViewStyle(.stack)
                .navigationTitle(LocalizedStringKey("Label_Group_Chat_Name"))
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarItems(trailing:  Button {
        
                            } label: {
                                Text(LocalizedStringKey("Label_Create_Group")).foregroundColor(.blue)
                            })
                if(viewModel.isCreateGroup){
                    ProgressView()
                }
                
                
            }
            .padding(.vertical)
            .padding([.leading, .trailing], 20)
            .background(Color.white)
        

        
       
    }
}

//struct GroupChatNameView_Previews: PreviewProvider {
//    static var previews: some View {
//        GroupChatNameView()
//    }
//}

