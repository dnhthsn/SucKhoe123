//
//  CatalogSearchCell.swift
//  Suckhoe123
//
//  Created by Đinh Thái Sơn on 14/06/2023.
//

import SwiftUI
import Kingfisher

struct CatalogSearchCell: View {
    var title: String
    @ObservedObject var viewModel: BeautyViewModel
    var catalogSearch: CatalogSearch
    @State var showContent: Bool = false
    
    var body: some View {
        VStack {
            HStack {
                KFImage
                    .url((URL(string: "https://suckhoe123.vn\(catalogSearch.image ?? "")")))
                    .resizable()
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
                    .cornerRadius(10)
                
                VStack {
                    Text(catalogSearch.title ?? "")
                        .foregroundColor(Color.black)
                        .font(.system(size: 20, weight: .bold))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text(catalogSearch.hometext ?? "")
                        .foregroundColor(Color.gray)
                        .multilineTextAlignment(.leading)
                        .truncationMode(.tail)
                        .frame(height: 50)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            
            Divider()
        }
        .onTapGesture {
            showContent.toggle()
        }
        .fullScreenCover(isPresented: $showContent, content: {
            if catalogSearch.op == "catalog" {
                BeautyProblemContentView(title: title, subCatalog: viewModel.initSubCatalog2(item: catalogSearch), viewModel: viewModel)
            } else if catalogSearch.op == "doctor" {
                ProfileView(user: nil, isShowBackPress: true,profileViewModel: ProfileViewModel(currentUserId: catalogSearch.id ?? "", userDetailInfo: viewModel.initUserInfo2(item: catalogSearch),"CatalogSearchCell"), friendViewModel: FriendViewModel())
            } else if catalogSearch.op == "guide" {
                
            } else if catalogSearch.op == "banggia" {
                
            } else if catalogSearch.op == "news" {
                CatalogNewsDetailView(viewModel: viewModel, postid: catalogSearch.id ?? "", title: title)
            } else if catalogSearch.op == "question" {
                CatalogQuestionDetailView(viewModel: viewModel, postid: catalogSearch.id ?? "", title: title)
            } else if catalogSearch.op == "video" {
                CatalogVideoDetailView(catalogVideo: viewModel.initCatalogVideo(item: catalogSearch), catalogName: "")
            } else if catalogSearch.op == "photo" {
                
            }
        })
    }
}
