//
//  BottomSheetGroupMember.swift
//  Suckhoe123
//
//  Created by Đinh Thái Sơn on 14/06/2023.
//

import SwiftUI
import Kingfisher

struct BottomSheetGroupMember: View {
    @ObservedObject var viewModel: GroupViewModel
    @ObservedObject var friendViewModel: FriendViewModel
    var groupMember: GroupMember
    var groupid: String
    @Binding var showBottomSheet: Bool
    
    var body: some View {
        ZStack {
            VStack(spacing: 15) {
                
                HStack {
                    KFImage(URL(string: "https://ws.suckhoe123.vn\(groupMember.avatar ?? "")"))
                        .resizable()
                        .scaledToFill()
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                        .padding(5)
                    
                    VStack {
                        Text(groupMember.fullname ?? "" )
                            .foregroundColor(Color.black)
                            .font(.system(size: 20, weight: .bold))
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                
                Divider()
                
                
                HStack {
                    Image("ic_send_mess")
                        .resizable()
                        .frame(width: 30, height: 30)
                    
                    Text("Gửi tin nhắn")
                        .font(.title3)
                        .padding(.leading, 10)
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .onTapGesture {
                    
                }
                
                if groupMember.isadmin == "1" {
                    HStack {
                        Image("ic_admin1")
                            .resizable()
                            .frame(width: 30, height: 30)
                        
                        Text("Gỡ danh hiệu Quản trị viên")
                            .font(.title3)
                            .padding(.leading, 10)
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .onTapGesture {
                        
                    }
                } else {
                    HStack {
                        Image("ic_admin2")
                            .resizable()
                            .frame(width: 30, height: 30)
                        
                        Text("Mời làm Quản trị viên")
                            .font(.title3)
                            .padding(.leading, 10)
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .onTapGesture {
                        viewModel.inviteMember(act: "invite", groupid: groupid, usertype: "1", memberid: groupMember.userid ?? "") { check in
                            NotificationCenter.default.addObserver(forName: Notification.Name("inviteMember"), object: nil, queue: nil) { notification in
                                if let userid = notification.object as? String {
                                  //ViewModel sẽ add thêm vào
                                    friendViewModel.removeFriendList(userid: userid)
                                    
                                }
                            }
                        }
                        viewModel.removeCacheMember()
                    }
                }
                
                
                HStack {
                    Image("ic_red_delete_chat")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(Color(red: 239/255, green: 60/255, blue: 77/255))
                    
                    Text("Xoá khỏi nhóm")
                        .font(.title3)
                        .padding(.leading, 10)
                        .foregroundColor(Color(red: 239/255, green: 60/255, blue: 77/255))
                        .frame(maxWidth: .infinity, alignment: .leading)
                }.onTapGesture {
                    viewModel.removeMember(act: "remove", groupid: groupid, memberid: groupMember.userid ?? "")
                    showBottomSheet = false
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
        .onAppear {
            
        }
    }
}
