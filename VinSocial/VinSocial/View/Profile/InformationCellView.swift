//
//  InformationCellView.swift
//  Messenger
//
//  Created by Đinh Thái Sơn on 27/02/2023.
//

import SwiftUI

struct InformationCellView: View {
    let imageName: String
    let placeholderText:String
    let title: String

    @Binding var text: String
    
    @State var checkEdit: Bool = false
    
    var body: some View {
        VStack{
            
            HStack{
                
                VStack {
                    Text(title)
                        .font(.system(size: 10))
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding([.leading, .trailing, .top], 5)
                        .padding(.leading, 10)
                    
                    if checkEdit {
                        TextField("", text: $text)
                            .placeholder(when: text.isEmpty) {
                                Text(placeholderText)
                                    .foregroundColor(Color(red: 158/255, green: 158/255, blue: 158/255))
                            }
                            .foregroundColor(Color(red: 158/255, green: 158/255, blue: 158/255))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding([.leading, .trailing, .bottom], 5)
                            .padding(.leading, 10)
                    } else {
                        Text(text)
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding([.leading, .trailing, .bottom], 5)
                            .padding(.leading, 10)
                    }
                }
                
                
                
                Image("ic_edit")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 16,height: 20)
                    .foregroundColor(Color.gray)
                    .padding(.horizontal,10)
                    .onTapGesture {
                        checkEdit.toggle()
                    }
                
                
               
            }
            .padding(5)
            .overlay(
                RoundedRectangle(cornerRadius: 6)
                    .stroke(Color(red: 158/255, green: 158/255, blue: 158/255), lineWidth: 1)
                    
            ).background(RoundedRectangle(cornerRadius: 6).fill(.white))
        }
    }
}

//struct InformationCellView_Previews: PreviewProvider {
//    static var previews: some View {
//        InformationCellView()
//    }
//}
