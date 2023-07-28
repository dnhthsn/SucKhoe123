//
//  ResponseView.swift
//  Suckhoe123
//
//  Created by Đinh Thái Sơn on 12/06/2023.
//

import SwiftUI
import Kingfisher
import _PhotosUI_SwiftUI

struct ReplyView: View {
    @ObservedObject var viewModel: CommentViewModel
    @ObservedObject var commentCellViewModel: CommentCellViewModel
    @State var selectedItem: PhotosPickerItem? = nil
    @State var selectedImageData: Data?
    @State var selectedImages: [UIImage] = []

    @Environment(\.dismiss) var dismiss
    @State private var commentText = ""
    var body: some View {
        VStack {
            HStack {
                Image("ic_back_arrow")
                    .resizable()
                    .frame(width: 26, height: 26)
                    .foregroundColor(Color.white)
                    .onTapGesture {
                        dismiss()
                        viewModel.removeCacheReply()
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
            
            ScrollView {
                LazyVStack {
                    
                    
                    VStack {
                        HStack(alignment: .center, spacing: 5) {
                            VStack {
                                KFImage(URL(string: "https://ws.suckhoe123.vn\(commentCellViewModel.comment.userid_create_comment?.avatar ?? "")"))
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 45, height: 45)
                                    .clipShape(Circle())
                            }
                            .frame(maxHeight: .infinity, alignment: .top)
                            
                            VStack {
                                Text(commentCellViewModel.comment.userid_create_comment?.fullname ?? "")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .foregroundColor(Color.black)
                                    .font(.system(size: 18))
                                
                                if commentCellViewModel.convertTime(time: commentCellViewModel.addTime) == commentCellViewModel.getCurrentTime() {
                                    Text("• Vừa xong")
                                        .foregroundColor(Color.gray)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                } else {
                                    Text("• \(commentCellViewModel.compareTime(timeArr1: commentCellViewModel.convertTime(time: commentCellViewModel.addTime), timeArr2: commentCellViewModel.getCurrentTime()))")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                                
                                Text(commentCellViewModel.content)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .foregroundColor(Color.black)
                                    .font(.system(size: 18))
                                
                                if commentCellViewModel.comment.media != nil {
                                    KFImage(URL(string: "https://ws.suckhoe123.vn\(commentCellViewModel.comment.media?.media_url ?? "")"))
                                        .resizable()
                                        .scaledToFit()
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 150)
                                } else {
                                    Text("")
                                }
                                
                                HStack {
                                    HStack {
                                        Image("ic_heart_reaction")
                                            .resizable()
                                            .frame(width: 30, height: 30)
                                        
                                        Text("\(commentCellViewModel.getLike)")
                                            .foregroundColor(Color.gray)
                                    }
                                    
                                    Text("Trả lời")
                                        .foregroundColor(Color.blue)
                                        .padding(.leading, 20)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                 
                                
                                LazyVStack {
                                    ForEach(viewModel.replyComments) {reply in
                                        if reply.comment_id == viewModel.replyComments.last?.comment_id {
                                            ReplyCell(viewModel: commentCellViewModel, reply: reply)
                                                .task { await viewModel.loadNextPageReply(cid: "", pid: commentCellViewModel.comment.comment_id ?? "", sortcomm: 1) }
                                            
                                        } else {
                                            ReplyCell(viewModel: commentCellViewModel, reply: reply)
                                        }
                                    }
                                    .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                                    .listRowSeparator(.hidden)
                                }
                            }
                                
                        }
                    }
                    .padding([.leading, .trailing], 20)

                }
                .onAppear {
                    Task{
                        await viewModel.loadFirstPageReply(cid: "", pid: commentCellViewModel.comment.comment_id ?? "", sortcomm: 1)
                    }
                }
                .onTapGesture {
                    dismissKeyboard()
                }
            }
            
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
                            Text("Viết câu trả lời")
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
                                    selectedImages.append(UIImage(data: selectedImageData!)!)
                                }
                            }
                        }
                    
                    Image("ic_send")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .onTapGesture {
    //                        commentViewModel.postComment(id: feedCellViewModel.postId, cid: "", pid: "", reptouserid: "", content: commentText, photo_comment: [MediaUploadFile(mediaType: "", data: Data())])
                            viewModel.responseComment(id: viewModel.id, cid: "", pid: commentCellViewModel.comment.comment_id ?? "", reptouserid: "", content: commentText, photo_comment: selectedImageData ?? Data())
                            commentText = ""
                            selectedImageData = nil
                        }
                    
                }
                
            }
            .padding([.leading, .trailing], 20)
            
        }
        .gesture(
            DragGesture()
                .onEnded { gesture in
                    if gesture.translation.width > 100 {
                        dismiss()
                        viewModel.removeCacheReply()
                    }
                }
        )
    }
}

