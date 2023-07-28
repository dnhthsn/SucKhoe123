//
//  VideoView.swift
//  VinSocial
//
//  Created by Stealer Of Souls on 4/3/23.
//

import SwiftUI

struct VideoView: View {
    @EnvironmentObject var viewModel: HomeViewModel
    @State var searchText: String = ""
    
    @FocusState private var isKeyboardShowing: Bool

    var body: some View {
//        NavigationView {
            VStack {
                VStack {
                    HStack {
                        Text(LocalizedStringKey("Label_Video"))
                            .font(.system(size: 30, weight: .bold))
                            .foregroundColor(Color.black)
                            .padding(.trailing)
                        
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
                                        viewModel.searchFeed(keyword: newValue, mod: "video")
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
                    }
                    .padding([.leading, .trailing], 20)
                    if (viewModel.newFeeds.isEmpty || viewModel.isLoadingSearchPage) {
                        ShimmerView()
                    }else{
                        if viewModel.newFeedSearchs.isEmpty {
                            NewFeedsView(viewModel:viewModel,isSearching: false, showType: TypeShowScreen.VIDEO)
                        }else{
                            NewFeedsView(viewModel:viewModel,isSearching:true, showType: TypeShowScreen.VIDEO)
                        }
                    }
                }
            }
            .padding(.top, 60)
//        }
       
        
    }

}

//struct HomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeView()
//    }
//}






