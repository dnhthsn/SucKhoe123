//
//  DetailCatalogFeature.swift
//  Suckhoe123
//
//  Created by Đinh Thái Sơn on 25/05/2023.
//

import SwiftUI

struct DetailCatalogFeatureView: View {
    var body: some View {
        HStack {
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        }
        .frame(width: 100, height: 40)
        .overlay(
            RoundedRectangle(cornerRadius: 6)
                .stroke(Color(red: 0.957, green: 0.957, blue: 0.957), lineWidth: 2)
                .shadow(radius: 10)
                
        )
        .background(RoundedRectangle(cornerRadius: 6).fill(.white))
    }
}
