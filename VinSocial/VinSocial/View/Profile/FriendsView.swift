//
//  FriendsView.swift
//  VinSocial
//
//  Created by Đinh Thái Sơn on 31/03/2023.
//

import SwiftUI

struct FriendsView: View {
    @State var friends:[ListFriend]
    
    var body: some View {
        VStack {
            HStack {
                Text("Bạn bè (\(friends.count))")
                    .foregroundColor(Color.black)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text("Xem thêm")
                    .foregroundColor(Color.blue)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
            
            ScrollView(.horizontal,showsIndicators: false) {
                LazyHStack{
                    ForEach(friends) { friend in
                        FriendCell(user: friend)
                    }
                }
                
            }
            
        }
        .padding([.leading, .trailing], 20)
    }
}

//struct FriendsView_Previews: PreviewProvider {
//    static var previews: some View {
//        FriendsView()
//    }
//}
