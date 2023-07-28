//
//  CatalogImageView.swift
//  Suckhoe123
//
//  Created by Đinh Thái Sơn on 01/06/2023.
//

import SwiftUI
import Kingfisher

struct CatalogImageView: View {
    @ViewBuilder
    private var bottomProgressView: some View {
        HStack {
            Spacer()
            ProgressView()
            Spacer()
        }.padding()
    }
    
    @State private var detail: String? = nil
    @State private var slowAnimations = false
    @Namespace private var namespace
    @ObservedObject var viewModel: BeautyViewModel
    let subCatalog: SubCatalog
    let title: String
    @State var showDetail: Bool = false
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
        .padding([.leading, .trailing], 15)
        .fullScreenCover(isPresented: $showDetail, content: {
            CatalogImageDetailView(catalogImage: viewModel.catalogImage, position: self.position)
        })
        .animation(.spring())
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
                   ForEach(viewModel.catalogImage.indices, id: \.self) { index in
                       if viewModel.catalogImage[index].id == viewModel.catalogImage.last?.id {
                           
                           KFImage
                               .url((URL(string: "https://suckhoe123.vn\(viewModel.catalogImage[index].image ?? "")")))
                               .resizable()
                               .matchedGeometryEffect(id: viewModel.catalogImage[index].id, in: namespace)
                               .aspectRatio(contentMode: .fill)
                               .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                               .clipped()
                               .aspectRatio(1, contentMode: .fit)
                               .onTapGesture {
                                   detail = "https://suckhoe123.vn\(viewModel.catalogImage[index].image ?? "")"
                                   self.showDetail.toggle()
                                   self.position = index+1
                                   print("test \(self.position)")
                               }
                               .task {
                                   if title == "thammy" {
                                       await viewModel.loadNextPageCatalogImage(category: "lam-dep", catid: subCatalog.catalogid ?? "", act: "image", sortby: "default")
                                   } else {
                                       await viewModel.loadNextPageCatalogImage(category: "suc-khoe", catid: subCatalog.catalogid ?? "", act: "image", sortby: "default")
                                   }
                               }
                           
                           if viewModel.isFetchingNextPageImage {
                               bottomProgressView
                           }
                           
                       } else {
                           //
                           KFImage(URL(string: "https://suckhoe123.vn\(viewModel.catalogImage[index].image ?? "")"))
                               .resizable()
                               .matchedGeometryEffect(id: viewModel.catalogImage[index].id, in: namespace)
                               .aspectRatio(contentMode: .fill)
                               .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                               .clipped()
                               .aspectRatio(1, contentMode: .fit)
                               .onTapGesture {
                                   detail = "https://suckhoe123.vn\(viewModel.catalogImage[index].image ?? "")"
                                   self.showDetail.toggle()
                                   self.position = index+1
                                   print("test \(self.position)")
                               }
                       }
                   }

               }
           }
       }
}
