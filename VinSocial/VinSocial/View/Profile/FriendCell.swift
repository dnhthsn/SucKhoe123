//
//  FriendCell.swift
//  VinSocial
//
//  Created by Đinh Thái Sơn on 31/03/2023.
//

import SwiftUI
import Kingfisher
struct FriendCell: View {
    @State var user:ListFriend
    
    var body: some View {
        VStack {
            KFImage(URL(string: "https://suckhoe123.vn\(user.avatar ?? "")"))
                .resizable()
                .scaledToFill()
                .frame(width: 50, height: 50)
                .clipShape(Circle())
                .padding()
            
            Text(user.fullname ?? "" )
                .foregroundColor(Color.black)
                .font(.system(size: 20, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .center)
            
            Text("Follower")
                .foregroundColor(Color.gray)
                .frame(maxWidth: .infinity, alignment: .center)
        }
        .frame(width: 120, height: 150)
        .overlay(
            RoundedRectangle(cornerRadius: 6)
                .stroke(Color(red: 158/255, green: 158/255, blue: 158/255), lineWidth: 1)
                
        ).background(RoundedRectangle(cornerRadius: 6).fill(.white))
        
    }
}

//struct FriendCell_Previews: PreviewProvider {
//    static var previews: some View {
//        FriendCell()
//    }
//}
