//
//  GroupMemberView.swift
//  Suckhoe123
//
//  Created by Đinh Thái Sơn on 11/05/2023.
//

import SwiftUI

struct GroupMemberView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: GroupViewModel
    @ObservedObject var friendViewModel: FriendViewModel
    var groupid: String
//    @State var adminMembers: [GroupMember] = []
//    @State var members: [GroupMember] = []
    
    var body: some View {
        VStack {
            HStack {
                Text("Thành viên \(Text("(\(viewModel.groupMembers.count))").foregroundColor(Color(red: 23/255, green: 136/255, blue: 192/255)))")
                    .foregroundColor(Color.black)
                    .font(.system(size: 18, weight: .bold))
                    
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            ScrollView {
                LazyVStack {
                    ForEach(viewModel.groupMembers.indices, id: \.self) { member in
                        if viewModel.groupMembers[member].userid == viewModel.groupMembers.last?.userid {
                            
                            GroupMemberCell(viewModel: viewModel, friendViewModel: friendViewModel, groupMember: viewModel.groupMembers[member], groupid: groupid)
                                .task {
                                    await viewModel.loadNextPageMember(act: "members", groupid: groupid, usertype: "0")
                                }
                                .padding(5)
                            
                        } else {
                            
                            GroupMemberCell(viewModel: viewModel, friendViewModel: friendViewModel, groupMember: viewModel.groupMembers[member], groupid: groupid)
                                .padding(5)
                        }
                    }
                }
            }
            
        }
        .padding([.leading, .trailing], 20)
        .onAppear {
            Task {
                await viewModel.loadFirstPageMember(act: "members", groupid: groupid, usertype: "0")
            }
        }
    }
}
