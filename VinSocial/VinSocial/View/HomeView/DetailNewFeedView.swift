//
//  DetailNewFeedView.swift
//  Suckhoe123
//
//  Created by Đinh Thái Sơn on 04/07/2023.
//

import SwiftUI
import Kingfisher
import _PhotosUI_SwiftUI

struct DetailNewFeedView: View {
    @ObservedObject var homeViewModel = HomeViewModel()
    @ObservedObject var commentViewModel: CommentViewModel
    @ObservedObject var viewModel:FeedCellViewModel
    @ObservedObject var friendViewModel: FriendViewModel
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
    
    @State var showLoginView: Bool = false
    @State private var commentText = ""
    @State var selected = "Mới nhất"
    @State var sortId = 1
    //private let user: UserResponse
    @State var selectedItem: PhotosPickerItem? = nil
    @State var selectedImageData: Data?
    @State var showFullImage: Bool = false
    @State var position: Int = 1
    @State var showToast: Bool = false
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            ScrollView {
                VStack {
                    HStack {
                        Image("ic_back_arrow")
                            .resizable()
                            .frame(width: 26, height: 26)
                            .foregroundColor(Color.black)
                            .onTapGesture {
                                dismiss()
                            }
                        
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
                                    }).presentationDetents([.height(250), .large])
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
                    
                    Text(title)
                        .font(.system(size: 18, weight: .bold))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(Color.black)
                        .padding(.trailing, 10)
                    
                    WebHTMLText(height: 77, html: (viewModel.newFeed.hometext ?? ""), checkCustom: false)
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
                            Text("Đang tải")
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
                    .padding(.top, 10)
                    
                    HStack {
                        HStack (spacing: 5) {
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
                            
                            Text(viewModel.getComment)
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
                .padding(.top, 20)
                .padding([.leading, .trailing], 15)
                .onAppear{
                    UIScrollView.appearance().bounces = false
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
                
                VStack {
                    
                    Menu {
                        Button(action: {
                            selected = "Mới nhất"
                            sortId = 1
                        }, label: {
                            Text("Mới nhất")
                                .foregroundColor(Color.black)
                                .font(.system(size: 15))
                        })
                        
                        Button(action: {
                            selected = "Nhiều like nhất"
                            sortId = 2
                        }, label: {
                            Text("Nhiều like nhất")
                                .foregroundColor(Color.black)
                                .font(.system(size: 15))
                        })
                        
                        Button(action: {
                            selected = "Cũ nhất"
                            sortId = 3
                        }, label: {
                            Text("Cũ nhất")
                                .foregroundColor(Color.black)
                                .font(.system(size: 15))
                        })
                    } label: {
                        Label(title: {
                            Text("\(selected)")
                                .foregroundColor(Color.black)
                                .font(.system(size: 15))
                            Image("ic_drop_down")
                        }, icon: {})
                    }
                    .padding([.top, .bottom], 5)
                    .padding([.leading, .trailing], 10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(Color(red: 158/255, green: 158/255, blue: 158/255), lineWidth: 1)
                            
                    )
                    .background(RoundedRectangle(cornerRadius: 6).fill(.white))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 20)
                    
                    listView
                    
                    
                    
                }
                .onChange(of: sortId) { output in
                    commentViewModel.removeCacheComment()
                    Task{
                        await commentViewModel.loadFirstPage(cid: "", pid: "", sortcomm: output)
                    }
                }
                .onAppear {
                    Task{
                        await commentViewModel.loadFirstPage(cid: "", pid: "", sortcomm: 1)
                    }
                }
                //.environmentObject(commentViewModel)
                .onTapGesture {
                    dismissKeyboard()
                }
                .fullScreenCover(isPresented: $showLoginView, content: {
//                    LoginView(onLoginCallBackForHome: loadData)
//                        .environmentObject(viewModel)
//                        .environmentObject(homeViewModel)
                    
                    LoginTypeView(viewModel: AuthenViewModel(), homeViewModel: homeViewModel, onLoginCallBackForHome: {
                        loadData()
                    })
                })
            }
            
            Spacer()
            
            if AuthenViewModel.shared.currentUser != nil {
                VStack {
                    if let selectedImageData,
                       let uiImage = UIImage(data: selectedImageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 120, height: 120)
                            .cornerRadius(10)
                    }
                    
                    HStack {
                        KFImage(URL(string: AuthenViewModel.shared.currentUser?.photo! ?? ""))
                            .resizable()
                            .scaledToFill()
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                        
                        TextField("", text: $commentText)
                            .placeholder(when: commentText.isEmpty) {
                                Text(LocalizedStringKey("Label_Write_Comments"))
                                    .foregroundColor(Color(red: 158/255, green: 158/255, blue: 158/255))
                            }
                            .padding(10)
                            .background(RoundedRectangle(cornerRadius: 30).fill(Color(red: 245/255, green: 245/255, blue: 245/255)))
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        PhotosPicker (
                            selection: $selectedItem,
                            matching: .images,
                            photoLibrary: .shared()) {
                                Image("ic_image")
                                    .resizable()
                                    .frame(width: 35, height: 35)
                            }
                            .onChange(of: selectedItem) { newItem in
                                Task {
                                    if let data = try? await newItem?.loadTransferable(type: Data.self) {
                                        selectedImageData = data
                                    }
                                }
                            }
                        
                        Image("ic_send")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .onTapGesture {
                                commentViewModel.postComment(id: viewModel.postId, cid: "", pid: "", reptouserid: "", content: commentText, photo_comment: selectedImageData ?? Data())
                                commentText = ""
                            }
                        
                    }
                    .padding([.vertical, .horizontal])
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(Color.white, lineWidth: 1)
                            
                    ).background(RoundedRectangle(cornerRadius: 6).fill(.white).shadow(radius: 5).frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center).ignoresSafeArea())
                    .ignoresSafeArea()
                }
                
            }else {
                VStack {
                    Rectangle().fill(Color(red: 0.957, green: 0.957, blue: 0.957)).frame(height: 3)
                    
                    Text("Bạn cần đăng nhập để bình luận")
                        .foregroundColor(Color.blue)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 24.0)
                    Button(action: {
                        //loadingToggle.toggle()
                        showLoginView.toggle()
                        
                    }, label: {
                        Text(LocalizedStringKey("Label_Login"))
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(width: 150, height: 50)
                            .background(Color(red: 23/255, green: 136/255, blue: 192/255))
                            .cornerRadius(30)
                    })
                    .padding(.leading, 10)
                    .shadow(radius: 5)
                }
            }
        }
        .gesture(
            DragGesture()
                .onEnded { gesture in
                    if gesture.translation.width > 100 {
                        dismiss()
                    }
                }
        )
        .overlay(
            overlayView: ToastView(toast: Toast(title: "Đã sao chép" , image: ""), show: $showToast), show: $showToast
        )
    }
    
    func loadData(){
        
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
    
    private var listView: some View {
        ScrollView {
            LazyVStack {
                ForEach(commentViewModel.comments) {comment in
                    //listRowView(for: comment)
                    if comment.comment_id == commentViewModel.comments.last?.comment_id {
                        listRowView(for: comment)
                            .task { await commentViewModel.loadNextPage(cid: "", pid: "", sortcomm: 1) }
                        
                        if commentViewModel.isFetchingNextPage {
                            bottomProgressView
                        }
                        
                    } else {
                        listRowView(for: comment)
                    }
                    Divider()
                }
                .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                .listRowSeparator(.hidden)
            }
        }
        
    }
    
    @ViewBuilder
    private func listRowView(for comment: CommentResponse) -> some View {
        CommentCell(viewModel: commentViewModel, commentCellViewModel: CommentCellViewModel(comment))

    }
}
