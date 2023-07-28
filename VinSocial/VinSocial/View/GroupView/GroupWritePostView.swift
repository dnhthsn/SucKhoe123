//
//  GroupWritePostView.swift
//  Suckhoe123
//
//  Created by Đinh Thái Sơn on 09/06/2023.
//

import SwiftUI

import Kingfisher
import Combine

struct GroupWritePostView: View {
    @EnvironmentObject var viewModel: AuthenViewModel
    @State private var commentText = ""
    private let user: UserResponse
    @State var selectedFaculty = "Khoa"
    @State var selectedBranch = "Ngành"
    @State var selectedImages: [ImagePost] = []

    @State var isShowingImagePicker = false
    @State var showImageViewer = false
    
    @ObservedObject var groupViewModel: GroupViewModel
    var groupid: String
    var isEditPost: Bool
    var postid: String
    
    init(user: UserResponse,groupViewModel: GroupViewModel, groupid: String, postid: String, isEditPost: Bool) {
        self.user = user
        self.groupViewModel = groupViewModel
        self.groupid = groupid
        self.postid = postid
        self.isEditPost = isEditPost
    }
    
  
    @Environment(\.presentationMode) var presentationMode


    
    @Environment(\.dismiss) var dismiss
    var body: some View {
        VStack {
            HStack {
                Image("ic_back_arrow")
                    .resizable()
                    .frame(width: 26, height: 26)
                    .foregroundColor(Color.black)
                    .onTapGesture {
                        dismiss()
                    }
                
                Text(LocalizedStringKey("Label_Write_Post"))
                    .foregroundColor(Color.black)
                    .font(.system(size: 20))
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                if isEditPost {
                    Button(action: {
                        groupViewModel.groupEditContent(act: "updatePost", postid: postid, title: "", image: "", urlshare: "", content: commentText, layoutid: "0", filephoto: createMediaUpload(), media: getMediaUploaded(), groupid: groupid)
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
                        groupViewModel.createPost(act: "post", title: commentText, image: "", urlshare: "", content: commentText, layoutid: "0", groupid: groupid, data: createMediaUpload())
                        
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
                        KFImage(URL(string: user.photo!))
                            .resizable()
                            .scaledToFill()
                            .frame(width: 65, height: 65)
                            .clipShape(Circle())
                        
                        VStack {
                            Text(user.fullname!)
                                .font(.headline)
                                .bold()
                                .foregroundColor(Color.black)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
//                            HStack {
//                                Menu {
//                                    Button(action: {
//                                        selectedFaculty = "Thẩm mỹ"
//                                    }, label: {
//                                        Text("Thẩm mỹ")
//                                            .foregroundColor(Color.black)
//                                            .font(.system(size: 15))
//                                    })
//                                } label: {
//                                    Label(title: {
//                                        Text("\(selectedFaculty)")
//                                            .foregroundColor(Color.black)
//                                            .font(.system(size: 15))
//                                        Image("ic_drop_down")
//                                    }, icon: {})
//                                }
//                                .padding([.top, .bottom], 5)
//                                .padding([.leading, .trailing], 10)
//                                .overlay(
//                                    RoundedRectangle(cornerRadius: 6)
//                                        .stroke(Color(red: 158/255, green: 158/255, blue: 158/255), lineWidth: 1)
//
//                                ).background(RoundedRectangle(cornerRadius: 6).fill(.white))
//
//                                Menu {
//                                    Button(action: {
//                                        selectedBranch = "Nâng mũi"
//                                    }, label: {
//                                        Text("Nâng mũi")
//                                            .foregroundColor(Color.black)
//                                            .font(.system(size: 15))
//                                    })
//                                } label: {
//                                    Label(title: {
//                                        Text("\(selectedBranch)")
//                                            .foregroundColor(Color.black)
//                                            .font(.system(size: 15))
//                                        Image("ic_drop_down")
//                                    }, icon: {})
//                                }
//                                .padding([.top, .bottom], 5)
//                                .padding([.leading, .trailing], 10)
//                                .overlay(
//                                    RoundedRectangle(cornerRadius: 6)
//                                        .stroke(Color(red: 158/255, green: 158/255, blue: 158/255), lineWidth: 1)
//
//                                ).background(RoundedRectangle(cornerRadius: 6).fill(.white))
//                                .frame(maxWidth: .infinity, alignment: .leading)
//                            }
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
                    
                    LazyVGrid(columns: collumns, alignment: .leading, spacing: 5, content: {
                        ForEach(selectedImages.indices, id: \.self) { index in
                            GridImagePostView(index: index, medias: selectedImages)
                                .onTapGesture {
                                    if isEditPost{
                                        showImageViewer.toggle()
                                    }
                                  
                                 
                                }
                                .fullScreenCover(isPresented: $showImageViewer, content: {
                                    //CatalogImageDetailView(catalogImage: <#T##[CatalogImage]#>, position: self.position)
                                    DetailEditImage(medias: $selectedImages)
                                })
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
                        dismiss()
                    }
                }
        )
        .onAppear {
            if isEditPost {
                groupViewModel.getGroupContentEdit(act: "getPost", postid: postid, groupid: groupid) { newFeed in
                    self.commentText = newFeed.content ?? ""
                    
                    DispatchQueue.global(qos: .background).async {
                        do {
                            if let medias = newFeed.media {
                                for item in medias {
                                    let url = URL(string: "https://suckhoe123.vn\(item.media_url ?? "")")
                                    if let data = try? Data(contentsOf: url!) {
                                        DispatchQueue.main.async {
                                            let imagePost = ImagePost(imagePost:UIImage(data: data)! , isCreateImage: false,idImage: item.id ?? "0")
                                            self.selectedImages.append(imagePost)
                                        }
                                    }
                                }
                            }
                        }
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
            for imagePost in selectedImages {
                //chỉ những file up mới thì mới add vào
                if imagePost.isCreateImage {
                    let imageData = imagePost.imagePost.jpegData(compressionQuality: 0.5)
                    if(imageData != nil ){
                        let media = MediaUploadFile(mediaType: "image", data: imageData ?? Data())
                        mediaUploadFiles.append(media)
                    }
                }
              
            }
            return mediaUploadFiles
        }
        return []
    }
    
    func getMediaUploaded()->[String]{
        if selectedImages.count > 0 {
            var mediaUploadFiles:[String] = []
            for imagePost in selectedImages {
                //chỉ những file up mới thì mới add vào
                if !imagePost.isCreateImage {
                    mediaUploadFiles.append(imagePost.idImage ?? "0")
                }
            }
            return mediaUploadFiles
        }
        return []
    }
}
