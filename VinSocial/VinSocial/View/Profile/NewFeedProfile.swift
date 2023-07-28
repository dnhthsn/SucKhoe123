//
//  NewFeedProfile.swift
//  VinSocial
//
//  Created by Stealer Of Souls on 3/27/23.
//

import SwiftUI

struct NewFeedProfile: View {
    @ObservedObject var viewModel: ProfileViewModel
//    var nextPageHandler: (() async -> ())? = nil
    @State var showToast: Bool = false
    @State var isCreatePost: Bool = false
    
    var body: some View {
        listView
        .tag(0)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .overlay(
            overlayView: ToastView(toast: Toast(title: "Đã sao chép" , image: ""), show: $showToast), show: $showToast
        )
        .onAppear {
            NotificationCenter.default.addObserver(forName: Notification.Name("CreatPostState"), object: nil, queue: nil) { notification in
                if let state = notification.object as? Bool {
                    self.isCreatePost = state
                }
            }
        }
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
                ForEach(viewModel.newFeeds) { newfeed in
                    if newfeed.postid == viewModel.newFeeds.last?.postid && self.isCreatePost == false {
                        listRowView(for: newfeed)
                            .task{
                               await viewModel.loadNextPage(pageuserid: viewModel.currentUserId)
                            }
                        
                    } else {
                        listRowView(for: newfeed)
                    }
                }
                .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                .listRowSeparator(.hidden)
            
    }
    

    @ViewBuilder
    private func listRowView(for newFeed: NewFeed) -> some View {
        NewFeedRowView(homeViewModel:HomeViewModel(),newFeed: newFeed,isOwner: true, showToast: $showToast)

    }
}

