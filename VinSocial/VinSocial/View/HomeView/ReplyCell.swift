//
//  ResponseCell.swift
//  Suckhoe123
//
//  Created by Đinh Thái Sơn on 12/06/2023.
//

import SwiftUI
import Kingfisher

struct ReplyCell: View {
    @ObservedObject var viewModel: CommentCellViewModel
    var reply: CommentResponse
    
    var body: some View {
        VStack {
            HStack(alignment: .center, spacing: 5) {
                VStack {
                    KFImage(URL(string: "https://ws.suckhoe123.vn\(reply.userid_create_comment?.avatar ?? "")"))
                        .resizable()
                        .scaledToFill()
                        .frame(width: 45, height: 45)
                        .clipShape(Circle())
                }
                .frame(maxHeight: .infinity, alignment: .top)

                VStack {
                    Text(reply.userid_create_comment?.fullname ?? "")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(Color.black)
                        .font(.system(size: 18))
                    
                    if viewModel.convertTime(time: reply.addtime ?? "") == viewModel.getCurrentTime() {
                        Text("• Vừa xong")
                            .foregroundColor(Color.gray)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    } else {
                        Text("• \(viewModel.compareTime(timeArr1: viewModel.convertTime(time: reply.addtime ?? ""), timeArr2: viewModel.getCurrentTime()))")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    Text(reply.content ?? "")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(Color.black)
                        .font(.system(size: 18))
                    
                    if reply.media != nil {
                        KFImage(URL(string: "https://ws.suckhoe123.vn\(reply.media?.media_url ?? "")"))
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: .infinity)
                            .frame(height: 150)
                    } else {
                        Text("")
                    }
                    
                    HStack {
                        HStack {
                            Image("ic_heart_reaction")
                                .resizable()
                                .frame(width: 30, height: 30)
                            
                            Text("\(reply.likes ?? "")")
                                .foregroundColor(Color.gray)
                        }
                        
                        Text("Trả lời")
                            .foregroundColor(Color.blue)
                            .padding(.leading, 20)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                        
                }
                    
            }
        }
    }
}
