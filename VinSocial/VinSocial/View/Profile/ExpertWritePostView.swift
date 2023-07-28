//
//  ExpertWritePostView.swift
//  Suckhoe123
//
//  Created by Đinh Thái Sơn on 03/07/2023.
//

import SwiftUI
import Kingfisher
import Combine

struct ExpertWritePostView: View {
    @State private var commentText = ""
    @State private var username = ""
    @State private var avatar = ""
    @State var selectedFaculty = "Khoa"
    @State var selectedBranch = "Ngành"
    @State var selectedImages: [ImagePost] = []
    @State var expertDetail: ExpertDetail?
    @State var isShowingImagePicker = false
    @ObservedObject var viewModel: ProfileViewModel
    var category: String
    var isEditPost: Bool
    var postid: String
  
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            HStack {
                Image("ic_back_arrow")
                    .resizable()
                    .frame(width: 26, height: 26)
                    .foregroundColor(Color.black)
                    .onTapGesture {
                        presentationMode.wrappedValue.dismiss()
                    }
                
                Text(LocalizedStringKey("Label_Write_Post"))
                    .foregroundColor(Color.black)
                    .font(.system(size: 20))
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                if isEditPost {
                    Button(action: {
//                        homeViewModel.editContent(postid: postid, title: "", image: "", urlshare: "", content: commentText, layoutid: "0", display: "1", filephoto: [], media: [])
                        presentationMode.wrappedValue.dismiss()
                        
                    }, label: {
                        Text("Cập nhật")
                            .font(.headline)
                            .foregroundColor(commentText.isEmpty ? Color.gray : Color.white)
                            .frame(width: 120, height: 40)
                            .background(commentText.isEmpty ? Color(red: 244/255, green: 244/255, blue: 244/255) : Color(red: 23/255, green: 136/255, blue: 192/255))
                            .cornerRadius(30)
                            
                    })
                    .padding(.leading, 10)
                    .disabled(commentText.isEmpty)
                } else {
                    Button(action: {
                        //gọi hàm create post
//                        homeViewModel.createPost(title:commentText , image: "", urlshare: "", content: commentText, layoutid: "0", display: "1", data: createMediaUpload())
//                        homeViewModel.removeCache()
                        presentationMode.wrappedValue.dismiss()
                        
                    }, label: {
                        Text(LocalizedStringKey("Label_Post"))
                            .font(.headline)
                            .foregroundColor(commentText.isEmpty ? Color.gray : Color.white)
                            .frame(width: 120, height: 40)
                            .background(commentText.isEmpty ? Color(red: 244/255, green: 244/255, blue: 244/255) : Color(red: 23/255, green: 136/255, blue: 192/255))
                            .cornerRadius(30)
                            
                    })
                    .padding(.leading, 10)
                    .disabled(commentText.isEmpty)
                }
                
            }
            .padding(.bottom, 20)
            .padding([.leading, .trailing], 20)
            .background(Color.white)
            .frame(maxWidth: .infinity, alignment: .top)
            .background(RoundedRectangle(cornerRadius: 0).fill(.white).shadow(radius: 5))

            ScrollView {
                VStack {
                    HStack {
                        if isEditPost {
                            KFImage(URL(string: "https://ws.suckhoe123.vn\(avatar)"))
                                .resizable()
                                .scaledToFill()
                                .frame(width: 65, height: 65)
                                .clipShape(Circle())
                            
                            VStack {
                                Text(username)
                                    .font(.headline)
                                    .bold()
                                    .foregroundColor(Color.black)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                            }
                        } else {
                            KFImage(URL(string: "https://ws.suckhoe123.vn\(expertDetail?.avatar ?? "")"))
                                .resizable()
                                .scaledToFill()
                                .frame(width: 65, height: 65)
                                .clipShape(Circle())
                            
                            VStack {
                                Text(expertDetail?.fullname ?? "")
                                    .font(.headline)
                                    .bold()
                                    .foregroundColor(Color.black)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                            }
                        }
                        
                    }
                    .padding([.vertical, .horizontal])
                    
                    Divider()
                    
                    TextEditor(text: $commentText)
                        .scrollContentBackground(.hidden)
                        .placeholder(when: commentText.isEmpty) {
                            Text(LocalizedStringKey("Label_Write_Something_For_Your_Post"))
                                .foregroundColor(Color(red: 158/255, green: 158/255, blue: 158/255))
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                                .padding(7)
                        }
                        .onReceive(Just(commentText)) { _ in limitText(1000)
                            
                        }
                        .overlay(
                            Text("\(String(commentText.count))/1000 ký tự")
                                .font(.system(size: 13))
                                .foregroundColor(Color.gray)
                                .padding(6)
                                .padding(4)
                                .offset(x: -5, y: 6)
                            , alignment: .bottomTrailing
                        )
                        .padding(10)
                        .background(RoundedRectangle(cornerRadius: 0).fill(Color.white))
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                        .frame(height: 150)
                    
                    Divider()
                    

                   let collumns = Array(repeating: GridItem(.flexible(), spacing: 15), count: 2)
                    
                    LazyVGrid(columns: collumns, alignment: .leading, spacing: 10, content: {
                        ForEach(selectedImages.indices, id: \.self) { index in
                            GridImagePostView(index: index, medias: selectedImages)
                        }
                        
                    })
                    .padding(10)
                    .padding(.trailing, 20)
                
                    
                    Button {
                        isShowingImagePicker = true
                    } label: {
                        HStack {
                            Image("ic_add_photo")
                                .resizable()
                                .frame(width: 35, height: 35)
                            
                            Text(LocalizedStringKey("Label_Add_Image"))
                                .foregroundColor(Color.black)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .padding([.leading, .trailing])
                    }
                    HStack {
                        Image("ic_add_video")
                            .resizable()
                            .frame(width: 35, height: 35)
                        
                        Text(LocalizedStringKey("Label_Add_Video"))
                            .foregroundColor(Color.black)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding([.leading, .trailing])
                    
                    
                    
                }
            }
            
            
            
            

            
            Spacer()
        }
        .sheet(isPresented: $isShowingImagePicker) {
            MultiImagePicker(selectedImages: $selectedImages)
        }
        .onTapGesture {
            dismissKeyboard()
        }
        .gesture(
            DragGesture()
                .onEnded { gesture in
                    if gesture.translation.width > 100 {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
        )
        .onAppear {
            if isEditPost {
                DispatchQueue.main.async {
                    viewModel.getExpertDetailNewFeed(category: category, postid: postid, act: "blogdetail") { newFeed in
                        self.commentText = (newFeed?.bodytext ?? "").htmlToString()
                        self.username = (newFeed?.user_info?.fullname ?? "").htmlToString()
                        self.avatar = (newFeed?.user_info?.avatar ?? "").htmlToString()
                    }
                }
            }
        }
    }
    
    func limitText(_ upper: Int) {
        if commentText.count > upper {
            commentText = String(commentText.prefix(upper))
        }
    }
    
    func createMediaUpload()->[MediaUploadFile]{
        if selectedImages.count > 0 {
            var mediaUploadFiles:[MediaUploadFile] = []
            for uiImage in selectedImages {
                let imageData = uiImage.imagePost.jpegData(compressionQuality: 0.5)
                if(imageData != nil ){
                    let media = MediaUploadFile(mediaType: "image", data: imageData ?? Data())
                    mediaUploadFiles.append(media)
                }
            }
            return mediaUploadFiles
        }
        return []
    }
}
