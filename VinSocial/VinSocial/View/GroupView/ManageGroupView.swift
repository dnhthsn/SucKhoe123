//
//  ManageGroupView.swift
//  Suckhoe123
//
//  Created by Đinh Thái Sơn on 09/05/2023.
//

import SwiftUI

struct ManageGroupView: View {
    @Environment(\.dismiss) var dismiss
    @State var searchText: String = ""
    @ObservedObject var viewModel: GroupViewModel
    
    @FocusState private var isKeyboardShowing: Bool
    
    @State var isCreateGroup:Bool = false
    
    var body: some View {
        NavigationView(content: {
            VStack {
                HStack {
                    Image("ic_back_arrow")
                        .resizable()
                        .frame(width: 26, height: 26)
                        .foregroundColor(Color.black)
                        .onTapGesture {
                            dismiss()
                            viewModel.removeCacheGroup()
                        }
                    
                    Text(LocalizedStringKey("Label_Manage_Group"))
                        .foregroundColor(Color.black)
                        .font(.system(size: 25, weight: .bold))
                        .frame(maxWidth: .infinity, alignment: .leading)
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
                            Text(String(localized: "Label_Search"))
                                .foregroundColor(Color(red: 158/255, green: 158/255, blue: 158/255))
                        }
                        .focused($isKeyboardShowing)
                        .padding([.top, .bottom], 10)
                        .onChange(of: searchText) { newValue in
                            //send typing in here
                            let newLength = newValue.count
                            if newLength > 2 {
                                //viewModel.searchFeed(keyword: newValue, mod: "video")
                            }else{
                                //viewModel.clearSearch()
                            }
                            
                        }
                    
                    if !searchText.isEmpty {
                        Image("ic_clear")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .padding(.horizontal, 10)
                            .onTapGesture {
                                searchText = ""
                            }
                    }
                   
                }.overlay(
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(Color(red: 158/255, green: 158/255, blue: 158/255), lineWidth: 1)
                        
                ).background(RoundedRectangle(cornerRadius: 30).fill(.white))
                    .toolbar {
                        ToolbarItem(placement: .keyboard) {
                            Button(LocalizedStringKey("Label_Cancel")){
                                isKeyboardShowing.toggle()
                            }
                            .frame(maxWidth: .infinity,alignment: .trailing)
                        }
                    }
                
                HStack {
                    NavigationLink(destination:  CreateGroupView(viewModel: viewModel,isCreateGroup:$isCreateGroup), isActive: $isCreateGroup) {
                        Image("ic_add_group")
                            .frame(width: 50, height: 50)
                            .onTapGesture{
                                isCreateGroup.toggle()
                            }
                    }

                    Text(LocalizedStringKey("Label_Create_Group"))
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(5)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color(red: 244/255, green: 244/255, blue: 244/255), lineWidth: 1)
                        
                )
                .background(RoundedRectangle(cornerRadius: 10).fill(Color(red: 244/255, green: 244/255, blue: 244/255)))
                .padding(.top)
                
                ScrollView {
                    VStack {
                        GroupListView(viewModel: viewModel, groupType: 3)
                        
                        GroupListView(viewModel: viewModel, groupType: 1)
                        
                        GroupListView(viewModel: viewModel, groupType: 2)
                    }
                }
                Spacer()
            }
            .padding([.leading, .trailing], 20)
            .gesture(
                DragGesture()
                    .onEnded { gesture in
                        if gesture.translation.width > 100 {
                            dismiss()
                        }
                    }
            )
        })
        .navigationBarBackButtonHidden(true)
    }
}
