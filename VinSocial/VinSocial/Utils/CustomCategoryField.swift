//
//  CustomCategoryField.swift
//  VinSocial
//
//  Created by Đinh Thái Sơn on 14/03/2023.
//

import SwiftUI

struct CustomCategoryField:View{
    let imageName: String
    let categoryName: String
    
    var body: some View{
        VStack{
            HStack{
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 25,height: 25)
                    .foregroundColor(Color.gray)
                    .padding([.top, .bottom], 5)
                    .padding(.leading, 10)
                
                Text(categoryName)
                    .font(.system(size: 15))
                    .foregroundColor(Color(red: 23/255, green: 136/255, blue: 192/255))
                    .padding([.top, .bottom], 5)
                    .padding(.trailing, 10)
               
            }
            .frame(width: 140, height: 45)
            .overlay(
                RoundedRectangle(cornerRadius: 30)
                    .stroke(Color(red: 244/255, green: 244/255, blue: 244/255), lineWidth: 1)
                    
            ).background(RoundedRectangle(cornerRadius: 30).fill(Color(red: 244/255, green: 244/255, blue: 244/255)))
                
        }
    }
}

