//
//  CatalogSearchView.swift
//  Suckhoe123
//
//  Created by Đinh Thái Sơn on 14/06/2023.
//

import SwiftUI

struct CatalogSearchView: View {
    @ObservedObject var viewModel: BeautyViewModel
    var title: String
    var catalogSearch: [CatalogSearch]
    
    var body: some View {
        VStack {
            Text("Kết quả (\(viewModel.dataTotalSearch))")
                .foregroundColor(Color(red: 23/255, green: 136/255, blue: 192/255))
                .font(.system(size: 16))
                .frame(maxWidth: .infinity, alignment: .leading)
            
            ScrollView {
                LazyVStack {
                    ForEach(catalogSearch) { item in
                        CatalogSearchCell(title: title, viewModel: viewModel, catalogSearch: item)
                    }
                }
            }
        }
        .padding([.leading, .trailing], 20)
    }
}
