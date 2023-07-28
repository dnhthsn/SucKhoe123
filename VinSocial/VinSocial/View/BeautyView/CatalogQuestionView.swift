//
//  CatalogQuestionView.swift
//  Suckhoe123
//
//  Created by Đinh Thái Sơn on 29/05/2023.
//

import SwiftUI
import Kingfisher

struct CatalogQuestionView: View {
    @ObservedObject var viewModel: BeautyViewModel
    let catalogQuestion: CatalogQuestion
    var title: String
    @State var showDetail: Bool = false
    
    var body: some View {
        VStack {
            HStack {
                KFImage
                    .url((URL(string: "https://ws.suckhoe123.vn\(catalogQuestion.user_info?.avatar! ?? "")")))
                    .resizable()
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
                    .padding(5)
                
                VStack {
                    Text(catalogQuestion.user_info?.fullname ?? "")
                        .foregroundColor(Color.black)
                        .font(.system(size: 18, weight: .bold))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    if CheckTime().getCurrentTime() == CheckTime().convertTime(time: Int(catalogQuestion.addtime ?? "") ?? 0) {
                        Text("• Vừa xong")
                            .foregroundColor(Color.gray)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .truncationMode(.tail)
                            .frame(height: 30)
                    } else {
                        Text(CheckTime().compareTime(timeArr1: CheckTime().convertTime(time: Int(catalogQuestion.addtime ?? "") ?? 0), timeArr2: CheckTime().getCurrentTime()))
                            .foregroundColor(Color.gray)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .truncationMode(.tail)
                            .frame(height: 30)
                    }
                }
            }
            
            Text(catalogQuestion.title ?? "")
                .foregroundColor(Color.black)
                .font(.system(size: 16, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text(catalogQuestion.hometext ?? "")
                .foregroundColor(Color.black)
                .font(.system(size: 13))
                .frame(maxWidth: .infinity, alignment: .leading)
                .frame(height: 50)
                .multilineTextAlignment(.leading)
                .truncationMode(.tail)
            
            HStack(spacing: 20) {
                HStack {
                    Image("ic_comment")
                        .resizable()
                        .frame(width: 16, height: 16)
                    
                    Text(catalogQuestion.numreply ?? "")
                        .foregroundColor(Color.gray)
                }
                
                HStack {
                    Image("ic_eye")
                        .resizable()
                        .frame(width: 16, height: 16)
                    
                    Text(catalogQuestion.hitstotal ?? "")
                        .foregroundColor(Color.gray)
                }
            }
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
            self.showDetail.toggle()
        }
        .fullScreenCover(isPresented: $showDetail, content: {
            CatalogQuestionDetailView(viewModel: viewModel, postid: catalogQuestion.postid ?? "", title: title)
        })
    }
}
