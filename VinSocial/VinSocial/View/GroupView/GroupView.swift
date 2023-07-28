//
//  GroupView.swift
//  Suckhoe123
//
//  Created by Đinh Thái Sơn on 09/05/2023.
//

import SwiftUI

struct GroupView: View {
    @EnvironmentObject var viewModel: HomeViewModel
    @State var searchText: String = ""
    @State var showManageGroup = false
    @ObservedObject var groupViewModel: GroupViewModel
    
    @FocusState private var isKeyboardShowing: Bool
    
    var body: some View {
        VStack {
            VStack {
                
                HStack {
                    Text(LocalizedStringKey("Label_Group"))
                        .font(.system(size: 30, weight: .bold))
                        .foregroundColor(Color.black)
                        .padding(.trailing)
                    
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
                       
                    }
                    .overlay(
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
                    
                    Button(action: {
                        showManageGroup.toggle()
                    }, label: {
                        Image("ic_settings")
                            .frame(width: 60, height: 60)
                            .foregroundColor(Color(red: 102/255, green: 102/255, blue: 102/255))
                    })
                    .fullScreenCover(isPresented: $showManageGroup, content: {
                        if AuthenViewModel.shared.currentUser == nil {
                            ViewWithouLogin(actionBack: true).environmentObject(AuthenViewModel()).environmentObject(HomeViewModel())
                                .ignoresSafeArea(.all, edges: .top)
                        } else {
                            ManageGroupView(viewModel: groupViewModel)
                        }
                    })

                }
                .padding(.leading, 20)
                .padding(.trailing, 10)
                
                if (groupViewModel.allNewFeeds.isEmpty) {
                    Spacer()
                    
                    Text("Hiện chưa có bài đăng nào")
                        .foregroundColor(Color(red: 23/255, green: 136/255, blue: 192/255))
                    
                    Spacer()
                }else{
                    
                    GroupNewFeedView(viewModel: groupViewModel, groupid: "", isAllNewFeed: true, isSearching: false, showType: TypeShowScreen.HOME)
                }
            }
        }
        .padding(.top, 60)
        .onAppear {
            groupViewModel.loadDataAllNewFeed(act: "newfeed")
        }
        .onDisappear {
            groupViewModel.removeCacheAllNewFeed()
        }
    }
}
