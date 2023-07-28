//
//  ProfileView.swift
//  Messenger
//
//  Created by Đinh Thái Sơn on 27/02/2023.
//

import SwiftUI
import Kingfisher

struct ProfileView: View {
    @EnvironmentObject var viewModel: AuthenViewModel
    @EnvironmentObject var homeViewModel: HomeViewModel
    let user: UserResponse?
    @State var actionNoti: Bool = true
    @State var showLibrary: Bool = false
    @State var isActiveViewAddMember : Bool = false
    @State var isShowBackPress : Bool = false
    @ObservedObject var profileViewModel: ProfileViewModel
    @ObservedObject var friendViewModel: FriendViewModel = FriendViewModel()
    @State var friends:[ListFriend] = []
    @State var isActive: Bool = false

    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            VStack {
                if (viewModel.currentUser == nil && viewModel.currentUser?.userid == profileViewModel.currentUserId){
                    ViewWithouLogin(actionBack: false)
                        .environmentObject(viewModel)
                        .environmentObject(homeViewModel)
                        .tag(tabItems[3])
                        .ignoresSafeArea(.all, edges: .all)
                }else{
                    ZStack {
                        HStack {
                            Button {
                                presentationMode.wrappedValue.dismiss()
                                
                            } label: {
                                Image("ic_back_arrow")
                                    .resizable()
                                    .scaledToFit().frame(width: 24,height: 24)
                                    .foregroundColor(Color.black)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding([.leading, .trailing], 20)
                        
                        HStack {
                            Text("Cá nhân")
                                .foregroundColor(Color.black)
                                .font(.system(size: 25, weight: .semibold))
                                .multilineTextAlignment(.center)
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                        
                    }
                    
                    

                    Divider()
                    
                    ScrollView {
                        VStack {
                            ProfileHeaderView(user: user, profileViewModel: profileViewModel,isShowBackPress: isShowBackPress,currentUserId: profileViewModel
                                .currentUserId)
                            Divider()
                            VStack {
                                ProfileInformationView(user: profileViewModel.userDetailInfo,currentUserId: profileViewModel
                                    .currentUserId).environmentObject(homeViewModel)
                                
                                Divider()
                                
                                if !friendViewModel.listFriend.isEmpty {
                                    FriendsView(friends: friends)
                                }
                                HStack {
                                    Image("ic_posts")
                                        .resizable()
                                        .frame(width: 25, height: 25)

                                    if user?.userid == AuthenViewModel.shared.currentUser?.userid {
                                        Text(LocalizedStringKey("Label_Your_Post \(String(profileViewModel.newFeeds.count))"))
                                            .foregroundColor(Color.gray)
                                            .font(.system(size: 15))
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                    } else {
                                        Text(LocalizedStringKey("Label_Profile_Post \(String(profileViewModel.newFeeds.count))"))
                                            .foregroundColor(Color.gray)
                                            .font(.system(size: 15))
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                    }
                                    

                                    HStack {
                                        Image("ic_library")
                                            .resizable()
                                            .frame(width: 25, height: 25)

                                        Text(LocalizedStringKey("Label_Library"))
                                            .foregroundColor(Color(red: 23/255, green: 136/255, blue: 192/255))
                                            .font(.system(size: 15))
                                            .font(.footnote.weight(.bold))
                                    }
                                    .onTapGesture {
                                        showLibrary.toggle()
                                    }
                                    .fullScreenCover(isPresented: $showLibrary, content: {
                                        LibraryView(mediaUserViewModel: MediaUserViewModel())
                                    })


                                }
                                .padding([.leading, .trailing])

                                Divider()
                                
                                LazyVStack {
                                    if profileViewModel.newFeeds.isEmpty {
                                        if isActive {
                                            Spacer()
                                            
                                            Text("Hiện chưa có bài đăng nào")
                                                .foregroundColor(Color.blue)
                                                .padding(.top, 30)
                                            
                                            Spacer()
                                        } else {
                                            ShimmerView()
                                        }
                                        
                                    }else{
                                        NewFeedProfile(viewModel: profileViewModel)
                                    }
                                }
                            }
                            .background(Color.white)
                            .ignoresSafeArea()
                        }
                        
                    }
                    .onAppear{
                        Task {
                            await friendViewModel.loadFirstPageFriend(friendid: "",sort: 1) { friend in
                                self.friends = friend
                            }
                        }
                        
                        profileViewModel.getUinfo(profileid: profileViewModel.currentUserId)
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation {
                                self.isActive = true
                            }
                        }
                        
                        Task{
                            await profileViewModel.loadFirstPage(pageuserid: profileViewModel
                                .currentUserId)
                        }
                        
                        NotificationCenter.default.addObserver(forName: Notification.Name("CreatPost"), object: nil, queue: nil) { notification in
                            if let myObject = notification.object as? NewFeed {
                              //ViewModel sẽ add thêm vào
                                profileViewModel.addNewPostToFeed(newFeed: myObject)
                                
                            }
                        }
                        
                        NotificationCenter.default.addObserver(forName: Notification.Name("updatePost"), object: nil, queue: nil) { notification in
                            if let myObject = notification.object as? NewFeed {
                              //ViewModel sẽ add thêm vào
                                profileViewModel.updatePost(newFeed: myObject)
                                
                            }
                        }
                        
                        NotificationCenter.default.addObserver(forName: Notification.Name("deletePost"), object: nil, queue: nil) { notification in
                            if let postid = notification.object as? String {
                              //ViewModel sẽ add thêm vào
                                profileViewModel.deletePost(postid: postid)
                                
                            }
                        }
                        
                        NotificationCenter.default.addObserver(forName: Notification.Name("likePost"), object: nil, queue: nil) { notification in
                            if let postid = notification.object as? String {
                              //ViewModel sẽ add thêm vào
                                NotificationCenter.default.addObserver(forName: Notification.Name("numLikes"), object: nil, queue: nil) { notification1 in
                                    if let numLikes = notification1.object as? String {
                                      //ViewModel sẽ add thêm vào
                                        profileViewModel.updateLikePost(id: postid, numLikes: numLikes)
                                        
                                    }
                                }
                            }
                        }
                        
                        NotificationCenter.default.addObserver(forName: Notification.Name("disLikePost"), object: nil, queue: nil) { notification in
                            if let postid = notification.object as? String {
                              //ViewModel sẽ add thêm vào
                                NotificationCenter.default.addObserver(forName: Notification.Name("numLikes"), object: nil, queue: nil) { notification1 in
                                    if let numLikes = notification1.object as? String {
                                      //ViewModel sẽ add thêm vào
                                        profileViewModel.updateDisLikePost(id: postid, numLikes: numLikes)
                                        
                                    }
                                }
                            }
                        }
                        
                        NotificationCenter.default.addObserver(forName: Notification.Name("CommentPost"), object: nil, queue: nil) { notification in
                            if let postid = notification.object as? String {
                              //ViewModel sẽ add thêm vào
                                NotificationCenter.default.addObserver(forName: Notification.Name("NumComment"), object: nil, queue: nil) { notification1 in
                                    if let numComments = notification1.object as? String {
                                      //ViewModel sẽ add thêm vào
                                        profileViewModel.updateNumcomment(postId: postid, numComment: numComments)
                                        
                                    }
                                }
                            }
                        }
                    }
                }
                
            }
            .gesture(
                DragGesture()
                    .onEnded { gesture in
                        if gesture.translation.width > 100 {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
            )
            .background(Color.white)
            .navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
        }
        
    }
}

//struct ProfileView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProfileView()
//    }
//}
