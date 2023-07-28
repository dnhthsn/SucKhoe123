//
//  CatalogQuestionDetailView.swift
//  Suckhoe123
//
//  Created by Đinh Thái Sơn on 30/05/2023.
//

import SwiftUI
import Kingfisher

struct CatalogQuestionDetailView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: BeautyViewModel
    let postid: String
    var title: String
    
    var body: some View {
        ZStack {
            if viewModel.showLoading {
                bottomProgressView
            } else {
                VStack {
                    HStack {
                        Image("ic_back_arrow")
                            .resizable()
                            .frame(width: 26, height: 26)
                            .foregroundColor(Color.white)
                            .onTapGesture {
                                dismiss()
                            }
                        
                        Text("Chi tiết câu hỏi")
                            .foregroundColor(Color.white)
                            .font(.system(size: 20))
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(.bottom, 20)
                    .padding([.leading, .trailing], 20)
                    .background(Color(red: 23/255, green: 136/255, blue: 192/255))
                    .frame(maxWidth: .infinity, alignment: .top)
                    
                    ScrollView {
                        VStack {
                            VStack {
                                HStack {
                                    KFImage
                                        .url((URL(string: "https://suckhoe123.vn\(viewModel.catalogQuestionDetail?.user_info?.avatar ?? "")")))
                                        .resizable()
                                        .frame(width: 50, height: 50)
                                        .clipShape(Circle())
                                        .padding(5)
                                    
                                    VStack {
                                        Text(viewModel.catalogQuestionDetail?.user_info?.fullname ?? "")
                                            .foregroundColor(Color.black)
                                            .font(.system(size: 20, weight: .bold))
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                        
                                        if CheckTime().getCurrentTime() == CheckTime().convertTime(time: Int(viewModel.catalogQuestionDetail?.addtime ?? "") ?? 0) {
                                            Text("• Vừa xong")
                                                .foregroundColor(Color.gray)
                                                .font(.system(size: 16))
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                                .truncationMode(.tail)
                                                .frame(height: 30)
                                        } else {
                                            Text(CheckTime().compareTime(timeArr1: CheckTime().convertTime(time: Int(viewModel.catalogQuestionDetail?.addtime ?? "") ?? 0), timeArr2: CheckTime().getCurrentTime()))
                                                .foregroundColor(Color.gray)
                                                .font(.system(size: 16))
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                                .truncationMode(.tail)
                                                .frame(height: 30)
                                        }
                                    }
                                }
                                
                                Text(viewModel.catalogQuestionDetail?.title ?? "")
                                    .foregroundColor(Color.black)
                                    .font(.system(size: 20, weight: .bold))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                Text(viewModel.catalogQuestionDetail?.content ?? "")
                                    .foregroundColor(Color.gray)
                                    .font(.system(size: 20))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                HStack {
                                    Image("ic_eye")
                                        .frame(width: 16, height: 16)
                                    
                                    Text("\(viewModel.catalogQuestionDetail?.hitstotal ?? "") lượt xem")
                                        .foregroundColor(Color.gray)
                                        .font(.system(size: 13))
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .padding(15)
                            .background(Color(red: 244/255, green: 244/255, blue: 244/255))
                            .cornerRadius(10)
                            
                            Text("Có \(Text(viewModel.catalogQuestionDetail?.numreply ?? "").foregroundColor(Color.blue)) câu trả lời từ các chuyên gia")
                                .foregroundColor(Color.black)
                                .font(.system(size: 16, weight: .bold))
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            if let listanswer = viewModel.catalogQuestionDetail?.listanswer {
                                ForEach(listanswer) { answer in
                                    CatalogAnswerView(listAnswer: answer)
                                }
                            }
                            
                            
                        }
                        .padding([.leading, .trailing], 20)
                    }
                    .padding(.top, 10)
                }
                .gesture(
                    DragGesture()
                        .onEnded { gesture in
                            if gesture.translation.width > 100 {
                                dismiss()
                            }
                        }
                )
            }
        }
        .onAppear {
            if title == "thammy" {
                viewModel.catalogQuestionDetail(category: "lam-dep", postid: postid, act: "question-detail")
            } else {
                viewModel.catalogQuestionDetail(category: "suc-khoe", postid: postid, act: "question-detail")
            }
        }
    }
    
    @ViewBuilder
    private var bottomProgressView: some View {
        HStack {
            Spacer()
            ProgressView()
            Spacer()
        }.padding()
    }
}
