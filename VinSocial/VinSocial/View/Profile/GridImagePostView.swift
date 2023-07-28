//
//  GridImageView.swift
//  VinSocial
//
//  Created by Đinh Thái Sơn on 15/03/2023.
//

import SwiftUI
import Kingfisher

struct GridImagePostView: View {
    
    @State var showImageViewer = false
    
    @State var selectedImageID: String = ""
    
    @State var imageViewerOffset: CGSize = .zero
    
    @State var bgOpacity: Double = 1
    
    @State var imageScale: CGFloat = 1
    
    func onChanged(value: CGSize) {
        DispatchQueue.main.async {
            imageViewerOffset = value
            
            let halgHeight = UIScreen.main.bounds.height / 2
            
            let progress = imageViewerOffset.height / halgHeight
            
            withAnimation(.default) {
                bgOpacity = Double(1 - (progress < 0 ? -progress:progress))
            }
        }
    }
    
    func onEnd(value: DragGesture.Value) {
        withAnimation(.easeInOut) {
            var translation = value.translation.height
            
            if translation < 0 {
                translation = -translation
            }
            
            if translation < 250 {
                imageViewerOffset = .zero
                bgOpacity = 1
            } else {
                showImageViewer.toggle()
                imageViewerOffset = .zero
                bgOpacity = 1
            }
        }
    }
    var index: Int
    @State var medias : [ImagePost]
    
    var body: some View {
            ZStack {
                if index <= 3 {
                    Image(uiImage: medias[index].imagePost)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: getWidth(index: index - 45), height: 150)
                        .cornerRadius(0)
                        .overlay(
                            Button(action: {
                                withAnimation(.default) {
                                    
                                }
                            }, label: {
                                Image(systemName: "xmark")
                                    .foregroundColor(.white)
                                    .padding(5)
                                    .background(Color.gray.opacity(1))
                                    .clipShape(Circle())
                            })
                            .padding(5)
                            
                            , alignment: .topLeading
                        )
                }
                
                if medias.count > 4 && index == 3 {
                    RoundedRectangle(cornerRadius: 0)
                        .fill(Color.black.opacity(0.3))
                    
                    let remainingImages = medias.count - 4
                    
                    Text("+\(remainingImages)")
                        .font(.title)
                        .font(.footnote.weight(.heavy))
                        .foregroundColor(.white)
                }
            }
    }
    
    func getWidth(index: Int)->CGFloat {
        let width = getRect().width - 45
        if medias.count % 2 == 0 {
            return width / 2
        } else {
            if index == medias.count - 1 {
                return width
            } else {
                return width / 2
            }
        }
    }
    

}

extension UIImage {
    func toPngString()-> String? {
        let data = self.pngData()
        return data?.base64EncodedString(options: .endLineWithLineFeed)
    }
    
    func toJpegString(compressionQuality cq: CGFloat) -> String? {
        let data = self.jpegData(compressionQuality: cq)
        return data?.base64EncodedString(options: .endLineWithLineFeed)
    }
}
