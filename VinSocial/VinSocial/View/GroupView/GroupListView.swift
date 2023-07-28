//
//  GroupListView.swift
//  Suckhoe123
//
//  Created by Đinh Thái Sơn on 05/06/2023.
//

import SwiftUI

struct GroupListView: View {
    @ObservedObject var viewModel: GroupViewModel
    var groupType: Int

    @State var invitations: [GroupList] = []
    @State var yourGroups: [GroupList] = []
    @State var followedGroups: [GroupList] = []
    
    var body: some View {
        LazyVStack {
            LazyVStack {
                HStack {
                    if groupType == 1 {
                        Text(LocalizedStringKey("Label_Your_Group"))
                            .font(.system(size: 20, weight: .bold))
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Text("\(yourGroups.count)")
                            .font(.system(size: 20))
                            .foregroundColor(.blue)
                    } else if groupType == 3 {
                        Text(LocalizedStringKey("Label_Invitation"))
                            .font(.system(size: 20, weight: .bold))
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Text("\(invitations.count)")
                            .font(.system(size: 20))
                            .foregroundColor(.blue)
                    } else if groupType == 2 {
                        Text(LocalizedStringKey("Label_Followed_Group"))
                            .font(.system(size: 20, weight: .bold))
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Text("\(followedGroups.count)")
                            .font(.system(size: 20))
                            .foregroundColor(.blue)
                    }
                }
                
                Divider()
                
                if groupType == 1 {
                    ScrollView {
                        LazyVStack {
                            ForEach(yourGroups) { group in
                                if group.groupid == viewModel.groupList.last?.groupid {
                                    
                                    GroupCell(viewModel: viewModel, groupList: group)
                                        .task {
                                            await viewModel.loadNextPageGroup(act: "groupList", groupby: groupType) { group in
                                                self.yourGroups = group
                                            }
                                        }
                                        .padding(5)
                                    
//                                    if viewModel.isFetchingNextPageGroup {
//                                        bottomProgressView
//                                    }
                                    
                                } else {
                                    
                                    GroupCell(viewModel: viewModel, groupList: group)
                                        .padding(5)
                                }
                            }
                        }
                    }
                    
                } else if groupType == 2 {
                    ScrollView {
                        LazyVStack {
                            ForEach(followedGroups) { group in
                                if group.groupid == viewModel.groupList.last?.groupid {
                                    
                                    GroupCell(viewModel: viewModel, groupList: group)
                                        .task {
                                            await viewModel.loadNextPageGroup(act: "groupList", groupby: groupType) { group in
                                                self.followedGroups = group
                                            }
                                        }
                                        .padding(5)
                                    
//                                    if viewModel.isFetchingNextPageGroup {
//                                        bottomProgressView
//                                    }
                                    
                                } else {
                                    
                                    GroupCell(viewModel: viewModel, groupList: group)
                                        .padding(5)
                                }
                            }
                        }
                    }
                } else if groupType == 3 {
                    ScrollView {
                        LazyVStack {
                            ForEach(invitations) { group in
                                if group.groupid == viewModel.groupList.last?.groupid {
                                    
                                    GroupCell(viewModel: viewModel, groupList: group)
                                        .task {
                                            await viewModel.loadNextPageGroup(act: "groupList", groupby: groupType) { group in
                                                self.invitations = group
                                            }
                                        }
                                        .padding(5)
                                    
//                                    if viewModel.isFetchingNextPageGroup {
//                                        bottomProgressView
//                                    }
                                    
                                } else {
                                    
                                    GroupCell(viewModel: viewModel, groupList: group)
                                        .padding(5)
                                }
                            }
                        }
                    }
                }
                
                if groupType == 3 {
                    Button(action: {
                        
                    }, label: {
                        Text(LocalizedStringKey("Label_View_All"))
                            .frame(maxWidth: .infinity, alignment: .center)
                            .font(.system(size: 18))
                            .foregroundColor(.gray)
                    })
                    .padding(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color(red: 244/255, green: 244/255, blue: 244/255), lineWidth: 1)
                            
                    )
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color(red: 244/255, green: 244/255, blue: 244/255)))
                }
                
            }
            .padding(.top, 20)
        }
        .onAppear {
            if groupType == 1 {
                Task {
                    await viewModel.loadFirstPageGroup(act: "groupList", groupby: groupType) { group in
                        self.yourGroups = group
                    }
                }
            } else if groupType == 2 {
                Task {
                    await viewModel.loadFirstPageGroup(act: "groupList", groupby: groupType) { group in
                        self.followedGroups = group
                    }
                }
            } else if groupType == 3 {
                Task {
                    await viewModel.loadFirstPageGroup(act: "groupList", groupby: groupType) { group in
                        self.invitations = group
                    }
                }
            }
        }
    }
    @ViewBuilder
    private var bottomProgressView: some View {
        HStack {
            Spacer()
            ProgressView()
            Spacer()
        }.padding()
    }
}
