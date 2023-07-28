//
//  CatalogNewsView.swift
//  Suckhoe123
//
//  Created by Đinh Thái Sơn on 26/05/2023.
//

import SwiftUI
import Kingfisher

struct CatalogNewsView: View {
    @ObservedObject var viewModel: BeautyViewModel
    let catalogNews: CatalogNews
    var title: String
    @State var showDetail: Bool = false
    @State var newTitle: String = ""
    @State var hometext: String = ""
    
    var body: some View {
        VStack {
            HStack {
                KFImage
                    .url((URL(string: "https://suckhoe123.vn\(catalogNews.image ?? "")")))
                    .resizable()
                    .frame(width: 125, height: 100)
                    .cornerRadius(10)
                
                VStack {
                    Text(newTitle)
                        .frame(height: 60)
                        .truncationMode(.tail)
                        .multilineTextAlignment(.leading)
                        .foregroundColor(Color.black)
                        .font(.system(size: 16, weight: .bold))
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                    
                    HStack {
                        HStack {
                            Image("ic_time")
                                .frame(width: 16, height: 16)
                            
                            if CheckTime().getCurrentTime() == CheckTime().convertTime(time: Int(catalogNews.add_time ?? "")!) {
                                Text("• Vừa xong")
                                    .foregroundColor(Color.gray)
                                    .font(.system(size: 13))
                                    .truncationMode(.tail)
                                    .frame(height: 30)
                            } else {
                                Text(CheckTime().compareTime(timeArr1: CheckTime().convertTime(time: Int(catalogNews.add_time ?? "")!), timeArr2: CheckTime().getCurrentTime()))
                                    .foregroundColor(Color.gray)
                                    .font(.system(size: 13))
                                    .truncationMode(.tail)
                                    .frame(height: 30)
                            }
                        }
                        
                        HStack {
                            Image("ic_eye")
                                .frame(width: 16, height: 16)
                            
                            Text("\(catalogNews.hitstotal ?? "") lượt xem")
                                .foregroundColor(Color.gray)
                                .font(.system(size: 13))
                                .truncationMode(.tail)
                                .frame(height: 30)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            
            Text(hometext)
                .frame(height: 100)
                .truncationMode(.tail)
                .multilineTextAlignment(.leading)
                .foregroundColor(Color.black)
                .font(.system(size: 16))
                .frame(maxWidth: .infinity, alignment: .topLeading)
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
            CatalogNewsDetailView(viewModel: viewModel, postid: catalogNews.id ?? "", title: title)
        })
        .onAppear {
            DispatchQueue.main.async {
                newTitle = (catalogNews.title ?? "").htmlToString()
                hometext = (catalogNews.hometext ?? "").htmlToString()
            }
        }
    }
}
