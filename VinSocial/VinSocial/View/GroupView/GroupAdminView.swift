//
//  GroupAdminView.swift
//  Suckhoe123
//
//  Created by Đinh Thái Sơn on 21/07/2023.
//

import SwiftUI

struct GroupAdminView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: GroupViewModel
    @ObservedObject var friendViewModel: FriendViewModel
    var groupid: String
    
    var body: some View {
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
            
            ScrollView {
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
            
        }
        .padding([.leading, .trailing], 20)
        .onAppear {
            Task {
                await viewModel.loadFirstPageAdmin(act: "members", groupid: groupid, usertype: "1")
            }
        }
    }
}
