//
//  PostImageView.swift
//  VinSocial
//
//  Created by Đinh Thái Sơn on 15/03/2023.
//

import SwiftUI
import Kingfisher

struct PostImageView: View {
    @EnvironmentObject var postData: PostViewModel
    @GestureState var draggingOffset: CGSize = .zero
    @State var medias : [Media]
    var body: some View {
        ZStack {
            ScrollView(.init()) {
                TabView(selection: $postData.selectedImageID) {
                    ForEach(medias, id: \.self) {media in
                        KFImage(URL(string: getLinkImage(media: media)))
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .tag(media.media_url!)
                            .scaleEffect(postData.selectedImageID == media.media_url ? (postData.imageScale > 1 ? postData.imageScale : 1) : 1)
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
                                        postData.imageScale = postData.imageScale > 1 ? 1 : 4
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
    
    func getLinkImage(media:Media)-> String {
        if media.media_url == nil {
            return ""
        }
       
        if media.media_url!.contains("https://"){
            return media.media_url ?? ""
        }
        return "https://suckhoe123.vn/"+(media.media_url ?? "")
    }
}

//struct PostImageView_Previews: PreviewProvider {
//    static var previews: some View {
//        PostImageView()
//    }
//}
