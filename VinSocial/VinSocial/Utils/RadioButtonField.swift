//
//  RadioButtonField.swift
//  Suckhoe123
//
//  Created by Đinh Thái Sơn on 09/05/2023.
//

import SwiftUI

struct RadioButtonField: View {
    let id: String
    let label: String
    let image: String
    let description: String
    let size: CGFloat
    let color: Color
    let bgColor: Color
    let textSize: CGFloat
    let isMarked:Bool
    let callback: (String)->()
        
    init(
        id: String,
        label:String,
        image: String,
        description: String,
        size: CGFloat = 20,
        color: Color = Color.black,
        bgColor: Color = Color.black,
        textSize: CGFloat = 13,
        isMarked: Bool = false,
        callback: @escaping (String)->()
        ) {
        self.id = id
        self.label = label
        self.image = image
        self.description = description
        self.size = size
        self.color = color
        self.bgColor = bgColor
        self.textSize = textSize
        self.isMarked = isMarked
        self.callback = callback
    }
    
    var body: some View {
        Button(action:{
                    self.callback(self.id)
                }) {
                    HStack(alignment: .center) {
                        Image(image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                        
                        VStack {
                            Text(label)
                                .font(Font.system(size: textSize, weight: .bold))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .multilineTextAlignment(.leading)
                            
                            if !description.isEmpty {
                                Text(description)
                                    .font(.system(size: 15))
                                    .foregroundColor(.gray)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .multilineTextAlignment(.leading)
                            }
                            
                        }
                        
                        Image(systemName: self.isMarked ? "largecircle.fill.circle" : "circle")
                            .clipShape(Circle())
                            .foregroundColor(self.bgColor)
                        
                        Spacer()
                    }.foregroundColor(self.color)
                }
                .foregroundColor(Color.white)
        }
}

struct RadioButtonField1: View {
    let id: String
    let label: String
    let size: CGFloat
    let color: Color
    let bgColor: Color
    let textSize: CGFloat
    let isMarked:Bool
    let callback: (String)->()
        
    init(
        id: String,
        label:String,
        size: CGFloat = 20,
        color: Color = Color.black,
        bgColor: Color = Color.black,
        textSize: CGFloat = 15,
        isMarked: Bool = false,
        callback: @escaping (String)->()
        ) {
        self.id = id
        self.label = label
        self.size = size
        self.color = color
        self.bgColor = bgColor
        self.textSize = textSize
        self.isMarked = isMarked
        self.callback = callback
    }
    
    var body: some View {
        Button(action:{
                    self.callback(self.id)
                }) {
                    HStack(alignment: .center) {
                        Image(systemName: self.isMarked ? "largecircle.fill.circle" : "circle")
                            .clipShape(Circle())
                            .foregroundColor(self.bgColor)
                        
                        VStack {
                            Text(label)
                                .font(Font.system(size: textSize))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .multilineTextAlignment(.leading)
                        }
                        
                        Spacer()
                    }.foregroundColor(self.color)
                }
                .foregroundColor(Color.white)
        }
}
