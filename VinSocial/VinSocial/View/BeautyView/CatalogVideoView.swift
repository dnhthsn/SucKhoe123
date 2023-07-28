//
//  CatalogVideoView.swift
//  Suckhoe123
//
//  Created by Đinh Thái Sơn on 02/06/2023.
//

import SwiftUI
import AVFoundation
import Kingfisher

struct CatalogVideoView: View {
    var catalogVideo: CatalogVideo
    @State var showVideo: Bool = false
    @State var playVideo: Bool = false
    @State private var player = AVPlayer()
    @State var showDetail: Bool = false
    var catalogName: String
    @State var content: String = ""
    @State var titleVideo: String = ""
    
    var body: some View {
        LazyVStack {
            HStack {
                ZStack {
                    KFImage
                        .url((URL(string: "https://ws.suckhoe123.vn\(catalogVideo.image ?? "")")))
                        .resizable()
                        .scaledToFill()
                        .aspectRatio(contentMode: .fill)
                        .clipped()
                        .aspectRatio(1, contentMode: .fit)
                        .frame(width: 125, height: 70)
                    
                    Image(systemName: "play.circle")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(Color.white)
                }
                
//                VideoCard(video: "", videoLink: "https://suckhoe123.vn\(catalogVideo.urlvideo ?? "")", playVideo: $playVideo)
//                    .padding(.trailing, 20)
                
                VStack {
                    Text(titleVideo)
                        .foregroundColor(Color.black)
                        .font(.system(size: 16, weight: .bold))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)
                    
                    HStack {
                        HStack {
                            Image("ic_time")
                                .frame(width: 16, height: 16)
                            
                            if CheckTime().getCurrentTime() == CheckTime().convertTime(time: Int(catalogVideo.addtime ?? "") ?? 0) {
                                Text("• Vừa xong")
                                    .foregroundColor(Color.gray)
                                    .font(.system(size: 16))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .truncationMode(.tail)
                                    .frame(height: 30)
                            } else {
                                Text("\(CheckTime().compareTime(timeArr1: CheckTime().convertTime(time: Int(catalogVideo.addtime ?? "") ?? 0), timeArr2: CheckTime().getCurrentTime()))")
                                    .foregroundColor(Color.gray)
                                    .font(.system(size: 16))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .truncationMode(.tail)
                                    .frame(height: 30)
                            }
                        }
                        
                        HStack {
                            Image("ic_eye")
                                .frame(width: 16, height: 16)
                            
                            Text("\(catalogVideo.hitstotal ?? "") lượt xem")
                                .foregroundColor(Color.gray)
                                .font(.system(size: 13))
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .background(Color.white)
            .frame(maxWidth: .infinity, alignment: .top)
            
            Text(content)
                .foregroundColor(Color.black)
                .lineLimit(2)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(10)
        .overlay(
            RoundedRectangle(cornerRadius: 6)
                .stroke(Color(red: 0.957, green: 0.957, blue: 0.957), lineWidth: 2)
                
        )
        .background(RoundedRectangle(cornerRadius: 6).fill(.white).shadow(radius: 2))
        .frame(width: UIScreen.main.bounds.width-20)
        .onTapGesture {
            showDetail.toggle()
        }
        .fullScreenCover(isPresented: $showDetail, content: {
            CatalogVideoDetailView(catalogVideo: catalogVideo, catalogName: catalogName)
        })
        .onAppear {
            DispatchQueue.main.async {
                content = (catalogVideo.hometext ?? "").htmlToString()
                titleVideo = (catalogVideo.title ?? "").htmlToString()
            }
        }
    }
}
