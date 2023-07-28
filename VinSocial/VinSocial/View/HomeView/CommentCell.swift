//
//  CommentCell.swift
//  VinSocial
//
//  Created by Đinh Thái Sơn on 18/04/2023.
//

import SwiftUI
import Kingfisher

struct CommentCell: View {
    @ObservedObject var viewModel: CommentViewModel
    @ObservedObject var commentCellViewModel: CommentCellViewModel
    @State var stateResponse: Bool = false
    
    var body: some View {
        VStack {
            HStack(alignment: .center, spacing: 5) {
                VStack {
                    KFImage(URL(string: commentCellViewModel.getLinkAvatarUser))
                        .resizable()
                        .scaledToFill()
                        .frame(width: 45, height: 45)
                        .clipShape(Circle())
                        
                }
                .frame(maxHeight: .infinity, alignment: .top)
                
                VStack {
                    Text(commentCellViewModel.nameUser)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(Color.black)
                        .font(.system(size: 18))
                    
                    if commentCellViewModel.convertTime(time: commentCellViewModel.addTime) == commentCellViewModel.getCurrentTime() {
                        Text("• Vừa xong")
                            .foregroundColor(Color.gray)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    } else {
                        Text("• \(commentCellViewModel.compareTime(timeArr1: commentCellViewModel.convertTime(time: commentCellViewModel.addTime), timeArr2: commentCellViewModel.getCurrentTime()))")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    Text(commentCellViewModel.content)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(Color.black)
                        .font(.system(size: 18))
                    
                    if commentCellViewModel.comment.media?.media_url != nil {
                        KFImage(URL(string: "https://ws.suckhoe123.vn\(commentCellViewModel.comment.media?.media_url ?? "")"))
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: .infinity)
                            .frame(height: 150)
                    }
                    
                    HStack {
                        HStack {
                            Image("ic_heart_reaction")
                                .resizable()
                                .frame(width: 30, height: 30)
                            
                            Text("\(commentCellViewModel.getLike)")
                                .foregroundColor(Color.gray)
                        }
                        
                        Text("Trả lời")
                            .foregroundColor(Color.blue)
                            .padding(.leading, 20)
                            .onTapGesture {
                                stateResponse.toggle()
                            }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                        
                    if commentCellViewModel.comment.totalreply != "0" {
                        Text("Xem tất cả \(commentCellViewModel.comment.totalreply ?? "") trả lời")
                            .foregroundColor(Color.gray)
                            .font(.system(size: 16))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .onTapGesture {
                                stateResponse.toggle()
                            }
                    }
                }
                    
            }
            .padding([.leading, .trailing], 20)
            .fullScreenCover(isPresented: $stateResponse, content: {
                ReplyView(viewModel: viewModel, commentCellViewModel: commentCellViewModel)
            })
        }
    }
}
