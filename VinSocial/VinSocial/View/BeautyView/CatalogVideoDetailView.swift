//
//  CatalogVideoDetailView.swift
//  Suckhoe123
//
//  Created by Đinh Thái Sơn on 02/06/2023.
//

import SwiftUI
import Kingfisher

struct CatalogVideoDetailView: View {
    @Environment(\.dismiss) var dismiss
    var catalogVideo: CatalogVideo
    var catalogName: String
    @State var showVideo: Bool = false
    @State var playVideo: Bool = false
    @State var content: String = ""
    @State var title: String = ""
    @State var fullname: String = ""
    
    var body: some View {
        VStack {
            HStack {
                Image("ic_back_arrow")
                    .resizable()
                    .frame(width: 26, height: 26)
                    .foregroundColor(Color.white)
                    .onTapGesture {
                        dismiss()
                    }
                
                Text("Chi tiết")
                    .foregroundColor(Color.white)
                    .font(.system(size: 20))
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.bottom, 20)
            .padding([.leading, .trailing], 20)
            .background(Color(red: 23/255, green: 136/255, blue: 192/255))
            .frame(maxWidth: .infinity, alignment: .top)
            
            ScrollView {
                LazyVStack {
//                    if ((catalogVideo.urlvideo?.contains("https")) != nil) {
//                        VideoCard1(video: "", videoLink: catalogVideo.urlvideo ?? "", playVideo: $playVideo)
//                    } else {
//                        VideoCard1(video: "", videoLink: "https://suckhoe123.vn\(catalogVideo.urlvideo ?? "")", playVideo: $playVideo)
//                    }
                    
                    VideoCard1(video: "", videoLink: "https://suckhoe123.vn\(catalogVideo.urlvideo ?? "")", playVideo: $playVideo)

                    Text(title)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(Color.black)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding([.leading, .trailing], 15)
                    
                    HStack {
                        if catalogName != "" {
                            Text("Danh mục: \(catalogName)")
                                .foregroundColor(Color.gray)
                                .font(.system(size: 13))
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }

                        HStack {
                            Image("ic_time")
                                .frame(width: 16, height: 16)
                            
                            
                            if CheckTime().getCurrentTime() == CheckTime().convertTime(time: Int(catalogVideo.addtime ?? "") ?? 0) {
                                Text("• Vừa xong")
                                    .foregroundColor(Color.gray)
                                    .font(.system(size: 13))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .truncationMode(.tail)
                                    .frame(height: 30)
                            } else {
                                Text("\(CheckTime().compareTime(timeArr1: CheckTime().convertTime(time: Int(catalogVideo.addtime ?? "") ?? 0), timeArr2: CheckTime().getCurrentTime()))")
                                    .foregroundColor(Color.gray)
                                    .font(.system(size: 13))
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
                    .padding([.leading, .trailing], 15)
                    
                    HStack {
                        KFImage
                            .url((URL(string: "https://ws.suckhoe123.vn\(catalogVideo.user_info?.avatar ?? "")")))
                            .resizable()
                            .scaledToFill()
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                            .padding(5)
                            .frame(maxHeight: .infinity, alignment: .top)
                        
                        VStack {
                            Text(fullname)
                                .foregroundColor(Color.black)
                                .font(.system(size: 20, weight: .bold))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .lineLimit(1)
                            
                        }
                        
                        Button(action: {
                            
                        }, label: {
                            ShareLink(item: catalogVideo.linkshare ?? "") {
                                Image("ic_share")
                                    .foregroundColor(Color(red: 23/255, green: 136/255, blue: 192/255))
                                    .frame(width: 18, height: 18)
                                    .padding()
                            }
                            
                        })
                        .background(Color(red: 238/255, green: 249/255, blue: 255/255))
                        .cornerRadius(15)
                        .padding(10)
                        
                        Button(action: {
                            let application = UIApplication.shared;
                            let appURLScheme = "VinChat" // Replace with the URL scheme of the target app
                           
                            if catalogVideo.user_info?.firebaseuid == nil{
                                return
                            }
                            let json = catalogVideo.user_info?.toJSON()
                            let dataToTransfer = json// Data you want to transfer
                            var urlComponents = URLComponents()
                            urlComponents.scheme = appURLScheme
                            urlComponents.queryItems = [URLQueryItem(name: "user_id", value: catalogVideo.user_info?.userid ?? ""), URLQueryItem(name: "firebaseuid", value: catalogVideo.user_info?.firebaseuid ?? "")]
                            if let url = urlComponents.url, UIApplication.shared.canOpenURL(url) {
                                let test = print(" hoi nx \(url)")
                                       UIApplication.shared.open(url) { success in
                                           if !success {
                                               // Failed to open the other app
                                               print("Failed to open other app.")
                                           }
                                       }
                                   }
                        }, label: {
                            Text("Nhắn tin")
                                .foregroundColor(Color.white)
                                .font(.system(size: 16))
                                .padding()
                        })
                        .background(Color(red: 23/255, green: 136/255, blue: 192/255))
                        .cornerRadius(15)
                    }
                    .padding([.leading, .trailing], 15)
                    
                    Text(content)
                        .foregroundColor(Color.black)
                        .font(.system(size: 18))
                        .multilineTextAlignment(.leading)
                        .padding([.leading, .trailing], 15)
                }
            }
            
        }
        .gesture(
            DragGesture()
                .onEnded { gesture in
                    if gesture.translation.width > 100 {
                        dismiss()
                    }
                }
        )
        .onAppear {
            DispatchQueue.main.async {
                content = (catalogVideo.hometext ?? "").htmlToString()
                title = (catalogVideo.title ?? "").htmlToString()
                fullname = (catalogVideo.user_info?.fullname ?? "").htmlToString()
            }
        }
    }
}
