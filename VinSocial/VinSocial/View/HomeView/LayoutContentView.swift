//
//  LayoutContentView.swift
//  Suckhoe123
//
//  Created by Đinh Thái Sơn on 14/07/2023.
//

import SwiftUI
import Kingfisher

struct LayoutContentView: View {
    var layoutContent: LayoutContent
    @State var checked: Bool = false
    var onChooseLayout:(_ id: String, _ image: String) -> Void
    
    var body: some View {
        KFImage(URL(string: "https://ws.suckhoe123.vn\(layoutContent.image ?? "")"))
            .resizable()
            .scaledToFill()
            .frame(width: 64, height: 64)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .onTapGesture {
                checked.toggle()
                onChooseLayout(layoutContent.id ?? "", layoutContent.image ?? "")
            }
        .frame(width: 64, height: 64)
        .cornerRadius(10)
    }
}
