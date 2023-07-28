//
//  DoctorPageView.swift
//  Suckhoe123
//
//  Created by Đinh Thái Sơn on 29/06/2023.
//

import SwiftUI
import Kingfisher

struct DoctorPageView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: ProfileViewModel
    let doctorid: String
    let act: String
    @State var showWritePostView: Bool = false
    @State var showLibrary: Bool = false
    
    @State var showEditView: Bool = false
    @State var showSupportQuestionView: Bool = false
    @State var showToast: Bool = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack {
                    HStack {
                        KFImage(URL(string: "https://ws.suckhoe123.vn\(viewModel.expertDetail?.avatar ?? "")"))
                            .resizable()
                            .scaledToFill()
                            .frame(width: 90, height: 90)
                            .clipShape(Circle())
                            .overlay(Circle().frame(width: 0,height: 0)
                                    .padding(6)
                                    .background(Color.green)
                                    .clipShape(Circle())
                                    .padding(4)
                                    .background(Color.white)
                                    .clipShape(Circle())
                                    .offset(x: -5, y: 6)
                                
                                ,alignment: .bottomTrailing
                            )
                            //.padding(.top, isShowBackPress ? 0 : 32)
                            .padding(5)
                        
                        VStack(alignment: .center, spacing: 4) {
                            if act == "lam-dep" {
                                Text("Bác sĩ thẩm mỹ")
                                    .foregroundColor(Color.gray)
                                    .font(.subheadline)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            } else {
                                Text("Bác sĩ sức khoẻ")
                                    .foregroundColor(Color.gray)
                                    .font(.subheadline)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            
                            
                            Text((viewModel.expertDetail?.fullname ?? "").htmlToString())
                                .font(.title2)
                                .foregroundColor(Color.black)
                                .font(.footnote.weight(.bold))
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            
                            HStack(spacing: 5) {
                                if doctorid == AuthenViewModel.shared.currentUser?.userid {
                                    HStack{
                                        Image("ic_edit")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 15,height: 15)
                                            .foregroundColor(Color(red: 23/255, green: 136/255, blue: 192/255))
                                            .padding([.top, .bottom], 5)
                                            .padding(.leading, 10)
                                        
                                        Text("Chỉnh sửa")
                                            .font(.system(size: 13))
                                            .foregroundColor(Color(red: 23/255, green: 136/255, blue: 192/255))
                                            .padding([.top, .bottom], 5)
                                            .padding(.trailing, 10)
                                            
                                       
                                    }
                                    .onTapGesture {
                                        //showEditView.toggle()
                                    }
                                    .fullScreenCover(isPresented: $showEditView, content: {
                                        //EditInformationView(user: user,profileViewModel: profileViewModel)
                                    })
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 30)
                                            .stroke(Color(red: 238/255, green: 249/255, blue: 255/255), lineWidth: 1)
                                            
                                    )
                                    .background(RoundedRectangle(cornerRadius: 30).fill(Color(red: 238/255, green: 249/255, blue: 255/255)))
                                }
                                
                                
                                HStack{
                                    Image("ic_refresh")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 15,height: 15)
                                        .foregroundColor(Color(red: 23/255, green: 136/255, blue: 192/255))
                                        .padding([.top, .bottom], 5)
                                        .padding(.leading, 10)
                                    
                                    Text("Trang cá nhân")
                                        .font(.system(size: 13))
                                        .foregroundColor(Color(red: 23/255, green: 136/255, blue: 192/255))
                                        .padding([.top, .bottom], 5)
                                        .padding(.trailing, 10)
                                        
                                   
                                }
                                .onTapGesture {
                                    dismiss()
                                    viewModel.removeCacheExpertNewFeed()
                                }
                                .overlay(
                                    RoundedRectangle(cornerRadius: 30)
                                        .stroke(Color(red: 238/255, green: 249/255, blue: 255/255), lineWidth: 1)
                                        
                                )
                                .background(RoundedRectangle(cornerRadius: 30).fill(Color(red: 238/255, green: 249/255, blue: 255/255)))
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            
                        }
                    }
                    .padding([.leading, .trailing], 15)
                    
                    Rectangle().fill(Color(red: 0.957, green: 0.957, blue: 0.957)).frame(height: 2)
                    
                    VStack {
                        Button(action: {
                            showWritePostView.toggle()
                            
                        }, label: {
                            Image("ic_edit")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .foregroundColor(Color.white)
                            
                            Text(LocalizedStringKey("Label_Post_Status"))
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding([.top, .bottom])
                        })
                        .frame(maxWidth: .infinity)
                        .background(Color(red: 23/255, green: 136/255, blue: 192/255))
                        .cornerRadius(10)
                        .shadow(radius: 5)
                        .fullScreenCover(isPresented: $showWritePostView, content: {
//                            if AuthenViewModel.shared.currentUser != nil {
////                                WritePostView(user: AuthenViewModel.shared.currentUser!,homeViewModel: HomeViewModel(), isEditPost: false, postid: "")
//
//
//                            }else{
//
//                            }
                            
                            ExpertWritePostView(expertDetail: viewModel.expertDetail, viewModel: viewModel, category: act, isEditPost: false, postid: "")
                        })
                        
                        HStack {
                            Image("ic_education")
                                .resizable()
                                .frame(width: 30, height: 30)
                            
                            Text(LocalizedStringKey("Label_Education \(viewModel.expertDetail?.email ?? "")"))
                                .foregroundColor(Color.black)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.leading, 5)
                        }
                        
                        HStack {
                            Image("ic_location")
                                .resizable()
                                .frame(width: 30, height: 30)
                            
                            Text(LocalizedStringKey("Label_Location \(viewModel.expertDetail?.address ?? "")"))
                                .foregroundColor(Color.black)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.leading, 5)
                        }
                    }
                    .padding([.leading, .trailing], 15)
                    
                    Rectangle().fill(Color(red: 0.957, green: 0.957, blue: 0.957)).frame(height: 2)
                    
                    HStack {
                        HStack {
                            Image("ic_posts")
                                .resizable()
                                .frame(width: 25, height: 25)

                            Text("Bài đăng")
                                .foregroundColor(Color.gray)
                                .font(.system(size: 15))
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        HStack {
                            Image("ic_support")
                                .resizable()
                                .frame(width: 25, height: 25)

                            Text("Hỏi đáp")
                                .foregroundColor(Color.gray)
                                .font(.system(size: 15))
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                        .onTapGesture {
                            showSupportQuestionView.toggle()
                        }
                        .fullScreenCover(isPresented: $showSupportQuestionView, content: {
                            SupportQuestionView(viewModel: viewModel, category: act, doctorid: doctorid)
                        })

                        HStack {
                            Image("ic_library")
                                .resizable()
                                .frame(width: 25, height: 25)

                            Text(LocalizedStringKey("Label_Library"))
                                .foregroundColor(Color(red: 23/255, green: 136/255, blue: 192/255))
                                .font(.system(size: 15))
                                .font(.footnote.weight(.bold))
                        }
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .onTapGesture {
                            showLibrary.toggle()
                        }
                        .fullScreenCover(isPresented: $showLibrary, content: {
                            //LibraryView(mediaUserViewModel: MediaUserViewModel())
                            ExpertLibraryView(viewModel: viewModel, category: act, doctorid: doctorid)
                        })


                    }
                    .padding([.leading, .trailing])

                    Rectangle().fill(Color(red: 0.957, green: 0.957, blue: 0.957)).frame(height: 2)
                    
                    if viewModel.expertNewFeed.isEmpty {
                        ShimmerView()
                    }else{
                        listView
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    }
                }
                .onAppear {
                    DispatchQueue.main.async {
                        Task {
                            await viewModel.loadFirstPageExpertNewFeed(category: act, doctorid: doctorid, act: "blog")
                        }
                    }
                    
                }
                .onDisappear {
                    viewModel.removeCacheExpertNewFeed()
                }
            }
            .overlay(
                overlayView: ToastView(toast: Toast(title: "Đã sao chép" , image: ""), show: $showToast), show: $showToast
            )
        }
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
//            LazyVStack{
                ForEach(viewModel.expertNewFeed) { newfeed in
                    if newfeed.postid == viewModel.expertNewFeed.last?.postid {
                        listRowView(for: newfeed, profileViewModel: viewModel, category: act)
                            .task{
                               await viewModel.loadNextPageExpertNewFeed(category: act, doctorid: doctorid, act: "blog")
                            }
                           
                        if (viewModel.isFetchingNextPageExpertNewFeed  && !viewModel.shouldLoadNextPageExpertNewFeed) {
                            bottomProgressView
                        }
                        
                    } else {
                        listRowView(for: newfeed, profileViewModel: viewModel, category: act)
                    }
                }
                .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                .listRowSeparator(.hidden)
//            }
//            .padding(.top, 2)
            
    }
    

    @ViewBuilder
    private func listRowView(for newFeed: NewFeed, profileViewModel: ProfileViewModel, category: String) -> some View {
        ExpertNewFeedRowView(profileViewModel: profileViewModel, viewModel: FeedCellViewModel(newFeed), friendViewModel: FriendViewModel(),isOwner: true, category: category, showToast: $showToast)

    }
}
struct ExpertNewFeedRowView: View {
    @ObservedObject var profileViewModel: ProfileViewModel
    @ObservedObject var homeViewModel = HomeViewModel()
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
    var category: String
    @Binding var showToast: Bool
    
    var body: some View {
        VStack {
            
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
                    }

                }
                .fullScreenCover(isPresented: $isShowFullProfile, content: {
                    ProfileView(user: nil, isShowBackPress: true,profileViewModel: ProfileViewModel(currentUserId: viewModel.getUserID,userDetailInfo: viewModel.initUserInfo(),"Doctor page"), friendViewModel: FriendViewModel())
                })
                
                Button(action: {
                    if AuthenViewModel.shared.currentUser != nil {
                        if (!viewModel.checkOwnerPost) {
                            
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
                        }
                    } else {
                        showViewWithoutLogin.toggle()
                    }
                    
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
                .fullScreenCover(isPresented: $showViewWithoutLogin, content: {
                    ViewWithouLogin(actionBack: true).environmentObject(AuthenViewModel()).environmentObject(homeViewModel)
                        .ignoresSafeArea(.all, edges: .top)
                })
                
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
                            
                            ExpertBottomSheetNewFeed(viewModel: profileViewModel, actionDelete: $actionDelete, confirmDelete: $confirmDelete, url: viewModel.newFeed.linkpost ?? "", actionShare: false, postid: viewModel.postId, userid: viewModel.getUserID, category: category).presentationDetents([.height(250), .large])
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
            
//            ExpandableText(text: viewModel.newFeed.hometext!.htmlToString())
//                        .font(.body)//optional
//                        .foregroundColor(.primary)//optional
//                        .lineLimit(3)//optional
//                        .expandButton(TextSet(text: "Xem thêm", font: .body, color: .blue))
//                        .collapseButton(TextSet(text: "Thu nhỏ", font: .body, color: .blue))
//                        .expandAnimation(.easeOut)
            ExpandableTextView(text: content, maxLines: 3)
                .padding(.trailing, 10)

            KFImage(URL(string: "https://ws.suckhoe123.vn\(viewModel.newFeed.image ?? "")"))
                .resizable()
                .frame(width: UIScreen.main.bounds.width, height: 300)
            
            HStack {
                HStack (spacing: 5) {
                    Image(isLiked || viewModel.newFeed.like == "1" ? "ic_liked" : "ic_heart_reaction")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .onTapGesture {
                            if AuthenViewModel.shared.currentUser != nil {
                                if (!viewModel.checkOwnerPost) {
                                    isLiked.toggle()
                                    homeViewModel.likePost(id: viewModel.newFeed.postid ?? "")
                                    homeViewModel.removeCache()
                                    
                                }
                            } else {
                                showViewWithoutLogin.toggle()
                            }
                        }
                        .fullScreenCover(isPresented: $showViewWithoutLogin, content: {
                            ViewWithouLogin(actionBack: true).environmentObject(AuthenViewModel()).environmentObject(homeViewModel)
                                .ignoresSafeArea(.all, edges: .top)
                        })
                    
                    Text("\(viewModel.getLike)")
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
        .padding(.leading, 10)
        .environmentObject(PostViewModel())
        .background(RoundedRectangle(cornerRadius: 0).fill(.white))
        .onAppear{
            UIScrollView.appearance().bounces = false
            DispatchQueue.main.async {
                content = (viewModel.newFeed.bodytext ?? "").htmlToString()
                nameUser = (viewModel.nameUser).htmlToString()
                title = (viewModel.title).htmlToString()
            }
            
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
