//
//  GroupCommentView.swift
//  Suckhoe123
//
//  Created by Đinh Thái Sơn on 10/06/2023.
//

import SwiftUI
import Kingfisher

struct GroupCommentView: View {
    @EnvironmentObject var viewModel: AuthenViewModel
    @ObservedObject var feedCellViewModel: FeedCellViewModel
    @ObservedObject var groupViewModel: GroupViewModel
    @State var showLoginView: Bool = false
    @State private var commentText = ""
    @State var selected = "Mới nhất"
    @State var sortId = 1
    //private let user: UserResponse
    init(feedCellViewModel: FeedCellViewModel, groupViewModel: GroupViewModel) {
        //self.user = user
        self.feedCellViewModel = feedCellViewModel
        self.groupViewModel = groupViewModel
    }

    @Environment(\.dismiss) var dismiss
    var body: some View {
        VStack {
            HStack {
                Image("ic_back_arrow")
                    .resizable()
                    .frame(width: 26, height: 26)
                    .foregroundColor(Color.white)
                    .onTapGesture {
                        dismiss()
                        groupViewModel.removeCacheComment()
                    }
                
                Text(LocalizedStringKey("Label_Comments"))
                    .foregroundColor(Color.white)
                    .font(.system(size: 20))
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.top, 20)
            .padding(.bottom, 20)
            .padding([.leading, .trailing], 20)
            .background(Color(red: 23/255, green: 136/255, blue: 192/255))
            .frame(maxWidth: .infinity, alignment: .top)
            
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
                            groupViewModel.postGroupComment(act: "comment", id: feedCellViewModel.postId, cid: "", pid: "", reptouserid: "", content: commentText, photo_comment: [MediaUploadFile(mediaType: "", data: Data())])
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
        .onChange(of: sortId) { output in
            groupViewModel.removeCacheComment()
            Task{
                await groupViewModel.loadFirstPageComment(act: "getComment", cid: "", id: feedCellViewModel.postId, pid: "", sortcomm: String(output))
            }
        }
        .gesture(
            DragGesture()
                .onEnded { gesture in
                    if gesture.translation.width > 100 {
                        dismiss()
                        groupViewModel.removeCacheComment()
                    }
                }
        )
        .onAppear {
            Task{
                await groupViewModel.loadFirstPageComment(act: "getComment", cid: "", id: feedCellViewModel.postId, pid: "", sortcomm: "1")
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
                        listRowView(comment: comment, viewModel: groupViewModel, postid: feedCellViewModel.newFeed.postid ?? "")
                            .task { await groupViewModel.loadNextPageComment(act: "getComment", cid: "", id: feedCellViewModel.postId, pid: "", sortcomm: "1") }
                        
                        if groupViewModel.isFetchingNextPageComment {
                            bottomProgressView
                        }
                        
                    } else {
                        listRowView(comment: comment, viewModel: groupViewModel, postid: feedCellViewModel.newFeed.postid ?? "")
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
