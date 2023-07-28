//
//  AddMemberView.swift
//  Messenger
//
//  Created by Đinh Thái Sơn on 28/02/2023.
//

import SwiftUI

struct AddMemberView: View {
    @Environment(\.dismiss) var dismiss
    @State var searchText: String = ""
    
    // nếu isCreate group = true -> đi từ màn create group -> add member
    //nếu isCreate group = false -> profile group -> thêm người vào group
    @State var isCreateGroup: Bool = false
    @EnvironmentObject var viewModel: MainTabViewModel
    @Environment(\.presentationMode) var presentationMode
    @Binding var isActiveViewAddMember : Bool
    @FocusState private var isKeyboardShowing: Bool
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Text(LocalizedStringKey("Label_Cancel"))
                        .foregroundColor(.blue)
                        .onTapGesture {
                            dismiss()
                        }
                    
                    Text(LocalizedStringKey("Label_Add_Member"))
                        .frame(maxWidth: .infinity, alignment: .center)
                        .font(.title2)
                    
                    if isCreateGroup {
                      
                    }else{
                        // add member vào group
                       
                    }
                 
                   
                    

                }
                
                HStack{
                    Image("ic_search")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30,height: 30)
                        .foregroundColor(Color.gray)
                        .padding(.horizontal,10)

                    TextField("", text: $searchText)
                        .placeholder(when: searchText.isEmpty) {
                            Text(String(localized: "Placeholder_Search_Contact"))
                                .foregroundColor(Color(red: 158/255, green: 158/255, blue: 158/255))
                        }
                        .foregroundColor(.black)
                        .padding([.top, .bottom], 10)
                        .focused($isKeyboardShowing)
                    
                    if !searchText.isEmpty {
                        Image("ic_clear")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .padding(.horizontal,10)
                            .onTapGesture {
                                searchText = ""
                            }
                    }
                   
                }.overlay(
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(Color(red: 158/255, green: 158/255, blue: 158/255), lineWidth: 1)
                        
                ).background(RoundedRectangle(cornerRadius: 30).fill(.white))
                
                HStack {
                    if searchText != "" {
                      
                        
                    } else {
                        Text(LocalizedStringKey("Label_Recomend"))
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Text("")
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                    
                }
                
                Divider()
                
                ScrollView {
                    LazyVStack{
                       
                    }
                    
                   
                }.tag(0)
                
                Spacer()
            }
            .padding([.leading, .trailing], 20)
            .toolbar {
                ToolbarItem(placement: .keyboard) {
                    Button(LocalizedStringKey("Label_Cancel")){
                        isKeyboardShowing.toggle()
                    }
                    .frame(maxWidth: .infinity,alignment: .trailing)
                }
            }
            .background(Color.white)
        }
        .background(Color.white)
        .navigationBarBackButtonHidden(true)
        
    }
}

//struct AddMemberView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddMemberView()
//    }
//}
