//
//  GridImageView.swift
//  VinSocial
//
//  Created by Đinh Thái Sơn on 15/03/2023.
//

import SwiftUI
import Kingfisher
import AVKit


struct GridImageView: View {
    @EnvironmentObject var postData: PostViewModel
    @State var isErrorLoadingImage: Bool = false
    @State var isSuccessLoadingImage: Bool = false
    func onChanged(value: CGSize) {
        DispatchQueue.main.async {
            postData.imageViewerOffset = value
            
            let halgHeight = UIScreen.main.bounds.height / 2
            
            let progress = postData.imageViewerOffset.height / halgHeight
            
            withAnimation(.default) {
                postData.bgOpacity = Double(1 - (progress < 0 ? -progress:progress))
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
                postData.imageViewerOffset = .zero
                postData.bgOpacity = 1
            } else {
                postData.showImageViewer.toggle()
                postData.imageViewerOffset = .zero
                postData.bgOpacity = 1
            }
        }
    }
    
    var index: Int
    @ObservedObject var cellModel:FeedCellViewModel
    @State var showVideo: Bool = false
    @State var playVideo: Bool = false
    @State private var player = AVPlayer()
    
    var body: some View {
        ZStack {
            if index <= 3 {
                if getTypeMedia == "video" {
                    VideoCard(video: getThubmImageForVideo, videoLink: getLinkMedia, playVideo: $playVideo)
                        .padding(.trailing, 20)
                        .onTapGesture {
                            showVideo.toggle()
                        }
                 
                }else{
                    KFImage(URL(string: isErrorLoadingImage ? stringURL : getLinkMedia))
                        .onSuccess { r in
                            isSuccessLoadingImage = true
                        }
                        .placeholder { p in
                            if (!isErrorLoadingImage && !isSuccessLoadingImage) {
//                                ProgressView(p)
                            }
                           
                        }
                        .onFailure { t in
                            isErrorLoadingImage = true
                        }
                        .resizable()
                        //.aspectRatio(contentMode: .fill)
                        .frame(width: getWidth(index: index), height: 250)
                        .cornerRadius(12)
                }
                
            }
        }  .environmentObject(postData)

      
    }
    
    func getWidth(index: Int)->CGFloat {
        let width = getRect().width - 20
        if cellModel.getMedia.count % 2 == 0 {
            return width/2
        } else {
            if index == cellModel.getMedia.count - 1 {
                return width
            } else {
                return width/2
            }
        }
    }
    
    var getLinkMedia: String {
        if cellModel.getMedia[index].media_url == nil {
            return ""
        }
       
        if cellModel.getMedia[index].media_url!.contains("https://"){
            return cellModel.getMedia[index].media_url ?? ""
        }
        if cellModel.checkOwnerPost {
            return "https://ws.suckhoe123.vn"+(cellModel.getMedia[index].media_url ?? "")
        }
        return "https://suckhoe123.vn"+(cellModel.getMedia[index].media_url ?? "")
    }
    
    var getTypeMedia: String {
        if cellModel.getMedia[index].media_type != nil {
            return cellModel.getMedia[index].media_type ?? ""
        }
        return ""
    }
    
    var getThubmImageForVideo: String {
        if cellModel.getMedia[index].media_thumb == nil {
            return ""
        }
        return cellModel.getMedia[index].media_thumb ?? ""
    }
    
    
    private var asyncImage: some View  {
        AsyncImage(url: URL(string: getLinkMedia)) { phase in
            switch phase {
            case .empty:
                HStack {
                    Spacer()
                    ProgressView()
                    Spacer()
                }
                
            case .success(let image):
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                
            case .failure:
                HStack {
                    Spacer()
                    Image(systemName: "photo")
                        .imageScale(.large)
                    Spacer()
                }
                
                
            @unknown default:
                fatalError()
            }
        }
    }
}

extension View {
    func getRect()->CGRect {
        return UIScreen.main.bounds
    }
}

//struct GridImageView_Previews: PreviewProvider {
//    static var previews: some View {
//        GridImageView()
//    }
//}
