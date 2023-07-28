//
//  ConcernItemCell.swift
//  Suckhoe123
//
//  Created by Đinh Thái Sơn on 14/06/2023.
//

import SwiftUI
import Kingfisher

struct ConcernItemCell: View {
    @ObservedObject var viewModel: BeautyViewModel
    var item: CatalogConcernItem
    var title: String
    @State var showContent: Bool = false
    @State var itemTitle: String = ""
    
    var body: some View {
        VStack {
            HStack {
                KFImage
                    .url((URL(string: "https://suckhoe123.vn\(item.image ?? "")")))
                    .resizable()
                    .frame(width: 125, height: 100)
                    .cornerRadius(10)
                
                VStack {
                    Text(itemTitle)
                        .frame(height: 60)
                        .truncationMode(.tail)
                        .multilineTextAlignment(.leading)
                        .foregroundColor(Color.black)
                        .font(.system(size: 16, weight: .bold))
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                    
                    Text(item.info_text ?? "")
                        .frame(height: 60)
                        .truncationMode(.tail)
                        .multilineTextAlignment(.leading)
                        .foregroundColor(Color.gray)
                        .font(.system(size: 13, weight: .bold))
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                }
            }
            
            Text(item.hometext ?? "")
                .frame(height: 50)
                .truncationMode(.tail)
                .multilineTextAlignment(.leading)
                .foregroundColor(Color.black)
                .font(.system(size: 16))
                .frame(maxWidth: .infinity, alignment: .topLeading)
        }
        .padding(10)
        .overlay(
            RoundedRectangle(cornerRadius: 6)
                .stroke(Color(red: 0.957, green: 0.957, blue: 0.957), lineWidth: 2)
                
        )
        .background(RoundedRectangle(cornerRadius: 6).fill(.white).shadow(radius: 2))
        .frame(width: UIScreen.main.bounds.width-20)
        .onAppear {
            DispatchQueue.main.async {
                itemTitle = (item.title ?? "").htmlToString()
            }
        }
        .onTapGesture {
            showContent.toggle()
        }
        .fullScreenCover(isPresented: $showContent, content: {
            if item.type == "catalog" {
                BeautyProblemContentView(title: title, subCatalog: viewModel.initSubCatalog1(item: item), viewModel: viewModel)
            } else {
                CatalogNewsDetailView(viewModel: viewModel, postid: item.id ?? "", title: title)
            }
            
        })
    }
}
