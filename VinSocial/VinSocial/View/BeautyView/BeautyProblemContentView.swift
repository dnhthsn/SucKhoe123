//
//  BeautyProblemContentView.swift
//  VinSocial
//
//  Created by Đinh Thái Sơn on 24/03/2023.
//
import SwiftUI
import Kingfisher
import ObjectMapper

struct BeautyProblemContentView: View {
    var title: String
    @Environment(\.dismiss) var dismiss
    let subCatalog: SubCatalog
    @ObservedObject var viewModel :BeautyViewModel
    @State var currentTab: Int = 0
    @State var presentBottomSheet: Bool = false
    @State var showSheet: Bool = false
    @State var sorted: String = "recent"
    @State var showSuccess = false
    @State var showAskView = false
    
    func loadData(category: String, catid: String, act: String, sortby: String) {
        viewModel.loadData1(category: category, catid: catid, act: act, sortby: sortby)
    }
    
    func loadDataNews(category: String, catid: String, act: String) {
        viewModel.loadDataNews(category: category, catid: catid, act: act)
    }
    
    func loadDataQuestion(category: String, catid: String, act: String, sortby: String) {
        viewModel.loadDataQuestion(category: category, catid: catid, act: act, sortby: sortby)
    }
    
    func loadDataImage(category: String, catid: String, act: String, sortby: String) {
        viewModel.loadDataImage(category: category, catid: catid, act: act, sortby: sortby)
    }
    
    func loadDataVideo(category: String, catid: String, act: String, sortby: String) {
        viewModel.loadDataVideo(category: category, catid: catid, act: act, sortby: sortby)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    HStack {
                        Image("ic_back_arrow")
                            .resizable()
                            .frame(width: 26, height: 26)
                            .foregroundColor(Color.white)
                            .onTapGesture {
                                dismiss()
                                viewModel.removeCache1()
                                viewModel.removeCacheNews()
                                viewModel.removeCacheQuestion()
                                viewModel.removeCacheImage()
                                viewModel.removeCacheVideo()
                            }
                        
                        Text(subCatalog.title ?? "")
                            .foregroundColor(Color.white)
                            .font(.system(size: 20))
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(.bottom, 20)
                    .padding([.leading, .trailing], 20)
                    .background(Color(red: 23/255, green: 136/255, blue: 192/255))
                    .frame(maxWidth: .infinity, alignment: .top)
                    
                    TabBarCatalogView(currentTab: self.$currentTab)
                    
                    TabView(selection: self.$currentTab) {
                        ScrollView {
//                            LazyVStack {
//                                if let content = viewModel.detailCatalogs?.content?.htmlToString() ?? "" {
//                                    Text(content)
//                                        .multilineTextAlignment(.leading)
//                                        .foregroundColor(Color.black)
//                                        .padding([.leading, .trailing], 20)
//                                }
//
//
//                            }
                        }
                        .tag(0)
                        
                        VStack {
                            HStack {
                                Text("Danh sách bác sĩ hàng đầu")
                                    .foregroundColor(Color.black)
                                    .font(.system(size: 20, weight: .bold))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                if #available(iOS 16.0, *) {
                                    Image("ic_sort")
                                        .frame(width: 20, height: 20)
                                        .onTapGesture {
                                            presentBottomSheet.toggle()
                                        }
                                        .sheet(isPresented: $presentBottomSheet) {
                                            BottomSheetSortView(result: $sorted, type: "doctor").presentationDetents([.height(200), .large])
                                        }
                                } else {
                                    Image("ic_sort")
                                        .frame(width: 20, height: 20)
                                        .onTapGesture {
                                            showSheet.toggle()
                                        }
                                        .halfSheet(showSheet: $showSheet, sheetView: {
                                            BottomSheetSortView(result: $sorted, type: "doctor").presentationDetents([.height(200), .large])
                                        })
                                }
                                
                            }
                            .padding([.leading, .trailing], 15)
                            
                            ScrollView {
                                LazyVStack {
                                    ForEach(viewModel.catalogDoctors) { catalogDoctor in
                                        if catalogDoctor.userid == viewModel.catalogDoctors.last?.userid {
                                            
                                            CatalogDoctorView(viewModel: viewModel, friendViewModel: FriendViewModel(), subCatalog: subCatalog, catalogDoctor: catalogDoctor)
                                                .task {
                                                    if title == "thammy" {
                                                        await viewModel.loadNextPageCatalogDoctor(category: "lamd-dep", catid: subCatalog.catalogid ?? "", act: "doctor", sortby: sorted)
                                                    } else {
                                                        await viewModel.loadNextPageCatalogDoctor(category: "suc-khoe", catid: subCatalog.catalogid ?? "", act: "doctor", sortby: sorted)
                                                    }
                                                    
                                                    
                                                }
                                                .padding(5)
                                            
                                            if viewModel.isFetchingNextPage1 {
                                                bottomProgressView
                                            }
                                            
                                        } else {
                                            
                                            CatalogDoctorView(viewModel: viewModel, friendViewModel: FriendViewModel(),  subCatalog: subCatalog, catalogDoctor: catalogDoctor)
                                                .padding(5)
                                        }
                                    }
                                 
                                }
                            }
                            
                        }
                        .tag(1)
    //                    .onAppear{
    //                        if title == "thammy" {
    //                            loadData(category: "lam-dep", catid: subCatalog.catalogid ?? "", act: "doctor", sortby: sorted)
    //                        } else {
    //                            loadData(category: "suc-khoe", catid: subCatalog.catalogid ?? "", act: "doctor", sortby: sorted)
    //                        }
    //
    //                    }
                        
                        
                        Text("Bảng giá")
                            .tag(2)
                        
                        VStack {
                            Text("Tin tức về \(subCatalog.title ?? "")")
                                .foregroundColor(Color.black)
                                .font(.system(size: 20, weight: .bold))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding([.leading, .trailing], 15)
                            
                            ScrollView {
                                LazyVStack {
                                    ForEach(viewModel.catalogNews) { catalogNew in
                                        if catalogNew.id == viewModel.catalogNews.last?.id {
                                            
                                            CatalogNewsView(viewModel: viewModel, catalogNews: catalogNew, title: title)
                                                .task {
                                                    if title == "thammy" {
                                                        await viewModel.loadNextPageCatalogNews(category: "lamd-dep", catid: subCatalog.catalogid ?? "", act: "doctor")
                                                    } else {
                                                        await viewModel.loadNextPageCatalogNews(category: "suc-khoe", catid: subCatalog.catalogid ?? "", act: "doctor")
                                                    }
                                                    
                                                    
                                                }
                                                .padding(5)
                                            
                                            if viewModel.isFetchingNextPageNews {
                                                bottomProgressView
                                            }
                                            
                                        } else {
                                            
                                            CatalogNewsView(viewModel: viewModel, catalogNews: catalogNew, title: title)
                                                .padding(5)
                                        }
                                    }
                                 
                                }
                            }
                            
                        }
                        .tag(3)
    //                    .onAppear{
    //                        if title == "thammy" {
    //                            loadDataNews(category: "lam-dep", catid: subCatalog.catalogid ?? "", act: "news")
    //                        } else {
    //                            loadDataNews(category: "suc-khoe", catid: subCatalog.catalogid ?? "", act: "news")
    //                        }
    //
    //                    }
                        
                        VStack {
                            Text("Hình ảnh \(subCatalog.title ?? "")")
                                .foregroundColor(Color.black)
                                .font(.system(size: 20, weight: .bold))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding([.leading, .trailing], 15)
                            
                            CatalogImageView(viewModel: viewModel, subCatalog: subCatalog, title: title)
                        }
                        .tag(4)
    //                        .onAppear{
    //                            if title == "thammy" {
    //                                loadDataImage(category: "lam-dep", catid: subCatalog.catalogid ?? "", act: "image", sortby: "default")
    //                            } else {
    //                                loadDataImage(category: "suc-khoe", catid: subCatalog.catalogid ?? "", act: "image", sortby: "default")
    //                            }
    //
    //                        }
                        
                        VStack {
                            Text("Video \(subCatalog.title ?? "")")
                                .foregroundColor(Color.black)
                                .font(.system(size: 20, weight: .bold))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding([.leading, .trailing], 15)
                            
                            ScrollView {
                                LazyVStack {
                                    ForEach(viewModel.catalogVideo) { catalogVideo in
                                        if catalogVideo.id == viewModel.catalogVideo.last?.id {
                                            
                                            CatalogVideoView(catalogVideo: catalogVideo, catalogName: subCatalog.title ?? "")
                                                .task {
                                                    if title == "thammy" {
                                                        await viewModel.loadNextPageCatalogVideo(category: "lam-dep", catid: subCatalog.catalogid ?? "", act: "video", sortby: "new")
                                                    } else {
                                                        await viewModel.loadNextPageCatalogVideo(category: "suc-khoe", catid: subCatalog.catalogid ?? "", act: "video", sortby: "new")
                                                    }
                                                    
                                                    
                                                }
                                                .padding(5)
                                            
                                            if viewModel.isFetchingNextPageNews {
                                                bottomProgressView
                                            }
                                            
                                        } else {
                                            
                                            CatalogVideoView(catalogVideo: catalogVideo, catalogName: subCatalog.title ?? "")
                                                .padding(5)
                                        }
                                    }
                                 
                                }
                            }
                        }
                        .tag(5)
                        
                        
                        VStack {
                            Text("Hỏi đáp về \(subCatalog.title ?? "")")
                                .foregroundColor(Color.black)
                                .font(.system(size: 20, weight: .bold))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding([.leading, .trailing], 15)
                            
                            ScrollView {
                                LazyVStack {
                                    ForEach(viewModel.catalogQuestion) { catalogQuestion in
                                        if catalogQuestion.id == viewModel.catalogQuestion.last?.id {
                                            
                                            CatalogQuestionView(viewModel: viewModel, catalogQuestion: catalogQuestion, title: title)
                                                .task {
                                                    if title == "thammy" {
                                                        await viewModel.loadNextPageCatalogQuestion(category: "lamd-dep", catid: subCatalog.catalogid ?? "", act: "question", sortby: "recent")
                                                    } else {
                                                        await viewModel.loadNextPageCatalogQuestion(category: "suc-khoe", catid: subCatalog.catalogid ?? "", act: "question", sortby: "recent")
                                                    }
                                                    
                                                    
                                                }
                                                .padding(5)
                                            
                                            if viewModel.isFetchingNextPageQuestion {
                                                bottomProgressView
                                            }
                                            
                                        } else {
                                            
                                            CatalogQuestionView(viewModel: viewModel, catalogQuestion: catalogQuestion, title: title)
                                                .padding(5)
                                        }
                                    }
                                 
                                }
                                
                            }
                            
                            Spacer()
                            
                            Button(action: {
                                showAskView.toggle()
                            }, label: {
                                HStack {
                                    Image("ic_question")
                                        .resizable()
                                        .frame(width: 24, height: 24)
                                    
                                    Text("Hỏi chuyên gia")
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                }
                                .padding(.vertical,12)
                                .frame(maxWidth: .infinity)
                                .background {
                                    RoundedRectangle(cornerRadius: 6, style: .continuous)
                                        .fill(Color(red: 23/255, green: 136/255, blue: 192/255))
                                        .shadow(radius: 10)
                                }
                                .frame(width: UIScreen.main.bounds.width-20)
                            })
                            .fullScreenCover(isPresented: $showAskView, content: {
                                AskDoctorView(viewModel: viewModel, titleCatalog: title, showSuccess: $showSuccess)
                            })
                            
//                            NavigationLink(destination: {
//                                AskDoctorView(viewModel: viewModel, titleCatalog: title, showSuccess: $showSuccess)
//                            }, label: {
//                                HStack {
//                                    Image("ic_question")
//                                        .resizable()
//                                        .frame(width: 24, height: 24)
//
//                                    Text("Hỏi chuyên gia")
//                                        .fontWeight(.bold)
//                                        .foregroundColor(.white)
//                                }
//                                .padding(.vertical,12)
//                                .frame(maxWidth: .infinity)
//                                .background {
//                                    RoundedRectangle(cornerRadius: 6, style: .continuous)
//                                        .fill(Color(red: 23/255, green: 136/255, blue: 192/255))
//                                        .shadow(radius: 10)
//                                }
//                                .frame(width: UIScreen.main.bounds.width-20)
//                            })
                        }
                        .tag(6)
    //                    .onAppear{
    //                        if title == "thammy" {
    //                            loadDataQuestion(category: "lam-dep", catid: subCatalog.catalogid ?? "", act: "question", sortby: "recent")
    //                        } else {
    //                            loadData(category: "suc-khoe", catid: subCatalog.catalogid ?? "", act: "question", sortby: "recent")
    //                        }
    //
    //                    }
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))
                    .edgesIgnoringSafeArea(.all)
                    
                    Spacer()
                }
                .background(Color.white)
                .onAppear {
                    if title == "thammy" {
                        viewModel.detailCatalog(category: "lam-dep", catid: subCatalog.catalogid ?? "")
                        loadDataImage(category: "lam-dep", catid: subCatalog.catalogid ?? "", act: "image", sortby: "default")
                        loadData(category: "lam-dep", catid: subCatalog.catalogid ?? "", act: "doctor", sortby: sorted)
                        loadDataNews(category: "lam-dep", catid: subCatalog.catalogid ?? "", act: "news")
                        loadDataQuestion(category: "lam-dep", catid: subCatalog.catalogid ?? "", act: "question", sortby: "recent")
                        loadDataVideo(category: "lam-dep", catid: subCatalog.catalogid ?? "", act: "video", sortby: "new")
                    } else {
                        viewModel.detailCatalog(category: "suc-khoe", catid: subCatalog.catalogid ?? "")
                        loadDataImage(category: "suc-khoe", catid: subCatalog.catalogid ?? "", act: "image", sortby: "default")
                        loadData(category: "suc-khoe", catid: subCatalog.catalogid ?? "", act: "doctor", sortby: sorted)
                        loadDataNews(category: "suc-khoe", catid: subCatalog.catalogid ?? "", act: "news")
                        loadDataQuestion(category: "suc-khoe", catid: subCatalog.catalogid ?? "", act: "question", sortby: "recent")
                        loadDataVideo(category: "suc-khoe", catid: subCatalog.catalogid ?? "", act: "video", sortby: "new")
                    }
                }
                .onChange(of: sorted) { output in
                    if title == "thammy" {
                        loadData(category: "lam-dep", catid: subCatalog.catalogid ?? "", act: "doctor", sortby: output)
                    } else {
                        loadData(category: "suc-khoe", catid: subCatalog.catalogid ?? "", act: "doctor", sortby: output)
                    }
                    viewModel.removeCache1()
                }
                .blur(radius: showSuccess ? 5 : 0)
                .disabled(showSuccess)
                .gesture(
                    DragGesture()
                        .onEnded { gesture in
                            if gesture.translation.width > 100 {
                                dismiss()
                                viewModel.removeCache1()
                                viewModel.removeCacheNews()
                                viewModel.removeCacheQuestion()
                                viewModel.removeCacheImage()
                                viewModel.removeCacheVideo()
                            }
                        }
                )
                
                if showSuccess {
                    CustomNotifyDialog(image: "success", title: "Gửi câu hỏi thành công", description: "Chuyên gia của chúng tôi đã nhận được thông tin và sẽ trả lời trong thời gian sớm nhất", textButton: "OK", shown: $showSuccess).shadow(radius: 15)
                }
            }
            
        }
    }
    
    @ViewBuilder
    private var bottomProgressView: some View {
        HStack {
            Spacer()
            ProgressView()
            Spacer()
        }.padding()
    }
}

struct TabBarCatalogView: View {
    @Binding var currentTab: Int
    @Namespace var namespace
    var tabBarOptions: [String] = ["Thông tin", "Bác sĩ", "Bảng giá", "Tin tức", "Hình ảnh", "Video", "Hỏi đáp"]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .top, spacing: 10) {
                    ForEach(Array(zip(self.tabBarOptions.indices, self.tabBarOptions)),
                            id: \.0,
                            content: {
                        index, name in
                        TabBarCatalogItem(currentTab: self.$currentTab, namespace: namespace.self, tabBarItemName: name, tab: index)
                    })
                }
                .background(Color.white)
                .frame(height: 80)
                .padding(.leading, 5)
        }
        .padding([.leading, .trailing], 10)
    }
}

struct TabBarCatalogItem: View {
    @Binding var currentTab: Int
    let namespace: Namespace.ID
    var tabBarItemName: String
    var tab: Int
    
    var body: some View {
        Button {
            self.currentTab = tab
        } label: {
            VStack {
                Text(tabBarItemName)
            }
            .animation(.spring(), value: self.currentTab)
        }
        .foregroundColor(currentTab==tab ? Color.white : Color(red: 23/255, green: 136/255, blue: 192/255))
        .frame(width: 100, height: 40)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(currentTab==tab ? Color(red: 23/255, green: 136/255, blue: 192/255) : Color.white, lineWidth: 2)
                
                
        )
        .background(RoundedRectangle(cornerRadius: 10).fill(currentTab==tab ? Color(red: 23/255, green: 136/255, blue: 192/255) : Color.white).shadow(radius: 5))
        
    }
}
