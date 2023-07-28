//
//  CustomLoadingView.swift
//  Messenger
//
//  Created by Đinh Thái Sơn on 20/02/2023.
//

import Foundation
import SwiftUI

struct ActivityIndicator: UIViewRepresentable {
    typealias UIViewType = UIActivityIndicatorView
    let style: UIActivityIndicatorView.Style
    
    func makeUIView(context: UIViewRepresentableContext<ActivityIndicator>) -> ActivityIndicator.UIViewType {
        return UIActivityIndicatorView(style: style)
    }
    
    func updateUIView(_ uiView: ActivityIndicator.UIViewType, context: UIViewRepresentableContext<ActivityIndicator>) {
        uiView.startAnimating()
    }
}


struct ActivityIndicatorView<Content> : View where Content: View {
    @Binding var isDisplayed: Bool
    let textLoading: String
    let imageName: String
    var content: () -> Content
    
    var body: some View {
        VStack {
            if (!self.isDisplayed) {
                self.content()
            } else {
                self.content()
                    .disabled(true)
                    .blur(radius: 3)
                Image(imageName)
                    .resizable()
                    .frame(width: 70, height: 70)
                    .scaledToFit()
                    .padding()
                //ActivityIndicator(style: .large)
                Text(textLoading)
                    .frame(width: 150)
                    .foregroundColor(Color(red: 158/255, green: 158/255, blue: 158/255))
                    .padding()
            }
            
        }
        .background(Color.white)
        .cornerRadius(15)
//        GeometryReader { geometry in
//            ZStack (alignment: .center, content: {
//                if (!self.isDisplayed) {
//                    self.content()
//                } else {
//                    self.content()
//                        .disabled(true)
//                        .blur(radius: 3)
//
//                    VStack{
//                        Text("Đang đăng nhập...")
//                        ActivityIndicator(style: .large)
//                    }
//                    .frame(width: 200, height: 200.0, alignment: .center)
//                    .background(Color.white)
//                    .foregroundColor(Color.primary)
//                    .cornerRadius(20)
//                }
//            })
//        }
    }
}
