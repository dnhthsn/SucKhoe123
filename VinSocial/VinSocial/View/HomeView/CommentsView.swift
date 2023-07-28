//
//  CommentsView.swift
//  VinSocial
//
//  Created by Đinh Thái Sơn on 16/03/2023.
//

import SwiftUI
import Kingfisher
import _PhotosUI_SwiftUI

struct CommentsView: View {
    @EnvironmentObject var viewModel: AuthenViewModel
    @ObservedObject var feedCellViewModel: FeedCellViewModel
    @State var showLoginView: Bool = false
    @EnvironmentObject var homeViewModel: HomeViewModel
    @State private var commentText = ""
    @State var selected = "Mới nhất"
    @State var sortId = 1
    //private let user: UserResponse
    @State var selectedItem: PhotosPickerItem? = nil
    @State var selectedImageData: Data?
    var idPost:String
    
    @StateObject var commentViewModel: CommentViewModel
    
    init(feedCellViewModel: FeedCellViewModel,idPost:String) {
        self.idPost = idPost
        self.feedCellViewModel = feedCellViewModel
        _commentViewModel = StateObject(wrappedValue:CommentViewModel(id: idPost, test: "CommentView"))
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
                        commentViewModel.removeCacheComment()
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
                                commentViewModel.postComment(id: feedCellViewModel.postId, cid: "", pid: "", reptouserid: "", content: commentText, photo_comment: selectedImageData ?? Data())
                                commentText = ""
                                selectedImageData = Data()
                            }
                        
                    }
                    .padding([.vertical, .horizontal])
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(Color.white, lineWidth: 1)
                            
                    ).background(RoundedRectangle(cornerRadius: 6).fill(.white).shadow(radius: 5).frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    .ignoresSafeArea())
                    //.ignoresSafeArea()
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
//            LoginView(onLoginCallBackForHome: loadData)
//                .environmentObject(viewModel)
//                .environmentObject(homeViewModel)
            
            LoginTypeView(viewModel: viewModel, homeViewModel: homeViewModel, onLoginCallBackForHome: {
                loadData()
            })
        })
        .gesture(
            DragGesture()
                .onEnded { gesture in
                    if gesture.translation.width > 100 {
                        dismiss()
                    }
                }
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
                ForEach(commentViewModel.comments.indices, id: \.self) {comment in
                    if commentViewModel.comments[comment].comment_id == commentViewModel.comments.last?.comment_id && !commentViewModel.isPostComment{
                        listRowView(for: commentViewModel.comments[comment])
                            .task { await commentViewModel.loadNextPage(cid: "", pid: "", sortcomm: 1) }

                    } else {
                        listRowView(for: commentViewModel.comments[comment])
                    }
                    Divider()
                }
            }
        }
        
    }
    
    @ViewBuilder
    private func listRowView(for comment: CommentResponse) -> some View {
        CommentCell(viewModel: commentViewModel, commentCellViewModel: CommentCellViewModel(comment))

    }
}
