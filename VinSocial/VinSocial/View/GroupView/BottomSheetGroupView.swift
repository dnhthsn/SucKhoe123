//
//  BottomSheetGroupView.swift
//  Suckhoe123
//
//  Created by Đinh Thái Sơn on 09/06/2023.
//

import SwiftUI

struct BottomSheetGroupView: View {
    @ObservedObject var viewModel: GroupViewModel
    @ObservedObject var friendViewModel: FriendViewModel
    var groupid: String
    @Environment(\.dismiss) var dismiss
    @State var showMemberView: Bool = false
    var groupInfo: GroupInfo?
    @Binding var showNotiDialog: Bool
    @State var groupLink: GroupLink?
    
    var body: some View {
        ZStack {
            VStack(spacing: 15) {
                HStack {
                    Image("ic_black_create_group")
                        .resizable()
                        .frame(width: 30, height: 30)
                    
                    Text("Thành viên nhóm")
                        .font(.title3)
                        .padding(.leading, 10)
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .onTapGesture {
                    showMemberView.toggle()
                }
                .fullScreenCover(isPresented: $showMemberView, content: {
                    GroupMemberListView(viewModel: viewModel, friendViewModel: friendViewModel, groupid: groupid)
                })
                
                ShareLink(item: self.groupLink?.link ?? "") {
                    HStack {
                        Image("ic_share")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(Color.black)
                        
                        Text("Chia sẻ nhóm")
                            .font(.title3)
                            .padding(.leading, 10)
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                
                HStack {
                    Image("ic_log_out")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(Color(red: 239/255, green: 60/255, blue: 77/255))
                    
                    Text("Rời khỏi nhóm")
                        .font(.title3)
                        .padding(.leading, 10)
                        .foregroundColor(Color(red: 239/255, green: 60/255, blue: 77/255))
                        .frame(maxWidth: .infinity, alignment: .leading)
                }.onTapGesture {
//                    viewModel.leaveGroup(act: "leave", groupid: groupid)
                    showNotiDialog.toggle()
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
        .onAppear {
            viewModel.getGroupLink(act: "getLink", groupid: groupid) { groupLink in
                self.groupLink = groupLink
            }
        }
    }
}
