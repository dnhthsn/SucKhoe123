//
//  LibraryView.swift
//  VinSocial
//
//  Created by Đinh Thái Sơn on 23/03/2023.
//

import SwiftUI
import Kingfisher

struct LibraryView: View {
    @ObservedObject var mediaUserViewModel: MediaUserViewModel
    @Environment(\.dismiss) var dismiss
    @State var currentTab: Int = 0
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        VStack {
            HStack {
                Image("ic_back_arrow")
                    .resizable()
                    .frame(width: 26, height: 26)
                    .foregroundColor(Color.black)
                    .onTapGesture {
                        mediaUserViewModel.removeCache()
                        dismiss()
                    }
                
                Text(LocalizedStringKey("Label_Your_Library"))
                    .foregroundColor(Color.black)
                    .font(.system(size: 20))
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.bottom, 20)
            .padding([.leading, .trailing], 20)
            .background(Color.white)
            .frame(maxWidth: .infinity, alignment: .top)
            
            TabBarMediaView(currentTab: self.$currentTab)
            
            TabView(selection: self.$currentTab) {
                
                VStack {
                    if (mediaUserViewModel.mediaUsers.isEmpty) {
                        Image("ic_empty").resizable().frame(width: 200, height: 125)
                   
                        Text(LocalizedStringKey("Label_No_Photo_Shared")).foregroundColor(.gray)
                    }else{
                        PhotosView(mediaUserViewModel: mediaUserViewModel)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                }
                .tag(0)
                .onAppear{
                    loadData(mediatype: 1, friendid: "", sort: 1, page: 1)
                }
                
                VStack {
                    Image("ic_empty").resizable().frame(width: 200, height: 125)

                    Text(LocalizedStringKey("Label_No_Video_Shared")).foregroundColor(.gray)
                }.tag(1)
                
               
                
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .edgesIgnoringSafeArea(.all)
        }
        .gesture(
            DragGesture()
                .onEnded { gesture in
                    if gesture.translation.width > 100 {
                        dismiss()
                        mediaUserViewModel.removeCache()
                    }
                }
        )
    }
    
    func loadData(mediatype: Int, friendid: String, sort: Int, page: Int) {
        mediaUserViewModel.loadData(mediatype: mediatype, friendid: friendid, sort: sort, page: page)
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
}

struct PhotosView: View {
    
    @ViewBuilder
    private var bottomProgressView: some View {
        Divider()
        HStack {
            Spacer()
            ProgressView()
            Spacer()
        }.padding()
    }
    
    @State private var detail: String? = nil
    @State private var slowAnimations = false
    @Namespace private var namespace
    @ObservedObject var mediaUserViewModel: MediaUserViewModel
    var body: some View {
        VStack {
//                    Toggle("Slow Animations", isOn: $slowAnimations)
                    ZStack {
                        photoGrid
//                            .opacity(detail == nil ? 1 : 0)
//                        detailView
                    }
//                    .animation(.default.speed(slowAnimations ? 0.2 : 1), value: detail)
                    .animation(.default.speed(0.2 ), value: detail)
                }
    }
    
    @ViewBuilder
        var detailView: some View {
            if let d = detail {
                KFImage(URL(string: d))
                    .resizable()
                    .matchedGeometryEffect(id: d, in: namespace, isSource: false)
                    .aspectRatio(contentMode: .fit)
                    .onTapGesture {
                        detail = nil
                    }
            }
        }
    var photoGrid: some View {
           ScrollView {
               LazyVGrid(columns: [.init(.adaptive(minimum: 100, maximum: .infinity), spacing: 3)], spacing: 3) {
                   ForEach(mediaUserViewModel.mediaUsers) { mediaUser in
                       if mediaUser.id == mediaUserViewModel.mediaUsers.last?.id {
                           
                           KFImage
                               .url((URL(string: "https://ws.suckhoe123.vn\(mediaUser.filename)")))
                               .resizable()
                               .matchedGeometryEffect(id: mediaUser.id, in: namespace)
                               .aspectRatio(contentMode: .fill)
                               .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                               .clipped()
                               .aspectRatio(1, contentMode: .fit)
                               .onTapGesture {
                                   detail = "https://ws.suckhoe123.vn\(mediaUser.filename)"
                               }
                               .task {
                                   await mediaUserViewModel.loadNextPage(mediatype: 1, friendid: "", sort: 1)
                                   
                               }
                           
                           if mediaUserViewModel.isFetchingNextPage {
                               bottomProgressView
                           }
                           
                       } else {
                           //
                           KFImage(URL(string: "https://ws.suckhoe123.vn\(mediaUser.filename)"))
                               .resizable()
                               .matchedGeometryEffect(id: mediaUser.id, in: namespace)
                               .aspectRatio(contentMode: .fill)
                               .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                               .clipped()
                               .aspectRatio(1, contentMode: .fit)
                               .onTapGesture {
                                   detail = "https://ws.suckhoe123.vn\(mediaUser.filename)"
                               }
                       }
                   }

               }
           }
       }
}

struct ExpertLibraryView: View {
    @ObservedObject var viewModel: ProfileViewModel
    @Environment(\.dismiss) var dismiss
    @State var currentTab: Int = 0
    @State var showBottomSheet: Bool = false
    @State var result: String = "new"
    
    var category: String
    var doctorid: String
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        VStack {
            HStack {
                Image("ic_back_arrow")
                    .resizable()
                    .frame(width: 26, height: 26)
                    .foregroundColor(Color.black)
                    .onTapGesture {
                        viewModel.removeCacheExpertImage()
                        viewModel.removeCacheExpertVideo()
                        dismiss()
                    }
                
                Text(LocalizedStringKey("Label_Your_Library"))
                    .foregroundColor(Color.black)
                    .font(.system(size: 20, weight: .bold))
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Button(action: {
                    showBottomSheet.toggle()
                }, label: {
                    Image("ic_filter")
                        .resizable()
                        .frame(width: 35, height: 35)
                })
                .sheet(isPresented: $showBottomSheet, content: {
                    BottomSheetSortView(result: $result, type: "media").presentationDetents([.height(200), .large])
                })
                
            }
            .padding(.bottom, 20)
            .padding([.leading, .trailing], 20)
            .background(Color.white)
            .frame(maxWidth: .infinity, alignment: .top)
            
            TabBarMediaView(currentTab: self.$currentTab)
            
            TabView(selection: self.$currentTab) {
                
                VStack {
                    if (viewModel.expertImage.isEmpty) {
                        Image("ic_empty").resizable().frame(width: 200, height: 125)
                   
                        Text(LocalizedStringKey("Label_No_Photo_Shared")).foregroundColor(.gray)
                    }else{
                        ExpertPhotosView(viewModel: viewModel, type: "image", category: category, doctorid: doctorid)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                }
                .tag(0)
                
                
                VStack {
                    if (viewModel.expertVideo.isEmpty) {
                        Image("ic_empty").resizable().frame(width: 200, height: 125)
                   
                        Text(LocalizedStringKey("Label_No_Photo_Shared")).foregroundColor(.gray)
                    }else{
                        ExpertPhotosView(viewModel: viewModel, type: "video", category: category, doctorid: doctorid)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                }
                .tag(1)
                
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .edgesIgnoringSafeArea(.all)
        }
        .onChange(of: result) { output in
            viewModel.removeCacheExpertImage()
            viewModel.removeCacheExpertVideo()
            viewModel.loadDataExpertImage(category: category, doctorid: doctorid, act: "image", sortby: output)
            viewModel.loadDataExpertVideo(category: category, doctorid: doctorid, act: "video", sortby: output)
        }
        .gesture(
            DragGesture()
                .onEnded { gesture in
                    if gesture.translation.width > 100 {
                        viewModel.removeCacheExpertImage()
                        viewModel.removeCacheExpertVideo()
                        dismiss()
                    }
                }
        )
        .onAppear {
            loadData()
        }
    }
    
    func loadData() {
        viewModel.loadDataExpertImage(category: category, doctorid: doctorid, act: "image", sortby: "new")
        viewModel.loadDataExpertVideo(category: category, doctorid: doctorid, act: "video", sortby: "new")
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
}

struct ExpertPhotosView: View {
    
    @ViewBuilder
    private var bottomProgressView: some View {
        Divider()
        HStack {
            Spacer()
            ProgressView()
            Spacer()
        }.padding()
    }
    
    @State private var detail: String? = nil
    @State var video: CatalogVideo? = nil
    @State private var slowAnimations = false
    @Namespace private var namespace
    @ObservedObject var viewModel: ProfileViewModel
    let type: String
    
    var category: String
    var doctorid: String
    
    @State var showFullVideo: Bool = false
    @State var showFullImage: Bool = false
    @State var position = 1
    
    var body: some View {
        VStack {
//                    Toggle("Slow Animations", isOn: $slowAnimations)
                    ZStack {
                        photoGrid
//                            .opacity(detail == nil ? 1 : 0)
//                        detailView
                    }
//                    .animation(.default.speed(slowAnimations ? 0.2 : 1), value: detail)
                    .animation(.default.speed(0.2 ), value: detail)
                }
    }
    
    @ViewBuilder
        var detailView: some View {
            if let d = detail {
                KFImage(URL(string: d))
                    .resizable()
                    .matchedGeometryEffect(id: d, in: namespace, isSource: false)
                    .aspectRatio(contentMode: .fit)
                    .onTapGesture {
                        detail = nil
                    }
            }
        }
    var photoGrid: some View {
        ScrollView {
            LazyVGrid(columns: [.init(.adaptive(minimum: 100, maximum: .infinity), spacing: 3)], spacing: 3) {
                if type == "image" {
                    ForEach(viewModel.expertImage.indices, id: \.self) { index in
                        if viewModel.expertImage[index].id == viewModel.expertImage.last?.id {
                            
                            KFImage
                                .url((URL(string: "https://ws.suckhoe123.vn\(viewModel.expertImage[index].image ?? "")")))
                                .resizable()
                                .matchedGeometryEffect(id: viewModel.expertImage[index].id, in: namespace)
                                .aspectRatio(contentMode: .fill)
                                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                                .clipped()
                                .aspectRatio(1, contentMode: .fit)
                                .onTapGesture {
                                    detail = "https://ws.suckhoe123.vn\(viewModel.expertImage[index].image ?? "")"
                                    showFullImage = true
                                    self.position = index+1
                                }
                                .task {
                                    await viewModel.loadNextPageExpertImage(category: category, doctorid: doctorid, act: "image", sortby: "new")
                                    
                                }
                                .fullScreenCover(isPresented: $showFullImage, content: {
                                    CatalogImageDetailView(catalogImage: viewModel.expertImage ?? [], position: self.position)
                                })
                            
                            if viewModel.isFetchingNextPageExpertImage {
                                bottomProgressView
                            }
                            
                        } else {
                            //
                            KFImage(URL(string: "https://ws.suckhoe123.vn\(viewModel.expertImage[index].image ?? "")"))
                                .resizable()
                                .matchedGeometryEffect(id: viewModel.expertImage[index].id, in: namespace)
                                .aspectRatio(contentMode: .fill)
                                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                                .clipped()
                                .aspectRatio(1, contentMode: .fit)
                                .onTapGesture {
                                    detail = "https://ws.suckhoe123.vn\(viewModel.expertImage[index].image ?? "")"
                                    showFullImage = true
                                    self.position = index+1
                                }
                                .fullScreenCover(isPresented: $showFullImage, content: {
                                    CatalogImageDetailView(catalogImage: viewModel.expertImage ?? [], position: self.position)
                                })
                        }
                    }
                } else {
                    ForEach(viewModel.expertVideo.indices, id: \.self) { index in
                        if viewModel.expertVideo[index].id == viewModel.expertVideo.last?.id {
                            ZStack {
                                KFImage
                                    .url((URL(string: "https://ws.suckhoe123.vn\(viewModel.expertVideo[index].image ?? "")")))
                                    .resizable()
                                    .matchedGeometryEffect(id: viewModel.expertVideo[index].id, in: namespace)
                                    .aspectRatio(contentMode: .fill)
                                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                                    .clipped()
                                    .aspectRatio(1, contentMode: .fit)
                                    .onTapGesture {
                                        detail = "https://ws.suckhoe123.vn\(viewModel.expertVideo[index].urlvideo ?? "")"
                                        print(detail)
                                    }
                                    .task {
                                        await viewModel.loadNextPageExpertVideo(category: category, doctorid: doctorid, act: "image", sortby: "new")
                                        
                                    }
                                
                                Image(systemName: "play.circle")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(Color.white)
                                    .onTapGesture {
                                        showFullVideo = true
                                        detail = "https://ws.suckhoe123.vn\(viewModel.expertVideo[index].urlvideo ?? "")"
                                        print(detail)
                                        self.video = viewModel.expertVideo[index]
                                    }
                                    .fullScreenCover(isPresented: $showFullVideo, content: {
//                                        ZStack(alignment: .topLeading) {
//                                            CustomVideoPlayerView(video: detail ?? "")
//
//                                            Button {
//                                                showFullVideo = false
//                                            } label: {
//                                                Image("ic_small_screen")
//                                                    .foregroundColor(.white)
//                                                    .padding()
//                                                    .clipShape(Circle())
//                                            }
//
//                                        }
                                        CatalogVideoDetailView(catalogVideo: video ?? CatalogVideo(postid: "", image: ""), catalogName: "")
                                    })
                            }
                            
                            if viewModel.isFetchingNextPageExpertImage {
                                bottomProgressView
                            }
                            
                        } else {
                            //
                            ZStack {
                                KFImage(URL(string: "https://ws.suckhoe123.vn\(viewModel.expertVideo[index].image ?? "")"))
                                    .resizable()
                                    .matchedGeometryEffect(id: viewModel.expertVideo[index].id, in: namespace)
                                    .aspectRatio(contentMode: .fill)
                                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                                    .clipped()
                                    .aspectRatio(1, contentMode: .fit)
                                    .onTapGesture {
                                        detail = "https://ws.suckhoe123.vn\(viewModel.expertVideo[index].urlvideo ?? "")"
                                        print(detail)
                                    }
                                
                                Image(systemName: "play.circle")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(Color.white)
                                    .onTapGesture {
                                        showFullVideo = true
                                        detail = "https://suckhoe123.vn\(viewModel.expertVideo[index].urlvideo ?? "")"
                                        print(detail!)
                                        self.video = viewModel.expertVideo[index]
                                    }
                                    .fullScreenCover(isPresented: $showFullVideo, content: {
//                                        ZStack(alignment: .topLeading) {
//                                            CustomVideoPlayerView(video: detail ?? "")
//                                            Button {
//                                                showFullVideo = false
//                                            } label: {
//                                                Image("ic_small_screen")
//                                                    .foregroundColor(.white)
//                                                    .padding()
//                                                    .clipShape(Circle())
//                                            }
//
//                                        }
                                        CatalogVideoDetailView(catalogVideo: video ?? CatalogVideo(postid: "", image: ""), catalogName: "")
                                    })
                            }
                            
                        }
                    }
                }
            }
        }
    }
}

struct TabBarMediaView: View {
    @Binding var currentTab: Int
    @Namespace var namespace
    var tabBarOptions: [String] = [String(localized: "Label_Photo"), String(localized: "Label_Video")]
    
    var body: some View {
        HStack(alignment: .top, spacing: 20) {
                ForEach(Array(zip(self.tabBarOptions.indices, self.tabBarOptions)),
                        id: \.0,
                        content: {
                    index, name in
                    TabBarMediaItem(currentTab: self.$currentTab, namespace: namespace.self, tabBarItemName: name, tab: index)
                })
            }
            .background(Color.white)
            .frame(height: 80)
            .edgesIgnoringSafeArea(.all)
    }
}

struct TabBarMediaItem: View {
    @Binding var currentTab: Int
    let namespace: Namespace.ID
    var tabBarItemName: String
    var tab: Int
    
    var body: some View {
        Button {
            self.currentTab = tab
        } label: {
            VStack {
                Spacer()
                Text(tabBarItemName)
                if (currentTab == tab) {
                    Color(red: 23/255, green: 136/255, blue: 192/255)
                        .frame(height: 2)
                        .matchedGeometryEffect(id: String(localized: "Label_Photo"),
                                               in: namespace,
                                               properties: .frame)
                } else {
                    Color
                        .clear
                        .frame(height: 2)
                }
            }
            .animation(.spring(), value: self.currentTab)
        }
        .foregroundColor(currentTab==tab ? Color(red: 23/255, green: 136/255, blue: 192/255) : Color.gray)
        .frame(maxWidth: .infinity, alignment: .center)
    }
}
