//
//  GroupCell.swift
//  Suckhoe123
//
//  Created by Đinh Thái Sơn on 09/05/2023.
//

import SwiftUI
import Kingfisher

struct GroupCell: View {
    @ObservedObject var viewModel: GroupViewModel
    var groupList: GroupList
    @State var showDetail = false
    @State var groupInfo: GroupInfo?
    @State var isCreateGroup : Bool = false

    var body: some View {
        HStack {
            KFImage(URL(string: "https://ws.suckhoe123.vn\(groupList.banner ?? "")"))
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
                .cornerRadius(10)
            
            VStack {
                Text(groupList.title ?? "")
                    .foregroundColor(.black)
                    .font(.system(size: 20, weight: .bold))
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text(groupList.grouptype ?? "")
                    .foregroundColor(.gray)
                    .font(.system(size: 15))
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .onTapGesture {
            showDetail.toggle()
            viewModel.getGroupInfo(groupid: groupList.groupid ?? "", completion: { groupInfo in
                self.groupInfo = groupInfo
            })
        }
        .fullScreenCover(isPresented: $showDetail, content: {
            GroupDetailView(groupInfo: self.groupInfo, viewModel: viewModel, groupid: groupList.groupid ?? "",isCreateGroup:$isCreateGroup)
        })
    }
}
