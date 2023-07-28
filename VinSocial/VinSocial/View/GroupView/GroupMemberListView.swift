//
//  GroupMemberListView.swift
//  Suckhoe123
//
//  Created by Đinh Thái Sơn on 07/06/2023.
//

import SwiftUI

struct GroupMemberListView: View {
    @ObservedObject var viewModel: GroupViewModel
    @ObservedObject var friendViewModel: FriendViewModel
    var groupid: String
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            VStack {
                HStack {
                    Image("ic_back_arrow")
                        .resizable()
                        .frame(width: 26, height: 26)
                        .foregroundColor(Color.black)
                        .onTapGesture {
                            dismiss()
                            viewModel.removeCacheMember()
                            viewModel.removeCacheAdmin()
                        }
                    
                    Text("Thành viên nhóm")
                        .foregroundColor(Color.black)
                        .font(.system(size: 25, weight: .bold))
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding([.leading, .trailing], 20)
                
                Rectangle().fill(Color(red: 0.957, green: 0.957, blue: 0.957)).frame(height: 4)
                
                ScrollView {
                    VStack {
                        VStack {
                            HStack {
                                Image("ic_admin")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                
                                Text("Quản trị viên \(Text("(\(viewModel.groupAdmins.count))").foregroundColor(Color(red: 23/255, green: 136/255, blue: 192/255)))")
                                    .foregroundColor(Color.black)
                                    .font(.system(size: 18, weight: .bold))
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            
                            LazyVStack {
                                ForEach(viewModel.groupAdmins) { member in
                                    if member.userid == viewModel.groupAdmins.last?.userid {
                                        
                                        GroupMemberCell(viewModel: viewModel, friendViewModel: friendViewModel, groupMember: member, groupid: groupid)
                                            .task {
                                                await viewModel.loadNextPageAdmin(act: "members", groupid: groupid, usertype: "1")
                                            }
                                            
                                        
                                    } else {
                                        
                                        GroupMemberCell(viewModel: viewModel, friendViewModel: friendViewModel, groupMember: member, groupid: groupid)
                                    }
                                }
                            }
                            
                            
                        }
                        .padding([.leading, .trailing], 20)
                        
                        
                        Divider()
                        
                        VStack {
                            HStack {
                                Text("Thành viên \(Text("(\(viewModel.groupMembers.count))").foregroundColor(Color(red: 23/255, green: 136/255, blue: 192/255)))")
                                    .foregroundColor(Color.black)
                                    .font(.system(size: 18, weight: .bold))
                                    
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            
                            LazyVStack {
                                ForEach(viewModel.groupMembers) { member in
                                    if member.userid == viewModel.groupMembers.last?.userid {

                                        GroupMemberCell(viewModel: viewModel, friendViewModel: friendViewModel, groupMember: member, groupid: groupid)
                                            .task {
                                                await viewModel.loadNextPageMember(act: "members", groupid: groupid, usertype: "0")
                                            }
                                            .padding(5)

                                    } else {

                                        GroupMemberCell(viewModel: viewModel, friendViewModel: friendViewModel, groupMember: member, groupid: groupid)
                                            .padding(5)
                                    }
                                }
                            }
                            
                        }
                        .padding([.leading, .trailing], 20)
                    }
                }
                
                
            }
            .gesture(
                DragGesture()
                    .onEnded { gesture in
                        if gesture.translation.width > 100 {
                            dismiss()
                            viewModel.removeCacheMember()
                            viewModel.removeCacheAdmin()
                        }
                    }
            )
            .navigationBarBackButtonHidden(true)
            .onAppear {
                Task {
                    await viewModel.loadFirstPageAdmin(act: "members", groupid: groupid, usertype: "1")
                }
                
                Task {
                    await viewModel.loadFirstPageMember(act: "members", groupid: groupid, usertype: "0")
                }
            }
        }
    }
}
