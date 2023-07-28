//
//  ConcernItemView.swift
//  Suckhoe123
//
//  Created by Đinh Thái Sơn on 14/06/2023.
//

import SwiftUI

struct ConcernItemView: View {
    var title: String
    let subCatalog: SubCatalog
    @ObservedObject var viewModel :BeautyViewModel
    @State var catalogConcernItem: [CatalogConcernItem] = []
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    dismiss()
                } label: {
                    Image("ic_back_arrow")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 26, height: 26)
                        .foregroundColor(Color.black)
                }
                
                Text(subCatalog.title ?? "")
                    .foregroundColor(Color.black)
                    .font(.system(size: 20, weight: .bold))
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                
            }
            .padding([.leading, .trailing], 15)
            
            ScrollView {
                LazyVStack {
                    ForEach(catalogConcernItem) { item in
                        ConcernItemCell(viewModel: viewModel, item: item, title: title)
                    }
                }
            }
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
            if title == "thammy" {
                viewModel.loadCatalogConcernDetail(act: "tham-my", catalogid: subCatalog.catalogid ?? "") { item in
                    self.catalogConcernItem = item
                }
            } else {
                viewModel.loadCatalogConcernDetail(act: "suc-khoe", catalogid: subCatalog.catalogid ?? "") { item in
                    self.catalogConcernItem = item
                }
            }
            
        }
    }
}
