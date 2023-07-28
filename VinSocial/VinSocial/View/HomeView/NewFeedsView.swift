//
//  NewFeedsView.swift
//  VinSocial
//
//  Created by Stealer Of Souls on 3/21/23.
//

import SwiftUI
import Kingfisher

struct NewFeedsView: View {
    @ObservedObject var viewModel:HomeViewModel
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
                
                TabView(selection: self.$currentTab) {
                    listView
                        .tag(0)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .edgesIgnoringSafeArea(.all)
                .onAppear{
                    if (showType == TypeShowScreen.VIDEO || showType == TypeShowScreen.PHOTO){
                        Task{await viewModel.loadCatalog(act: "", catid: "", checkVideoOrPhoto: showType)}
                    }
                }
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
    
    @ViewBuilder
    private var listView: some View {
        ScrollView {
            VStack {
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
                    let newFeeds = isSearching ? viewModel.newFeedSearchs : viewModel.newFeeds
                    ForEach(newFeeds) { newfeed in
                        if newfeed.postid == newFeeds.last?.postid && !viewModel.isCreatePost{
                            listRowView(for: newfeed)
                                .task {
                                    if isSearching{
                                        
                                    }else{
                                        await viewModel.loadNextPage()
                                    }
                                    
                                }
                            
                            if viewModel.isFetchingNextPage {
                                //bottomProgressView
                            }
                            
                        } else {
                            listRowView(for: newfeed)
                        }
                        
                    }
                    
                }
                .padding(.top, 2)
            }
            
            
        }
        .refreshable {
            viewModel.removeCache()
            Task {
                await viewModel.loadFirstPage()
            }
        }
    }
    
    private func getCatID()->String{
        var catid = ""
        if viewModel.listCatalogs(showType: showType).count > 0 {
            if currentTab < viewModel.listCatalogs(showType: showType).count{
                let catalog =  viewModel.listCatalogs(showType:showType)[currentTab]
                catid = catalog.catid ?? ""
                
            }
        }
        return catid
    }
    
    
    @ViewBuilder
    private func listRowView(for newFeed: NewFeed) -> some View {
        NewFeedRowView(homeViewModel:viewModel,newFeed: newFeed, isOwner: false, showToast: $showToast)
        
    }
}



struct NewFeedRowView: View {
    @ObservedObject var homeViewModel:HomeViewModel
    @ObservedObject var viewModel:FeedCellViewModel
    @ObservedObject var friendViewModel: FriendViewModel = FriendViewModel()
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
    @State var isLiked: Bool = false
    @State var content: String = ""
    @State var nameUser: String = ""
    @State var title: String = ""
    @State var showViewWithoutLogin: Bool = false
    @State var showFullNewFeed: Bool = false
    @State var showFullContent: Bool = false
    @State var showFullImage: Bool = false
    @State var position: Int = 1
    @State var imageContent: String = ""
    @Binding var showToast: Bool
    
    init(homeViewModel: HomeViewModel, newFeed: NewFeed, isOwner: Bool, showToast: Binding<Bool>) {
        _showToast = showToast
        self.homeViewModel = homeViewModel
        self.viewModel = FeedCellViewModel(newFeed)
        self.isOwner = isOwner
    }
    
    var body: some View {
        LazyVStack {
            HStack {
                Button {
                    isShowFullProfile.toggle()
                } label: {
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
                    
                    
                    VStack {
                        Text(nameUser)
                            .font(.headline)
                            .font(.footnote.weight(.bold))
                            .multilineTextAlignment(.leading)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .frame(height: 20)
                            .truncationMode(.tail)
                            .foregroundColor(Color.black)
                        
                        if CheckTime().getCurrentTime() == CheckTime().convertTime(time: Int(viewModel.newFeed.addtime ?? "") ?? 0) {
                            Text("• Vừa xong")
                                .foregroundColor(Color.gray)
                                .font(.system(size: 16))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .truncationMode(.tail)
                                .frame(height: 30)
                        } else {
                            Text("\(CheckTime().compareTime(timeArr1: CheckTime().convertTime(time: Int(viewModel.newFeed.addtime ?? "") ?? 0), timeArr2: CheckTime().getCurrentTime()))")
                                .foregroundColor(Color.gray)
                                .font(.system(size: 16))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .truncationMode(.tail)
                                .frame(height: 30)
                        }
                    }
                    
                }
                .fullScreenCover(isPresented: $isShowFullProfile, content: {
                    ProfileView(user: nil, isShowBackPress: true,profileViewModel: ProfileViewModel(currentUserId: viewModel.getUserID,userDetailInfo: viewModel.initUserInfo(),"From newFeed"), friendViewModel: FriendViewModel())
                })
                if !viewModel.checkOwnerPost{
                    Button(action: {
                        if AuthenViewModel.shared.currentUser != nil {
                            if (!viewModel.checkOwnerPost) {
                                
                                if viewModel.followStatus == "1" {
                                    friendViewModel.makeFriend(friendid: viewModel.getUserID, act: "nofollow", verifykey: "")
                                    
                                    NotificationCenter.default.addObserver(forName: Notification.Name("nofollow"), object: nil, queue: nil) { notification in
                                        if let friendid = notification.object as? String {
                                            NotificationCenter.default.addObserver(forName: Notification.Name("act_nofollow"), object: nil, queue: nil) { notification in
                                                if let act = notification.object as? String {
                                                    homeViewModel.updateFollowStatus(friendid: friendid, act: act)
                                                }
                                            }
                                        }
                                    }
                                } else {
                                    if viewModel.isFriendStatus == "1" {
                                        friendViewModel.makeFriend(friendid: viewModel.getUserID, act: "follow", verifykey: "")
                                        
                                        NotificationCenter.default.addObserver(forName: Notification.Name("follow"), object: nil, queue: nil) { notification in
                                            if let friendid = notification.object as? String {
                                                NotificationCenter.default.addObserver(forName: Notification.Name("act_follow"), object: nil, queue: nil) { notification in
                                                    if let act = notification.object as? String {
                                                        homeViewModel.updateFollowStatus(friendid: friendid, act: act)
                                                    }
                                                }
                                            }
                                        }
                                    } else {
                                        friendViewModel.makeFriend(friendid: viewModel.getUserID, act: "accept_friend", verifykey: "")
                                        
                                        NotificationCenter.default.addObserver(forName: Notification.Name("accept_friend"), object: nil, queue: nil) { notification in
                                            if let friendid = notification.object as? String {
                                                NotificationCenter.default.addObserver(forName: Notification.Name("act_accept_friend"), object: nil, queue: nil) { notification in
                                                    if let act = notification.object as? String {
                                                        homeViewModel.updateFollowStatus(friendid: friendid, act: act)
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                                
                                isFollow.toggle()
                            }
                        } else {
                            showViewWithoutLogin.toggle()
                        }
                        
                    }, label: {
                        if (viewModel.newFeed.user_info?.friend_info?.follow != "1") {
                            Image("ic_add")
                                .resizable()
                                .frame(width: 20, height: 20)
                        }
                        
                        Text(viewModel.newFeed.user_info?.friend_info?.follow == "1" ? "Đang theo dõi" : LocalizedStringKey("Label_Follow"))
                            .font(.system(size: 15))
                            .foregroundColor(viewModel.newFeed.user_info?.friend_info?.follow == "1" ? Color(red: 23/255, green: 136/255, blue: 192/255) : .white)
                            .padding(.trailing, 5)
                    })
                    .frame(width: 110, height: 30)
                    .background(viewModel.newFeed.user_info?.friend_info?.follow == "1" ? Color(red: 238/255, green: 249/255, blue: 255/255) : Color(red: 23/255, green: 136/255, blue: 192/255))
                    .cornerRadius(30)
                    .padding(.leading, 8)
                    .fullScreenCover(isPresented: $showViewWithoutLogin, content: {
                        ViewWithouLogin(actionBack: true).environmentObject(AuthenViewModel()).environmentObject(homeViewModel)
                            .ignoresSafeArea(.all, edges: .top)
                    })
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
                            BottomSheetNewFeed(actionDelete: $actionDelete, confirmDelete: $confirmDelete, url: viewModel.newFeed.linkpost ?? "", actionShare: false, postid: viewModel.postId , userid: viewModel.getUserID, showToast: {
                                self.showToast = true
                            }).presentationDetents([.height(viewModel.checkOwnerPost ? 200 : 100), .large])
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
                            BottomSheetNewFeed(actionDelete: $actionDelete, confirmDelete: $confirmDelete, url: viewModel.newFeed.linkpost ?? "", actionShare: false, postid: viewModel.postId , userid: viewModel.getUserID, showToast: {
                                self.showToast = true
                            })
                        })
                }
                
            }
            
            
            
            //            ExpandableText(text: viewModel.newFeed.hometext!.htmlToString())
            //                        .font(.body)//optional
            //                        .foregroundColor(.primary)//optional
            //                        .lineLimit(3)//optional
            //                        .expandButton(TextSet(text: "Xem thêm", font: .body, color: .blue))
            //                        .collapseButton(TextSet(text: "Thu nhỏ", font: .body, color: .blue))
            //                        .expandAnimation(.easeOut)
            //            ExpandableTextView(text: content, maxLines: 3)
            //                .padding(.trailing, 10)
            
            VStack {
                Text(title)
                    .font(.system(size: 18, weight: .bold))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(Color.black)
                    .padding(.trailing, 10)
                
                WebHTMLText(height: 77, html: (viewModel.newFeed.hometext ?? ""), checkCustom: (!showFullContent && viewModel.newFeed.hometext?.count ?? 0 >= 120))
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
                        DetailNewFeedView(commentViewModel: CommentViewModel(id: viewModel.postId,test: "NewFeedsView"), viewModel: viewModel, friendViewModel: friendViewModel)
                    })
                
                if viewModel.newFeed.hometext?.count ?? 0 >= 120 {
                    Button(action: {
                        showFullContent.toggle()
                    }, label: {
                        Text(showFullContent ? "Thu nhỏ" : "Xem thêm")
                            .foregroundColor(Color.blue)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    })
                    .padding(.top, 10)
                }
                
            }
            .background(viewModel.newFeed.media?.isEmpty ?? false ? KFImage(URL(string: self.imageContent))
                .resizable() : KFImage(URL(string: ""))
                .resizable())
            
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
            .padding(.top, 10)
            
            HStack {
                HStack (spacing: 5) {
                    if viewModel.newFeed.like != nil {
                        Image(viewModel.newFeed.like == "0" ? "ic_heart_reaction" : "ic_liked")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .onTapGesture {
                                if AuthenViewModel.shared.currentUser != nil {
                                    isLiked.toggle()
                                    homeViewModel.likePost(id: viewModel.newFeed.postid ?? "")
                                } else {
                                    showViewWithoutLogin.toggle()
                                }
                            }
                            .fullScreenCover(isPresented: $showViewWithoutLogin, content: {
                                ViewWithouLogin(actionBack: true).environmentObject(AuthenViewModel()).environmentObject(homeViewModel)
                                    .ignoresSafeArea(.all, edges: .top)
                            })
                    } else {
                        Image("ic_heart_reaction")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .onTapGesture {
                                if AuthenViewModel.shared.currentUser != nil {
                                    isLiked.toggle()
                                    homeViewModel.likePost(id: viewModel.newFeed.postid ?? "")
                                } else {
                                    showViewWithoutLogin.toggle()
                                }
                            }
                            .fullScreenCover(isPresented: $showViewWithoutLogin, content: {
                                ViewWithouLogin(actionBack: true).environmentObject(AuthenViewModel()).environmentObject(homeViewModel)
                                    .ignoresSafeArea(.all, edges: .top)
                            })
                    }
                    
                    
                    Text("\((viewModel.newFeed.numLikes == "" ? String(viewModel.getLike) : viewModel.newFeed.numLikes) ?? "")")
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
                    
                    Text((viewModel.newFeed.numComments == "" ? viewModel.getComment : viewModel.newFeed.numComments) ?? "")
                        .foregroundColor(Color.gray)
                }
                .onTapGesture {
                    showComments.toggle()
                }
                .fullScreenCover(isPresented: $showComments, content: {
                    CommentsView(feedCellViewModel: viewModel,idPost: viewModel.postId)
                })
                .frame(maxWidth: .infinity, alignment: .center)
                
                if #available(iOS 16.0, *) {
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
                        presentBottomSheet.toggle()
                    }
                    .sheet(isPresented: $presentBottomSheet) {
                        BottomSheetNewFeed(actionDelete: $actionDelete, confirmDelete: $confirmDelete, url: viewModel.newFeed.linkpost ?? "", actionShare: true, postid: viewModel.postId , userid: viewModel.getUserID, showToast: {
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
                        BottomSheetNewFeed(actionDelete: $actionDelete, confirmDelete: $confirmDelete, url: viewModel.newFeed.linkpost ?? "", actionShare: true, postid: viewModel.postId , userid: viewModel.getUserID, showToast: {
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
            homeViewModel.getLayoutContent()
            
            NotificationCenter.default.addObserver(forName: Notification.Name("CommentPost"), object: nil, queue: nil) { notification in
                if let postid = notification.object as? String {
                  //ViewModel sẽ add thêm vào
                    NotificationCenter.default.addObserver(forName: Notification.Name("NumComment"), object: nil, queue: nil) { notification1 in
                        if let numComments = notification1.object as? String {
                          //ViewModel sẽ add thêm vào
                            homeViewModel.updateNumcomment(postId: postid, numComment: numComments)
                            
                        }
                    }
                }
            }
            
            for image in homeViewModel.layoutContentImage {
                
                if image.components(separatedBy: "/")[4] == "\(viewModel.newFeed.layoutid ?? "").jpg" {
                    self.imageContent = "https://ws.suckhoe123.vn\(image)"
                } else {
                    self.imageContent = ""
                }
            }
            DispatchQueue.global(qos: .background).async {
                do {
                    DispatchQueue.main.async {
                        content = (viewModel.newFeed.hometext ?? "").htmlToString()
                        nameUser = (viewModel.nameUser).htmlToString()
                        title = (viewModel.title).htmlToString()
                    }
                }
            }
            
            
        }
        
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

extension String {
    func htmlToString() -> String {
        guard let data = self.data(using: .utf8) else {
            return self
        }
        do {
            let attributedString = try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
            return attributedString.string
        } catch {
            print("Error converting HTML string: \(error.localizedDescription)")
            return self
        }
    }
}

struct TabBarView: View {
    @Binding var currentTab: Int
    @Namespace var namespace
    var tabBarOptions: [ListCatalog]
    @ObservedObject var viewModel:HomeViewModel
    @Binding var showType: TypeShowScreen
    
    
    var body: some View {
        ScrollView(.horizontal){
            LazyHStack{
                ForEach(Array(zip(self.tabBarOptions.indices, self.tabBarOptions)), id: \.0) { index, item in
                    TabBarItem(currentTab: self.$currentTab, namespace: namespace.self, tabBarItemName: item.title ?? "", tab: index,viewModel: viewModel,showType: $showType)
                }
            }
        }
        .padding(.horizontal)
        .background(Color.white)
        .frame(height: 80)
        .edgesIgnoringSafeArea(.all)
        
    }
}

struct TabBarItem: View {
    
    @Binding var currentTab: Int
    let namespace: Namespace.ID
    var tabBarItemName: String
    var tab: Int
    @ObservedObject var viewModel:HomeViewModel
    @Binding var showType: TypeShowScreen
    
    
    var body: some View {
        VStack{
            HStack{
                Text(tabBarItemName)
                    .font(.system(size: 15))
                    .foregroundColor(Color(red: 23/255, green: 136/255, blue: 192/255))
                    .padding([.top, .bottom], 5)
                    .padding(.trailing, 10)
            }
            .frame(width: 140, height: 45)
            .overlay(
                RoundedRectangle(cornerRadius: 30)
                    .stroke(currentTab==tab ? Color(red: 238/255, green: 249/255, blue: 255/255) : Color(red: 244/255, green: 244/255, blue: 244/255), lineWidth: 1)
                
            ).background(RoundedRectangle(cornerRadius: 30).fill(currentTab==tab ? Color(red: 238/255, green: 249/255, blue: 255/255) : Color(red: 244/255, green: 244/255, blue: 244/255)))
            
        }.onTapGesture{
            self.currentTab = tab
            // gọi loading ở đây mới đúng này.
            let catalog = getCatID()
            Task{await viewModel.loadCatalog(act:"" ,catid:catalog,checkVideoOrPhoto: showType)}
        }
    }
    
    private func getCatID()->String{
        var catid = ""
        if viewModel.listCatalogs(showType: showType).count > 0 {
            if currentTab < viewModel.listCatalogs(showType: showType).count{
                let catalog =  viewModel.listCatalogs(showType: showType)[currentTab]
                catid = catalog.catid ?? ""
                
            }
        }
        return catid
    }
}
