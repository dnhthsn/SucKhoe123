//
//  PostImageView.swift
//  VinSocial
//
//  Created by Đinh Thái Sơn on 15/03/2023.
//

import SwiftUI
import Kingfisher

struct WritePostImageView: View {
    @EnvironmentObject var postData: PostViewModel
    @GestureState var draggingOffset: CGSize = .zero
    @State var medias : [UIImage]
    @Environment(\.dismiss) var dismiss
    var body: some View {
        ZStack {
            ScrollView(.init()) {
                TabView(selection: $postData.selectedImageID) {
                    ForEach(medias.indices, id: \.self) {media in
                        Image(uiImage: medias[media])
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .tag(media)
                            .scaleEffect(postData.selectedImageID == medias[media].toPngString() ? (postData.imageScale > 0.5 ? postData.imageScale : 0.5) : 0.5)
                            .offset(y: postData.imageViewerOffset.height)
                            .gesture(
                                MagnificationGesture().onChanged({ (value) in
                                    postData.imageScale = value
                                }).onEnded({ (_) in
                                    withAnimation(.spring()) {
                                        postData.imageScale = 1
                                    }
                                })
                                .simultaneously(with: TapGesture(count: 2).onEnded({
                                    withAnimation{
                                        postData.imageScale = postData.imageScale > 0.5 ? 0.5 : 4
                                    }
                                }))
                            )
                        
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                .overlay(
                    Button(action: {
                        withAnimation(.default) {
                            postData.showImageViewer.toggle()
                            dismiss()
                        }
                    }, label: {
                        Image(systemName: "xmark")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.white.opacity(0.35))
                            .clipShape(Circle())
                    })
                    .padding(10)
                    .padding(.top, UIApplication.shared.windows.first?.safeAreaInsets.top)
                    .opacity(postData.bgOpacity)
                    
                    , alignment: .topTrailing
                )
            }
            
            .ignoresSafeArea()

        }
        .gesture(DragGesture().updating($draggingOffset, body: { (value, outValue, _) in
            
            outValue = value.translation
            postData.onChanged(value: draggingOffset)
            
        }).onEnded(postData.onEnd(value:)))
        .transition(.move(edge: .bottom))
    }
}

//struct PostImageView_Previews: PreviewProvider {
//    static var previews: some View {
//        PostImageView()
//    }
//}
