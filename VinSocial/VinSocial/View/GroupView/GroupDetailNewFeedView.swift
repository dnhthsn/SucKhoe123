//
//  GroupDetailNewFeed.swift
//  Suckhoe123
//
//  Created by Đinh Thái Sơn on 06/07/2023.
//

import SwiftUI

import Kingfisher
import _PhotosUI_SwiftUI

struct GroupDetailNewFeedView: View {
    @ObservedObject var groupViewModel: GroupViewModel
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
    @State var isLikedPost: Bool = false
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
//                        if !viewModel.checkOwnerPost{
//                            Button(action: {
//                                if AuthenViewModel.shared.currentUser != nil {
//                                    if (!viewModel.checkOwnerPost) {
//                                        
//                                        if viewModel.followStatus == "1" {
//                                            friendViewModel.makeFriend(friendid: viewModel.getUserID, act: "nofollow", verifykey: "")
//                                        } else {
//                                            if viewModel.isFriendStatus == "1" {
//                                                friendViewModel.makeFriend(friendid: viewModel.getUserID, act: "follow", verifykey: "")
//                                            } else {
//                                                friendViewModel.makeFriend(friendid: viewModel.getUserID, act: "accept_friend", verifykey: "")
//                                            }
//                                        }
//                                        
//                                        isFollow.toggle()
//                                    }
//                                } else {
//                                    showViewWithoutLogin.toggle()
//                                }
//                                
//                            }, label: {
//                                if (!isFollow) {
//                                    Image("ic_add")
//                                        .resizable()
//                                        .frame(width: 20, height: 20)
//                                }
//                                
//                                Text(isFollow ? "Đang theo dõi" : LocalizedStringKey("Label_Follow"))
//                                    .font(.system(size: 15))
//                                    .foregroundColor(isFollow ? Color(red: 23/255, green: 136/255, blue: 192/255) : .white)
//                                    .padding(.trailing, 5)
//                            })
//                            .frame(width: 110, height: 30)
//                            .background(isFollow ? Color(red: 238/255, green: 249/255, blue: 255/255) : Color(red: 23/255, green: 136/255, blue: 192/255))
//                            .cornerRadius(30)
//                            .padding(.leading, 8)
//                        }
                        
                        
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
                    
                    WebHTMLText(height: 77, html: (viewModel.newFeed.content ?? ""), checkCustom: false)
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
                        
                    let collumns = Array(repeating: GridItem(.flexible(), spacing: 5), count: 2)
                    
                    LazyVGrid(columns: collumns, alignment: .leading, spacing: 5, content: {
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
                }
                .padding(.top, 20)
                .padding([.leading, .trailing], 5)
                .onAppear{
                    UIScrollView.appearance().bounces = false
                    DispatchQueue.global(qos: .background).async {
                        do {
                            DispatchQueue.main.async {
                                content = (viewModel.newFeed.hometext ?? "").htmlToString()
                                nameUser = (viewModel.nameUser).htmlToString()
                                title = (viewModel.title).htmlToString()
                            }
                        } catch {

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
                    groupViewModel.removeCacheComment()
                    Task{
                        await groupViewModel.loadFirstPageComment(act: "getComment", cid: "", id: viewModel.postId, pid: "", sortcomm: String(output))
                    }
                }
                .onAppear {
                    Task{
                        await groupViewModel.loadFirstPageComment(act: "getComment", cid: "", id: viewModel.postId, pid: "", sortcomm: "1")
                    }
                }
                //.environmentObject(commentViewModel)
                .onTapGesture {
                    dismissKeyboard()
                }
        //        .fullScreenCover(isPresented: $showLoginView, content: {
        //            LoginView(onLoginCallBackForHome: loadData)
        //                .environmentObject(viewModel)
        //                .environmentObject(homeViewModel)
        //        })
            }
            
            Spacer()
            
            if AuthenViewModel.shared.currentUser != nil {
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
                    
                    Image("ic_image")
                        .resizable()
                        .frame(width: 35, height: 35)
                    
                    Image("ic_send")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .onTapGesture {
//                            commentViewModel.postComment(id: feedCellViewModel.postId, cid: "", pid: "", reptouserid: "", content: commentText, photo_comment: [MediaUploadFile(mediaType: "", data: Data())])
//    //                        commentViewModel.loadFirstPage(cid: "", id: feedCellViewModel.postId, pid: "", sortcomm: sortId)
                            groupViewModel.postGroupComment(act: "comment", id: viewModel.postId, cid: "", pid: "", reptouserid: "", content: commentText, photo_comment: [MediaUploadFile(mediaType: "", data: Data())])
                            commentText = ""
                        }
                    
                }
                .padding([.vertical, .horizontal])
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(Color.white, lineWidth: 1)
                        
                ).background(RoundedRectangle(cornerRadius: 6).fill(.white).shadow(radius: 5).frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center).ignoresSafeArea())
                .ignoresSafeArea()
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
                ForEach(groupViewModel.commentResponse) {comment in
                    //listRowView(for: comment)
                    if comment.comment_id == groupViewModel.commentResponse.last?.comment_id {
                        listRowView(comment: comment, viewModel: groupViewModel, postid: viewModel.newFeed.postid ?? "")
                            .task { await groupViewModel.loadNextPageComment(act: "getComment", cid: "", id: viewModel.postId, pid: "", sortcomm: "1") }
                        
                        if groupViewModel.isFetchingNextPageComment {
                            bottomProgressView
                        }
                        
                    } else {
                        listRowView(comment: comment, viewModel: groupViewModel, postid: viewModel.newFeed.postid ?? "")
                    }
                    Divider()
                }
                .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                .listRowSeparator(.hidden)
            }
        }
        
    }
    
    @ViewBuilder
    private func listRowView(comment: CommentResponse, viewModel: GroupViewModel, postid: String) -> some View {
        GroupCommentCell(viewModel: viewModel, commentCellViewModel: CommentCellViewModel(comment), postid: postid)

    }
}
