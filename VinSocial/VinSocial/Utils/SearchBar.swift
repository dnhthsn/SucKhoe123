//
//  SearchBar.swift
//  Messenger
//
//  Created by Stealer Of Souls on 2/8/23.
//

import SwiftUI

struct SearchBar: View {
    @Binding var text: String
    @Binding var isEditing:Bool
    var body: some View {
        HStack{
            TextField("Search....",text: $text)
                .padding(8)
                .padding(.horizontal)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .overlay(
                    Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                    .padding(.leading,8))
            if isEditing{
                Button (action: {
                    isEditing = false;
                    text = ""
                }, label: {
                    Text("Cancel").foregroundColor(.black)
                
                })
                .padding(.trailing,8)
                .transition(.move(edge: .trailing))

            }
        }
    }

}
struct SearchBar_Previews:PreviewProvider{
    static var previews: some View{
        SearchBar(text: .constant("Search"), isEditing: .constant(false))
    }
}
