//
//  HomeView.swift
//  VinSocial
//
//  Created by Đinh Thái Sơn on 14/03/2023.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var postData: PostViewModel
    @EnvironmentObject var viewModel: HomeViewModel
    @EnvironmentObject var authenViewModel: AuthenViewModel
    @State var searchText: String = ""
    @FocusState private var isKeyboardShowing: Bool
   
    @State var showNotificationView: Bool = false
    @State var showLoginView: Bool = false
    @State var showWritePostView: Bool = false

    var body: some View {
//        NavigationView {
            VStack {
                VStack {
                    HStack {
                        HStack{
                            Image("ic_search")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30,height: 30)
                                .foregroundColor(Color.gray)
                                .padding(.horizontal,10)

                            TextField("", text: $searchText)
                                .placeholder(when: searchText.isEmpty) {
                                    Text(String(localized: "Label_Search"))
                                        .foregroundColor(Color(red: 158/255, green: 158/255, blue: 158/255))
                                }
                                .focused($isKeyboardShowing)
                                .padding([.top, .bottom], 10)
                                .onChange(of: searchText) { newValue in
                                    //send typing in here
                                    let newLength = newValue.count
                                    if newLength > 2 {
                                        viewModel.searchFeed(keyword: newValue, mod: "")
                                    }else{
                                        viewModel.clearSearch()
                                    }
                                    
                                }
                            
                            if !searchText.isEmpty {
                                Image("ic_clear")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                    .padding(.horizontal, 10)
                                    .onTapGesture {
                                        searchText = ""
                                    }
                            }
                           
                        }.overlay(
                            RoundedRectangle(cornerRadius: 30)
                                .stroke(Color(red: 158/255, green: 158/255, blue: 158/255), lineWidth: 1)
                                
                        ).background(RoundedRectangle(cornerRadius: 30).fill(.white))
                            .toolbar {
                                ToolbarItem(placement: .keyboard) {
                                    Button(LocalizedStringKey("Label_Cancel")){
                                        isKeyboardShowing.toggle()
                                    }
                                    .frame(maxWidth: .infinity,alignment: .trailing)
                                }
                            }
                        
                        if (authenViewModel.currentUser != nil){
                            Button {
                                showWritePostView.toggle()

                            } label: {
                                Image("Create_post")
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .padding()
                            }

                          
                            if viewModel.notifications.count > 0{
                                imageNotification.overlay(
                                    Text("\(viewModel.notifications.count)")
                                        .foregroundColor(Color.white)
                                        .clipShape(Circle())
                                        .padding(4)
                                        .background(Color.red)
                                        .clipShape(Circle())
                                        .offset(x: -3, y: -7)
    
                                    ,alignment: .bottomTrailing
                                )
                            }else{
                                imageNotification
                            }
                               
                        }else{
                            Button(action: {
                                //loadingToggle.toggle()
                                showLoginView = true
                                
                                
                            }, label: {
                                Text(LocalizedStringKey("Label_Login"))
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .frame(width: 130, height: 40)
                                    .background(Color(red: 23/255, green: 136/255, blue: 192/255))
                                    .cornerRadius(30)
                                    
                            })
                            .padding(.leading, 10)
                            .shadow(radius: 5)
                            .fullScreenCover(isPresented: $showLoginView, content: {
//                                LoginView(onLoginCallBackForHome:loadData).environmentObject(authenViewModel)
//                                    .environmentObject(viewModel)
                                LoginTypeView(viewModel: authenViewModel, homeViewModel: viewModel, onLoginCallBackForHome: {
                                    viewModel.loadData()
                                })
                            })
                        }
                    }
                    .padding([.leading, .trailing], 20)
                    
                    if (viewModel.newFeeds.isEmpty || viewModel.isLoadingSearchPage) {
                        ShimmerView()
                    }else{
                        if viewModel.newFeedSearchs.isEmpty {
                            NewFeedsView(viewModel:viewModel,isSearching: false, showType: TypeShowScreen.HOME)
                        }else{
                            NewFeedsView(viewModel:viewModel,isSearching:true, showType: TypeShowScreen.HOME)
                        }
                        
                       
                    }
                }
            }
            .environmentObject(viewModel)
            .fullScreenCover(isPresented: $showWritePostView, content: {
                WritePostView(user: authenViewModel.currentUser!,homeViewModel: viewModel, isEditPost: false, postid: "")
            })
            .onAppear{
                loadData()
            }
//            .animation(.spring())
    }
    
    @ViewBuilder
    private var imageNotification: some View {
        Image("ic_bell")
            .resizable()
            .frame(width: 30, height: 30)
            .onTapGesture {
                showNotificationView.toggle()
            }
            .fullScreenCover(isPresented: $showNotificationView, content: {
                NotificationView(notifications: viewModel.notifications, isFetchingNextPageNoti: viewModel.isFetchingNextPageNoti, nextPageNotiHandler: {await viewModel.loadNextPageNoti()})
            })
        
    }
    
    func loadData(){
        DispatchQueue.main.async {
            viewModel.loadData()
        }
    }

}






