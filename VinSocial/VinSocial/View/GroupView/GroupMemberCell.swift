//
//  MemberCell.swift
//  Suckhoe123
//
//  Created by Đinh Thái Sơn on 07/06/2023.
//

import SwiftUI
import Kingfisher

struct GroupMemberCell: View {
    @ObservedObject var viewModel: GroupViewModel
    @ObservedObject var friendViewModel: FriendViewModel
    var groupMember: GroupMember
    var groupid: String
    @State var showBottomSheet: Bool = false
    @State var nameMember: String = ""
    
    var body: some View {
        HStack {
            KFImage(URL(string: "https://ws.suckhoe123.vn\(groupMember.avatar ?? "")"))
                .resizable()
                .scaledToFill()
                .frame(width: 50, height: 50)
                .clipShape(Circle())
                .padding(5)
            
            VStack {
                Text(nameMember)
                    .foregroundColor(Color.black)
                    .font(.system(size: 20, weight: .bold))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .frame(height: 35)
                    .truncationMode(.tail)
                    .multilineTextAlignment(.leading)
            }
            
            Button(action: {
                showBottomSheet.toggle()
            }, label: {
                Image("ic_option")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundColor(Color.gray)
            })
            .sheet(isPresented: $showBottomSheet) {
                BottomSheetGroupMember(viewModel: viewModel, friendViewModel: friendViewModel, groupMember: groupMember, groupid: groupid, showBottomSheet: $showBottomSheet).presentationDetents([.height(250), .large])
            }
        }
        .onAppear {
            DispatchQueue.main.async {
                nameMember = (groupMember.fullname ?? "").htmlToString()
            }
        }
    }
}
