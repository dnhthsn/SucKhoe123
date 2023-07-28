//
//  AlphabetCatalogsView.swift
//  Suckhoe123
//
//  Created by Đinh Thái Sơn on 24/05/2023.
//

import SwiftUI

struct AlphabetCatalogsView: View {
    var title: String
    @ObservedObject var viewModel: BeautyViewModel
    var item: ListCatalogConcerns
    @State var showContent: Bool = false
    var body: some View {
        HStack {
            Text(item.title ?? "")
                .foregroundColor(Color.black)
                .frame(maxWidth: .infinity, alignment: .leading)
                .frame(height: 20)
                .multilineTextAlignment(.leading)
                .truncationMode(.tail)
                .padding()
        }
        .overlay(
            RoundedRectangle(cornerRadius: 6)
                .stroke(Color(red: 232/255, green: 232/255, blue: 232/255), lineWidth: 1)
                
        )
        .background(RoundedRectangle(cornerRadius: 6)
            .fill(Color(red: 237/255, green: 245/255, blue: 255/255)))
        .padding(.top, 5)
        .onTapGesture {
            showContent.toggle()
        }
        .fullScreenCover(isPresented: $showContent, content: {
            BeautyProblemContentView(title: title, subCatalog: viewModel.initSubCatalog(listCatalogs: item), viewModel: viewModel)
        })
    }
}
