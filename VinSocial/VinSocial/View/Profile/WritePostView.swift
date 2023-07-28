//
//  WritePostView.swift
//  VinSocial
//
//  Created by Đinh Thái Sơn on 16/03/2023.
//

import SwiftUI
import Kingfisher
import Combine

struct WritePostView: View {
    @EnvironmentObject var viewModel: AuthenViewModel
    @State private var commentText = ""
    private let user: UserResponse
    @State var selectedFaculty = "Công khai"
    @State var selectedBranch = "Ngành"
    @State var selectedImages: [ImagePost] = []
    @State var display: String = "1"
    @State var image: String = ""
    @State var idImage: String = ""

    @State var isShowingImagePicker = false
    @ObservedObject var homeViewModel: HomeViewModel
    var isEditPost: Bool
    var postid: String
    @State var selectedItem: Int = 0
    
    init(user: UserResponse,homeViewModel: HomeViewModel, isEditPost: Bool, postid: String) {
        self.user = user
        self.homeViewModel = homeViewModel
        self.isEditPost = isEditPost
        self.postid = postid
    }
    
  
    @Environment(\.presentationMode) var presentationMode


    @State var showImageViewer = false
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
                        homeViewModel.editContent(postid: postid, title: "", image: "", urlshare: "", content: commentText, layoutid: 0, display: 1, filephoto: createMediaUpload(), media: getMediaUploaded())
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
                        homeViewModel.createPost(title:commentText , image: "", urlshare: "", content: commentText, layoutid: self.idImage, display: display, data: createMediaUpload())
                        homeViewModel.removeCache()
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
                            
                            HStack {
                                Menu {
                                    Button(action: {
                                        selectedFaculty = "Công khai"
                                        display = "1"
                                    }, label: {
                                        Text("Công khai")
                                            .foregroundColor(Color.black)
                                            .font(.system(size: 15))
                                    })
                                    
                                    Button(action: {
                                        selectedFaculty = "Bạn bè"
                                        display = "2"
                                    }, label: {
                                        Text("Bạn bè")
                                            .foregroundColor(Color.black)
                                            .font(.system(size: 15))
                                    })
                                    
                                    Button(action: {
                                        selectedFaculty = "Riêng tư"
                                        display = "3"
                                    }, label: {
                                        Text("Riêng tư")
                                            .foregroundColor(Color.black)
                                            .font(.system(size: 15))
                                    })
                                } label: {
                                    Label(title: {
                                        Text("\(selectedFaculty)")
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
                                        
                                ).background(RoundedRectangle(cornerRadius: 6).fill(.white))
                                
                                
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
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
                        //.background(RoundedRectangle(cornerRadius: 0).fill(Color.white))
                        .background(KFImage(URL(string: "https://ws.suckhoe123.vn\(self.image)"))
                            .resizable()
                            )
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                        .frame(height: 150)
                    
                    Divider()
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHStack {
                            ForEach(homeViewModel.layoutContent.indices, id: \.self) { index in
                                ZStack {
                                    if self.selectedItem == index {
                                        Color(.cyan).frame(width: 70, height: 70)
                                            .cornerRadius(10)
                                    }
                                    
//                                    Text("\(index)")

//                                    LayoutContentView(layoutContent: homeViewModel.layoutContent[index], onChooseLayout: { id, image in
//                                        self.idImage = id
//                                        self.image = image
//                                    })
//                                    .padding()
                                    
                                    KFImage(URL(string: "https://ws.suckhoe123.vn\(homeViewModel.layoutContent[index].image ?? "")"))
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 64, height: 64)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                        .onTapGesture {
                                            self.idImage = homeViewModel.layoutContent[index].id ?? ""
                                            self.image = homeViewModel.layoutContent[index].image ?? ""
                                            self.selectedItem = index
                                        }
                                        .cornerRadius(10)
                                        .padding()
//                                        .onTapGesture {
//                                            self.selectedItem = index
//                                        }
                                }
                                
                                
//                                HStack {
//                                    Text("\(index)")
//
//                                    Spacer()
//
//                                    if self.selectedItem == index {
//                                        Image(systemName: "checkmark").foregroundColor(Color.blue)
//                                    }
//                                }
//                                .onTapGesture {
//                                    self.selectedItem = index
//                                }
                            }
                        }
                    }
                    
                    Divider()

                   let collumns = Array(repeating: GridItem(.flexible(), spacing: 5), count: 2)
                    
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
            homeViewModel.getLayoutContent()
            if isEditPost {
                homeViewModel.getContentEdit(getpost: "1", postid: postid) { newFeed in
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

