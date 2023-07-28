//
//  CatalogDoctorView.swift
//  Suckhoe123
//
//  Created by Đinh Thái Sơn on 25/05/2023.
//

import SwiftUI
import Kingfisher

struct CatalogDoctorView: View {
    @ObservedObject var viewModel :BeautyViewModel
    @ObservedObject var friendViewModel: FriendViewModel
    @State var isFollow: Bool = false
    let subCatalog: SubCatalog
    let catalogDoctor: CatalogDoctor
    @State var showProfile: Bool = false
    
    var body: some View {
        VStack {
            HStack {
                KFImage
                    .url((URL(string: "https://suckhoe123.vn\(catalogDoctor.avatar!)")))
                    .resizable()
                    .scaledToFill()
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
                    .padding(5)
                    .frame(maxHeight: .infinity, alignment: .top)
                
                VStack {
                    Text(catalogDoctor.fullname ?? "")
                        .foregroundColor(Color.black)
                        .font(.system(size: 20, weight: .bold))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    HStack {
                        ForEach(0..<5) { item in
                            HStack {
                                Image("ic_star 1")
                                    .frame(width: 16, height: 16)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    
                    HStack(spacing: 20) {
                        HStack {
                            Image("ic_answer")
                                .frame(width: 16, height: 16)
                            
                            Text(catalogDoctor.totalanswer ?? "")
                                .foregroundColor(Color.gray)
                        }
                        
                        HStack {
                            Image("ic_image1")
                                .frame(width: 16, height: 16)
                            
                            Text(catalogDoctor.totalimage ?? "")
                                .foregroundColor(Color.gray)
                        }
                        
                        HStack {
                            Image("ic_video1")
                                .frame(width: 16, height: 16)
                            
                            Text(catalogDoctor.totalvideo ?? "")
                                .foregroundColor(Color.gray)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    if !(catalogDoctor.description ?? "").isEmpty {
                        Text(catalogDoctor.description ?? "")
                            .foregroundColor(Color.black)
                            .font(.system(size: 15))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .frame(height: 70)
                            .multilineTextAlignment(.leading)
                            .truncationMode(.tail)
                    }
                    
                    HStack(spacing: 10) {
                        Button(action: {
                            if catalogDoctor.friend_info?.follow == "1" {
                                friendViewModel.makeFriend(friendid: catalogDoctor.userid ?? "", act: "nofollow", verifykey: "")
                            } else {
                                if catalogDoctor.friend_info?.isfriend == "1" {
                                    friendViewModel.makeFriend(friendid: catalogDoctor.userid ?? "", act: "follow", verifykey: "")
                                } else {
                                    friendViewModel.makeFriend(friendid: catalogDoctor.userid ?? "", act: "accept_friend", verifykey: "")
                                }
                            }
                            
                            isFollow.toggle()
                        }, label: {
                            if !isFollow {
                                Image("ic_add")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                            }

                            Text(isFollow ? "Đang theo dõi" : LocalizedStringKey("Label_Follow"))
                                .font(.system(size: 15))
                                .foregroundColor(isFollow ? Color(red: 23/255, green: 136/255, blue: 192/255) : .white)
                                .padding(.trailing, 5)
                                
                        })
                        .frame(width: 110, height: 30)
                        .background(isFollow ? Color(red: 238/255, green: 249/255, blue: 255/255) : Color(red: 23/255, green: 136/255, blue: 192/255))
                        .cornerRadius(30)
                        
                        Button(action: {
                            
                        }, label: {
                            Image("ic_chat")
                                .resizable()
                                .frame(width: 20, height: 20)
                            
                            Text("Nhắn tin")
                                .font(.system(size: 15))
                                .foregroundColor(.white)
                                .padding(.trailing, 5)
                                
                        })
                        .frame(width: 110, height: 30)
                        .background(Color(red: 23/255, green: 136/255, blue: 192/255))
                        .cornerRadius(30)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .padding(10)
            .overlay(
                RoundedRectangle(cornerRadius: 6)
                    .stroke(Color(red: 0.957, green: 0.957, blue: 0.957), lineWidth: 2)
                    
            )
            .background(RoundedRectangle(cornerRadius: 6).fill(.white).shadow(radius: 2))
            .frame(width: UIScreen.main.bounds.width-20)
        }
        .onTapGesture {
            self.showProfile.toggle()
        }
        .fullScreenCover(isPresented: $showProfile, content: {
            ProfileView(user: nil, isShowBackPress: true,profileViewModel: ProfileViewModel(currentUserId: catalogDoctor.userid ?? "", userDetailInfo: viewModel.initUserInfo1(catalogDoctor: catalogDoctor),"From catalogDoctorView"))
        })
//        .onAppear{
//            loadData(category: "lam-dep", catid: subCatalog.catalogid ?? "", act: "doctor", sortby: "recent")
//        }
    }
}
