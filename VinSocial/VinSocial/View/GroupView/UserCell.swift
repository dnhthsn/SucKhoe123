//
//  UserCell.swift
//  Suckhoe123
//
//  Created by Đinh Thái Sơn on 10/05/2023.
//

import SwiftUI
import Kingfisher

struct UserCell: View {
    @ObservedObject var viewModel: GroupViewModel
    @ObservedObject var friendViewModel: FriendViewModel
    @State var user:ListFriend
    var groupid: String
    @State var invited = false
    @State var userName: String = ""
    
    var body: some View {
        HStack {
            KFImage(URL(string: "https://ws.suckhoe123.vn\(user.avatar!)"))
                .resizable()
                .scaledToFill()
                .frame(width: 50, height: 50)
                .clipShape(Circle())
                .padding(5)
            
            VStack {
                Text(userName)
                    .foregroundColor(Color.black)
                    .font(.system(size: 16, weight: .bold))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .frame(height: 35)
                    .truncationMode(.tail)
                    .multilineTextAlignment(.leading)
            }
            
            Button(action: {
                viewModel.inviteMember(act: "invite", groupid: groupid, usertype: "0", memberid: user.userid ?? "") { check in
                    if check {
                        NotificationCenter.default.addObserver(forName: Notification.Name("inviteMember"), object: nil, queue: nil) { notification in
                            if let userid = notification.object as? String {
                              //ViewModel sẽ add thêm vào
                                friendViewModel.removeFriendList(userid: userid)
                                
                            }
                        }
                    }
                }
                self.invited.toggle()
            }, label: {
                if (!invited) {
                    Image("ic_add")
                        .resizable()
                        .frame(width: 20, height: 20)
                }

                Text(invited ? "Đã mời" : LocalizedStringKey("Label_Invite"))
                    .font(.system(size: 15))
                    .foregroundColor(invited ? Color(red: 23/255, green: 136/255, blue: 192/255) : .white)
                    .padding(.trailing, 5)
                    
            })
            .frame(width: 110, height: 30)
            .background(invited ? Color(red: 238/255, green: 249/255, blue: 255/255) : Color(red: 23/255, green: 136/255, blue: 192/255))
            .cornerRadius(30)
            .padding(.leading, 8)
            .disabled(invited)
        }
        .onAppear {
            DispatchQueue.main.async {
                self.userName = (user.fullname ?? "").htmlToString()
            }
        }
    }
}
