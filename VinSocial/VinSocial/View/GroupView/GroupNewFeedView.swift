//
//  GroupNewFeedView.swift
//  Suckhoe123
//
//  Created by Đinh Thái Sơn on 09/06/2023.
//

import SwiftUI
import Kingfisher

struct GroupNewFeedView: View {
    @ObservedObject var viewModel: GroupViewModel
    var groupid: String
    var isAllNewFeed: Bool
    @State var currentTab: Int = 0
    @State var showBeautyView: Bool = false
    @State var showHealthView: Bool = false
    @State var showBlogView: Bool = false
    @State var isSearching: Bool = false
    
    @State var showType: TypeShowScreen
    @State var showToast: Bool = false

    
    var body: some View {
        VStack{
            VStack {
                Rectangle().fill(Color(red: 0.957, green: 0.957, blue: 0.957)).frame(height: 4)
                listView
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            }
        }
        .overlay(
            overlayView: ToastView(toast: Toast(title: "Đã sao chép" , image: ""), show: $showToast), show: $showToast
        )
    }
    
    
    @ViewBuilder
    private var bottomProgressView: some View {
        Divider()
        HStack {
            Spacer()
            ProgressView()
            Spacer()
        }.padding()
    }
    
    
    @State var newFeeds = [NewFeed]()
    
    private var listView: some View {
        ScrollView {
            if viewModel.isCreatePost {
                HStack{
                    ProgressView()
                    Text(LocalizedStringKey("Label_Create_Post"))
                        .font(.footnote)
                        .fontWeight(.black)
                        .foregroundColor(Color.black)
                }
            }
            LazyVStack{
                if isAllNewFeed {
                    let newFeeds = viewModel.allNewFeeds
                    ForEach(newFeeds) { newfeed in
                        if newfeed.postid == newFeeds.last?.postid {
                            listRowView(for: newfeed, isAllNewFeed: isAllNewFeed, groupId: groupid)
                                .task {
                                    if isSearching{
                                        
                                    }else{
                                        await viewModel.loadNextPage(act: "list", groupid: groupid)
                                    }
                                   
                                }
                            
//                            if viewModel.isFetchingNextPage {
//                                bottomProgressView
//                            }
                            
                        } else {
                            listRowView(for: newfeed, isAllNewFeed: isAllNewFeed, groupId: groupid)
                        }
                    }
                    .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                    .listRowSeparator(.hidden)
                } else {
                    let newFeeds = viewModel.newFeeds
                    ForEach(newFeeds) { newfeed in
                        if newfeed.postid == newFeeds.last?.postid {
                            listRowView(for: newfeed, isAllNewFeed: isAllNewFeed, groupId: groupid)
                                .task {
                                    if isSearching{
                                        
                                    }else{
                                        await viewModel.loadNextPage(act: "list", groupid: groupid)
                                    }
                                   
                                }
                            
//                            if viewModel.isFetchingNextPage {
//                                bottomProgressView
//                            }
                            
                        } else {
                            listRowView(for: newfeed, isAllNewFeed: isAllNewFeed, groupId: groupid)
                        }
                    }
                    .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                    .listRowSeparator(.hidden)
                }
                
              
            }
            .padding(.top, 2)

        }
        .refreshable {
            viewModel.removeCacheAllNewFeed()
            viewModel.removeCache()
            viewModel.loadDataAllNewFeed(act: "newfeed")
            viewModel.loadData(act: "list", groupid: groupid)
        }
    }
    
    private func getCatID()->String{
        var catid = ""
//        if viewModel.listCatalogs(showType: showType).count > 0 {
//            if currentTab < viewModel.listCatalogs(showType: showType).count{
//                let catalog =  viewModel.listCatalogs(showType:showType)[currentTab]
//                catid = catalog.catid ?? ""
//                 
//            }
//        }
        return catid
    }
    

    @ViewBuilder
    private func listRowView(for newFeed: NewFeed, isAllNewFeed: Bool, groupId: String) -> some View {
        GroupNewFeedRowView(groupViewModel: viewModel, viewModel: FeedCellViewModel(newFeed), friendViewModel: FriendViewModel(), isAllNewFeed: isAllNewFeed, groupId: groupId, showToast: $showToast)

    }
}

struct GroupNewFeedRowView: View {
    @ObservedObject var groupViewModel: GroupViewModel
    @ObservedObject var viewModel:FeedCellViewModel
    @ObservedObject var friendViewModel: FriendViewModel
    var isAllNewFeed: Bool
    
    @State var presentBottomSheet = false
    @State var actionDelete : Bool = false
    @State var confirmDelete : Bool = false
    @State var showSheet: Bool = false
    @State var showComments: Bool = false
    @State var dateNow = Date.now
    @State var showLikes: Bool = false
    @State var isOwner: Bool = false
    @State var isShowFullProfile: Bool = false
    @State var isErrorLoadingImage: Bool = false
    @State var isSuccessLoadingImage: Bool = false
    @State var isFollow: Bool = false
    @State var isLikedPost: Bool = false
    @State var isCreateGroup: Bool = false
    @State var groupInfo: GroupInfo?
    @State var showFullNewFeed: Bool = false
    @State var showFullContent: Bool = false
    @State var showFullImage: Bool = false
    @State var position: Int = 1
    var groupId: String
    @Binding var showToast: Bool
    
    var body: some View {
        VStack {
            
            HStack {
                Button {
                    isShowFullProfile.toggle()
                    if isAllNewFeed {
                        groupViewModel.getGroupInfo(groupid: viewModel.newFeed.groupid ?? "", completion: { groupInfo in
                            self.groupInfo = groupInfo
                        })
                    }
                    
                } label: {
                    if isAllNewFeed {
                        KFImage(URL(string: "https://ws.suckhoe123.vn\(viewModel.newFeed.groupbanner ?? "")"))
                            .resizable()
                            .scaledToFill()
                            .frame(width: 50, height: 50)
                            .cornerRadius(15)
                            .overlay(KFImage(URL(string: isErrorLoadingImage ? stringURL:viewModel.getLinkAvatarUser))
                                .onSuccess { r in
                                    isSuccessLoadingImage = true
                                }
                                .placeholder { p in
                                    if (!isErrorLoadingImage && !isSuccessLoadingImage) {
            //                                ProgressView(p)
                                    }
                                   
                                }
                                .onFailure { t in
                                    isErrorLoadingImage = true
                                }
                                .resizable()
                                .scaledToFill()
                                .frame(width: 25, height: 25)
                                .clipShape(Circle())
                                .padding(2)
                                .background(Color.white)
                                .clipShape(Circle())
                                .offset(x: 0, y: 2)
                                     
                                     ,alignment: .bottomTrailing
                            )
                    } else {
                        KFImage(URL(string: isErrorLoadingImage ? stringURL:viewModel.getLinkAvatarUser))
                            .onSuccess { r in
                                isSuccessLoadingImage = true
                            }
                            .placeholder { p in
                                if (!isErrorLoadingImage && !isSuccessLoadingImage) {
        //                                ProgressView(p)
                                }
                               
                            }
                            .onFailure { t in
                                isErrorLoadingImage = true
                            }
                            .resizable()
                            .scaledToFill()
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                    }
                    
                       
                    if isAllNewFeed {
                        VStack {
                            Text(viewModel.newFeed.grouptitle ?? "")
                                .font(.system(size: 20, weight: .bold))
                                .multilineTextAlignment(.leading)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .frame(height: 20)
                                .truncationMode(.tail)
                                .foregroundColor(Color.black)
                            
                            HStack {
                                Text(viewModel.nameUser)
                                    .font(.system(size: 18))
                                    .multilineTextAlignment(.leading)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .frame(height: 20)
                                    .truncationMode(.tail)
                                    .foregroundColor(Color.black)
                            }
                        }
                    } else {
                        VStack {
                            Text(viewModel.nameUser)
                                .font(.headline)
                                .font(.footnote.weight(.bold))
                                .multilineTextAlignment(.leading)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .frame(height: 20)
                                .truncationMode(.tail)
                                .foregroundColor(Color.black)
                            
                            HStack {
                                if viewModel.newFeed.user_info?.isadmin == 1 {
                                    Text("Quản trị viên")
                                        .foregroundColor(Color(red: 23/255, green: 136/255, blue: 192/255))
                                        .background(RoundedRectangle(cornerRadius: 5).fill(Color(red: 238/255, green: 249/255, blue: 255/255)))
                                }
                                
                                if CheckTime().getCurrentTime() == CheckTime().convertTime(time: Int(viewModel.newFeed.addtime ?? "") ?? 0) {
                                    Text("• Vừa xong")
                                        .foregroundColor(Color.gray)
                                        .font(.system(size: 16))
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .truncationMode(.tail)
                                        .frame(height: 30)
                                } else {
                                    Text("• \(CheckTime().compareTime(timeArr1: CheckTime().convertTime(time: Int(viewModel.newFeed.addtime ?? "") ?? 0), timeArr2: CheckTime().getCurrentTime()))")
                                        .foregroundColor(Color.gray)
                                        .font(.system(size: 16))
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .truncationMode(.tail)
                                        .frame(height: 30)
                                }
                            }
                        }
                    }

                }
                .fullScreenCover(isPresented: $isShowFullProfile, content: {
                    if isAllNewFeed {
                        GroupDetailView(groupInfo: groupInfo, viewModel: groupViewModel, groupid: viewModel.newFeed.groupid ?? "", isCreateGroup: $isCreateGroup)
                    } else {
                        ProfileView(user: nil, isShowBackPress: true,profileViewModel: ProfileViewModel(currentUserId: viewModel.getUserID,userDetailInfo: viewModel.initUserInfo(),"Testing from groupNewFeed 262"), friendViewModel: FriendViewModel())
                    }
                })
                
                if AuthenViewModel.shared.currentUser != nil && !isAllNewFeed {
                    if (!viewModel.checkOwnerPost) {
                        
                        Button(action: {
                            
                            if viewModel.followStatus == "1" {
                                friendViewModel.makeFriend(friendid: viewModel.getUserID, act: "nofollow", verifykey: "")
                            } else {
                                if viewModel.isFriendStatus == "1" {
                                    friendViewModel.makeFriend(friendid: viewModel.getUserID, act: "follow", verifykey: "")
                                } else {
                                    friendViewModel.makeFriend(friendid: viewModel.getUserID, act: "accept_friend", verifykey: "")
                                }
                            }
                            
                            isFollow.toggle()
                        }, label: {
                            if (!isFollow) {
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
                        .padding(.leading, 8)
                        
//                            if (viewModel.followStatus == "1") {
//                                Button(action: {
//                                    friendViewModel.makeFriend(friendid: viewModel.getUserID, act: "nofollow", verifykey: "")
//                                    isFollow = false
//                                }, label: {
//                                    Text("Đang theo dõi")
//                                        .font(.system(size: 15))
//                                        .foregroundColor(Color(red: 23/255, green: 136/255, blue: 192/255))
//                                        .padding(.trailing, 5)
//                                })
//                                .frame(width: 110, height: 30)
//                                .background(Color(red: 238/255, green: 249/255, blue: 255/255))
//                                .cornerRadius(30)
//                                .padding(.leading, 8)
//                            } else {
//                                Button(action: {
//                                    //loadingToggle.toggle()
//                                    if viewModel.isFriendStatus == "1" {
//                                        friendViewModel.makeFriend(friendid: viewModel.getUserID, act: "follow", verifykey: "")
//                                    } else {
//                                        friendViewModel.makeFriend(friendid: viewModel.getUserID, act: "accept_friend", verifykey: "")
//                                    }
//
//                                    isFollow = true
//                                }, label: {
//                                    Image("ic_add")
//                                        .resizable()
//                                        .frame(width: 20, height: 20)
//
//                                    Text(LocalizedStringKey("Label_Follow"))
//                                        .font(.system(size: 15))
//                                        .foregroundColor(.white)
//                                        .padding(.trailing, 5)
//
//                                })
//                                .frame(width: 110, height: 30)
//                                .background(Color(red: 23/255, green: 136/255, blue: 192/255))
//                                .cornerRadius(30)
//                                .padding(.leading, 8)
//                            }
                    }
                }
                if #available(iOS 16.0, *) {
                    Image("ic_option")
                        .resizable()
                        .foregroundColor(Color.black)
                        .frame(width: 30, height: 30)
                        .padding(.trailing, 10)
                        .onTapGesture {
                            presentBottomSheet.toggle()
                        }
                        .sheet(isPresented: $presentBottomSheet) {
                            if viewModel.newFeed.groupid == nil {
                                BottomSheetGroupNewFeed(viewModel: groupViewModel, actionDelete: $actionDelete, confirmDelete: $confirmDelete, url: viewModel.newFeed.linkpost ?? "", actionShare: false, postid: viewModel.postId, userid: viewModel.getUserID, groupid: groupId, showToast: {
                                    self.showToast = true
                                }).presentationDetents([.height(viewModel.checkOwnerPost ? 200 : 100), .large])
                            } else {
                                BottomSheetGroupNewFeed(viewModel: groupViewModel, actionDelete: $actionDelete, confirmDelete: $confirmDelete, url: viewModel.newFeed.linkpost ?? "", actionShare: false, postid: viewModel.postId, userid: viewModel.getUserID, groupid: viewModel.newFeed.groupid ?? "", showToast: {
                                    self.showToast = true
                                }).presentationDetents([.height(viewModel.checkOwnerPost ? 200 : 100), .large])
                            }
                            
                        }
                } else {
                    Image("ic_option")
                        .resizable()
                        .foregroundColor(Color.black)
                        .frame(width: 30, height: 30)
                        .padding(.trailing, 10)
                        .onTapGesture {
                            showSheet.toggle()
                        }
                        .halfSheet(showSheet: $showSheet, sheetView: {
                            if viewModel.newFeed.groupid == "" {
                                BottomSheetGroupNewFeed(viewModel: groupViewModel, actionDelete: $actionDelete, confirmDelete: $confirmDelete, url: viewModel.newFeed.linkpost ?? "", actionShare: false, postid: viewModel.postId, userid: viewModel.getUserID, groupid: groupId, showToast: {
                                    self.showToast = true
                                })
                            } else {
                                BottomSheetGroupNewFeed(viewModel: groupViewModel, actionDelete: $actionDelete, confirmDelete: $confirmDelete, url: viewModel.newFeed.linkpost ?? "", actionShare: false, postid: viewModel.postId, userid: viewModel.getUserID, groupid: viewModel.newFeed.groupid ?? "", showToast: {
                                    self.showToast = true
                                })
                            }
                            
                        })
                }
                
            }
            
            

            Text(viewModel.title)
                .font(.system(size: 18, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(Color.black)
                .padding(.trailing, 10)
            
//            ExpandableText(text: viewModel.newFeed.hometext!.htmlToString())
//                        .font(.body)//optional
//                        .foregroundColor(.primary)//optional
//                        .lineLimit(3)//optional
//                        .expandButton(TextSet(text: "Xem thêm", font: .body, color: .blue))
//                        .collapseButton(TextSet(text: "Thu nhỏ", font: .body, color: .blue))
//                        .expandAnimation(.easeOut)
//            if isAllNewFeed {
//                ExpandableTextView(text: viewModel.newFeed.content ?? "", maxLines: 3)
//                    .padding(.trailing, 10)
//            } else {
//                ExpandableTextView(text: viewModel.newFeed.hometext ?? "", maxLines: 3)
//                    .padding(.trailing, 10)
//            }
            
//            ExpandableTextView(text: viewModel.newFeed.content ?? "", maxLines: 3)
//                .padding(.trailing, 10)
            
            WebHTMLText(height: 77, html: ((viewModel.newFeed.content == nil ? viewModel.newFeed.hometext : viewModel.newFeed.content) ?? ""), checkCustom: (!showFullContent && viewModel.newFeed.hometext?.count ?? 0 >= 120))
                .lineHeight(170)
                .colorScheme(.auto)
                .imageRadius(12)
                .fontType(.system)
                .foregroundColor(light: Color.primary, dark: Color.primary)
                .linkColor(light: Color.blue, dark: Color.blue)
                .colorPreference(forceColor: .onlyLinks)
                .linkOpenType(.SFSafariView())
                .customCSS("")
                .placeholder {
                    Text("")
                }
                .transition(.easeOut)
                .onTapGesture {
                    showFullNewFeed.toggle()
                }
                .fullScreenCover(isPresented: $showFullNewFeed, content: {
                    GroupDetailNewFeedView(groupViewModel: groupViewModel, viewModel: viewModel, friendViewModel: friendViewModel)
                })
            
            if viewModel.newFeed.hometext?.count ?? 0 >= 120 || viewModel.newFeed.content?.count ?? 0 >= 120 {
                Button(action: {
                    showFullContent.toggle()
                }, label: {
                    Text(showFullContent ? "Thu nhỏ" : "Xem thêm")
                        .foregroundColor(Color.blue)
                        .frame(maxWidth: .infinity, alignment: .leading)
                })
                .padding(.top, 10)
            }

            let collumns = Array(repeating: GridItem(.flexible(), spacing: 15), count: 2)
            
            LazyVGrid(columns: collumns, alignment: .leading, spacing: 10, content: {
                ForEach(viewModel.getMedia.indices, id: \.self) { index in
                    GridImageView(index: index,cellModel: viewModel)
                        .onTapGesture {
                            showFullImage.toggle()
                            self.position = index+1
                        }
                        .fullScreenCover(isPresented: $showFullImage, content: {
                            //CatalogImageDetailView(catalogImage: <#T##[CatalogImage]#>, position: self.position)
                            DetailNewFeedImage(viewModel: viewModel, media: viewModel.getMedia, position: self.position)
                        })
                }

            })
            .padding(.trailing)
            
            HStack {
                HStack (spacing: 5) {
                    Image(viewModel.newFeed.like == "1" ? "ic_liked" : "ic_heart_reaction")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .onTapGesture {
                            isLikedPost.toggle()
                            groupViewModel.likePost(act: "like", id: viewModel.newFeed.postid ?? "")
//                            groupViewModel.removeCache()
//                            groupViewModel.removeCacheAllNewFeed()
                        }
                    
                    Text("\((viewModel.newFeed.numLikes == "" ? String(viewModel.newFeed.numlike ?? "") : viewModel.newFeed.numLikes) ?? "")")
                        .foregroundColor(Color.gray)
                        .onTapGesture {
                            showLikes.toggle()
                        }
                        .sheet(isPresented: $showLikes, content: {
                            VStack{
                                ForEach(viewModel.getListLike) { like in
                                    ListLikeView(like: like, total: viewModel.getListLike.count)
                                        .presentationDetents([.height(250), .large])
                                    
                                }
                            }
                        })
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                HStack (spacing: 5) {
                    Image("ic_comment")
                        .resizable()
                        .frame(width: 25, height: 25)
                        .foregroundColor(Color.gray)
                    
                    Text(viewModel.newFeed.numcomment ?? "")
                        .foregroundColor(Color.gray)
                }
                .onTapGesture {
                    showComments.toggle()
                }
                .fullScreenCover(isPresented: $showComments, content: {
//                    if AuthenViewModel.shared.currentUser != nil {
//                        CommentsView(user: AuthenViewModel.shared.currentUser!, feedCellViewModel: viewModel, commentViewModel: CommentViewModel(id: viewModel.postId))
//                    }else {
//                        ViewWithouLogin(actionBack: true)
//                    }
                    
                    //CommentsView(feedCellViewModel: viewModel, commentViewModel: CommentViewModel(id: viewModel.postId))
                   GroupCommentView(feedCellViewModel: viewModel, groupViewModel: GroupViewModel())
                })
                .frame(maxWidth: .infinity, alignment: .center)
                
                if #available(iOS 16.0, *) {
                    HStack (spacing: 5) {
                        Image("ic_share")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(Color.gray)
                        
                        Text(viewModel.newFeed.numshare ?? "")
                            .foregroundColor(Color.gray)
                            .padding(.leading, 5)
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .onTapGesture {
                        presentBottomSheet.toggle()
                    }
                    .sheet(isPresented: $presentBottomSheet) {
                        BottomSheetGroupNewFeed(viewModel: groupViewModel, actionDelete: $actionDelete, confirmDelete: $confirmDelete, url: viewModel.newFeed.linkpost ?? "", actionShare: true, postid: viewModel.postId, userid: viewModel.getUserID, groupid: viewModel.newFeed.groupid ?? "", showToast: {
                            self.showToast = true
                        }).presentationDetents([.height(250), .large])
                    }
                } else {
                    HStack (spacing: 5) {
                        Image("ic_share")
                            .resizable()
                            .frame(width: 30, height: 30)
                        
                        Text(viewModel.newFeed.numshare ?? "")
                            .foregroundColor(Color.gray)
                            .padding(.leading, 5)
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .onTapGesture {
                        showSheet.toggle()
                    }
                    .halfSheet(showSheet: $showSheet, sheetView: {
                        BottomSheetGroupNewFeed(viewModel: groupViewModel, actionDelete: $actionDelete, confirmDelete: $confirmDelete, url: viewModel.newFeed.linkpost ?? "", actionShare: true, postid: viewModel.postId, userid: viewModel.getUserID, groupid: viewModel.newFeed.groupid ?? "", showToast: {
                            self.showToast = true
                        })
                    })
                }
                
            }
            .padding(.leading, 15)
            .padding(.trailing, 20)
            
        }
        .padding(.leading, 10)
        .environmentObject(PostViewModel())
        .background(RoundedRectangle(cornerRadius: 0).fill(.white))
        .onAppear{
            //UIScrollView.appearance().bounces = false
        }
//        .fullScreenCover(isPresented: $isShowFullProfile, content: {
//            ProfileView(isShowBackPress: true,profileViewModel: ProfileViewModel(currentUserId: viewModel.getUserID,userDetailInfo: viewModel.initUserInfo()))
//        })
        
        Rectangle().fill(Color(red: 0.957, green: 0.957, blue: 0.957)).frame(height: 3)
    }
    

    
    private var asyncImage: some View  {
        AsyncImage(url: URL(string: viewModel.getLinkAvatarUser)) { phase in
            switch phase {
            case .empty:
                HStack {
                    Spacer()
                    ProgressView()
                    Spacer()
                }
                
            case .success(let image):
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                
            case .failure:
                HStack {
                    Spacer()
                    Image(systemName: "photo")
                        .imageScale(.large)
                    Spacer()
                }
                
                
            @unknown default:
                fatalError()
            }
        }
    }
}
