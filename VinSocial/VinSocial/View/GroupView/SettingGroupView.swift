//
//  SettingGroupView.swift
//  Suckhoe123
//
//  Created by Đinh Thái Sơn on 06/06/2023.
//

import SwiftUI

struct SettingGroupView: View {
    @ObservedObject var viewModel: GroupViewModel
    @ObservedObject var friendViewModel = FriendViewModel()
    var groupid: String
    @Environment(\.dismiss) var dismiss
    @State var showMemberView: Bool = false
    @State var showInviteMemberView: Bool = false
    
    var body: some View {
        VStack {
            VStack(spacing: 0) {
                HStack {
                    Image("ic_back_arrow")
                        .resizable()
                        .frame(width: 26, height: 26)
                        .foregroundColor(Color.black)
                        .onTapGesture {
                            dismiss()
                        }
                        .padding(.bottom, 10)
                    
                    Text("Quản trị nhóm")
                        .foregroundColor(Color.black)
                        .font(.system(size: 25, weight: .bold))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.bottom, 10)
                }
                .padding([.leading, .trailing], 20)
                .background(Color.white)

                Rectangle().fill(Color(red: 0.957, green: 0.957, blue: 0.957)).frame(height: 3)
                
                ScrollView {
                    VStack(spacing: 0) {
                        VStack {
                            Text("Hoạt động của nhóm")
                                .foregroundColor(Color.black)
                                .font(.system(size: 16, weight: .bold))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.top, 5)
                            
                            HStack {
                                Image("ic_blog1")
                                    .frame(width: 20, height: 20)
                                
                                Text("Bài viết cần phê duyệt")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .foregroundColor(Color.black)
                                    .font(.system(size: 18))
                                
                                Image("ic_arrow_next")
                                    .frame(width: 15, height: 15)
                                    .foregroundColor(Color.black)
                            }
                            .background(Color.white)
                            .padding(10)
                            
                            Divider()
                            
                            HStack {
                                Image("ic_history")
                                    .frame(width: 20, height: 20)
                                
                                Text("Lịch sử hoạt động")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .foregroundColor(Color.black)
                                    .font(.system(size: 18))
                                
                                Image("ic_arrow_next")
                                    .frame(width: 15, height: 15)
                                    .foregroundColor(Color.black)
                            }
                            .background(Color.white)
                            .padding(10)
                        }
                        .padding([.leading, .trailing], 20)
                        .background(Color.white)
                        
                        Rectangle().fill(Color(red: 0.957, green: 0.957, blue: 0.957)).frame(height: 3)
                        
                        VStack {
                            Text("Quản trị thành viên")
                                .foregroundColor(Color.black)
                                .font(.system(size: 16, weight: .bold))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.top, 5)
                            
                            Button(action: {
                                showInviteMemberView.toggle()
                            }, label: {
                                HStack {
                                    Image("ic_add_member_group")
                                        .frame(width: 20, height: 20)
                                        .foregroundColor(Color.black)
                                    
                                    Text("Mời thành viên mới")
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .foregroundColor(Color.black)
                                        .font(.system(size: 18))
                                    
                                    Image("ic_arrow_next")
                                        .frame(width: 15, height: 15)
                                        .foregroundColor(Color.black)
                                }
                                .background(Color.white)
                                .padding(10)
                            })
                            .fullScreenCover(isPresented: $showInviteMemberView, content: {
                                InviteMemberView1(viewModel: viewModel, friendViewModel: friendViewModel, groupid: groupid)
                            })
                            
        //                        NavigationLink(destination: {
        //                            InviteMemberView1(viewModel: viewModel, friendViewModel: friendViewModel, groupid: groupid)
        //                        }, label: {
        //                            HStack {
        //                                Image("ic_add_member_group")
        //                                    .frame(width: 20, height: 20)
        //                                    .foregroundColor(Color.black)
        //
        //                                Text("Mời thành viên mới")
        //                                    .frame(maxWidth: .infinity, alignment: .leading)
        //                                    .foregroundColor(Color.black)
        //                                    .font(.system(size: 18))
        //
        //                                Image("ic_arrow_next")
        //                                    .frame(width: 15, height: 15)
        //                                    .foregroundColor(Color.black)
        //                            }
        //                            .background(Color.white)
        //                            .padding(10)
        //                        })
        //
                            
                            
                            Divider()
                            
                            Button(action: {
                                showMemberView.toggle()
                            }, label: {
                                HStack {
                                    Image("ic_black_create_group")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 20, height: 20)
                                    
                                    Text("Thành viên trong nhóm")
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .foregroundColor(Color.black)
                                        .font(.system(size: 18))
                                    
                                    Image("ic_arrow_next")
                                        .frame(width: 15, height: 15)
                                        .foregroundColor(Color.black)
                                }
                                .background(Color.white)
                                .padding(10)
                            })
                            .fullScreenCover(isPresented: $showMemberView, content: {
                                GroupMemberListView(viewModel: viewModel, friendViewModel: friendViewModel, groupid: groupid)
                            })
                            
        //                        NavigationLink(destination: {
        //                            GroupMemberListView(viewModel: viewModel, friendViewModel: friendViewModel, groupid: groupid)
        //                                .navigationBarBackButtonHidden(true)
        //                        }, label: {
        //                            HStack {
        //                                Image("ic_black_create_group")
        //                                    .resizable()
        //                                    .frame(width: 20, height: 20)
        //
        //                                Text("Thành viên trong nhóm")
        //                                    .frame(maxWidth: .infinity, alignment: .leading)
        //                                    .foregroundColor(Color.black)
        //                                    .font(.system(size: 18))
        //
        //                                Image("ic_arrow_next")
        //                                    .frame(width: 15, height: 15)
        //                                    .foregroundColor(Color.black)
        //                            }
        //                            .background(Color.white)
        //                            .padding(10)
        //                        })
                            
                            
                            Divider()
                            
                            HStack {
                                Image("ic_checklist")
                                    .frame(width: 20, height: 20)
                                
                                Text("Thành viên chờ duyệt")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .foregroundColor(Color.black)
                                    .font(.system(size: 18))
                                
                                Image("ic_arrow_next")
                                    .frame(width: 15, height: 15)
                                    .foregroundColor(Color.black)
                            }
                            .background(Color.white)
                            .padding(10)
                        }
                        .padding([.leading, .trailing], 20)
                        .background(Color.white)
                        
                        Rectangle().fill(Color(red: 0.957, green: 0.957, blue: 0.957)).frame(height: 3)
                        
                        VStack {
                            Text("Cài đặt")
                                .foregroundColor(Color.black)
                                .font(.system(size: 16, weight: .bold))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.top, 5)
                            
                            HStack {
                                Image("ic_list")
                                    .frame(width: 20, height: 20)
                                
                                Text("Thông tin nhóm")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .foregroundColor(Color.black)
                                    .font(.system(size: 18))
                                
                                Image("ic_arrow_next")
                                    .frame(width: 15, height: 15)
                                    .foregroundColor(Color.black)
                            }
                            .background(Color.white)
                            .padding(10)
                            
                            Divider()
                            
                            HStack {
                                Image("ic_settings")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(Color.black)
                                
                                Text("Cấu hình nhóm")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .foregroundColor(Color.black)
                                    .font(.system(size: 18))
                                
                                Image("ic_arrow_next")
                                    .frame(width: 15, height: 15)
                                    .foregroundColor(Color.black)
                            }
                            .background(Color.white)
                            .padding(10)
                            
                            Divider()
                            
                            HStack {
                                Image("ic_red_delete_chat")
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(Color.red)
                                
                                Text("Xoá nhóm")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .foregroundColor(Color.red)
                                    .font(.system(size: 18))
                                
                            }
                            .background(Color.white)
                            .padding(10)
                            .padding(.bottom, 5)
                            .onTapGesture {
                                
                            }
                        }
                        .padding([.leading, .trailing], 20)
                        .background(Color.white)
                    }
                }
                .background(Color(red: 0.957, green: 0.957, blue: 0.957))
                
            }
            .background(Color(red: 0.957, green: 0.957, blue: 0.957))
            .navigationBarBackButtonHidden(true)
        }
        .background(Color(red: 0.957, green: 0.957, blue: 0.957))
        .gesture(
            DragGesture()
                .onEnded { gesture in
                    if gesture.translation.width > 100 {
                        dismiss()
                    }
                }
        )
        .navigationBarBackButtonHidden(true)
    }
}
