//
//  SupportQuestionView.swift
//  Suckhoe123
//
//  Created by Đinh Thái Sơn on 30/06/2023.
//

import SwiftUI
import Kingfisher

struct SupportQuestionView: View {
    @ObservedObject var viewModel: ProfileViewModel
    @Environment(\.dismiss) var dismiss
    @State var showBottomSheet: Bool = false
    @State var result: String = "new"
    var category: String
    var doctorid: String
    
    var body: some View {
        VStack {
            HStack {
                Image("ic_back_arrow")
                    .resizable()
                    .frame(width: 26, height: 26)
                    .foregroundColor(Color.black)
                    .onTapGesture {
                        viewModel.removeCacheExpertQuestion()
                        dismiss()
                    }
                
                Text("Hỗ trợ hỏi đáp")
                    .foregroundColor(Color.black)
                    .font(.system(size: 20, weight: .bold))
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Button(action: {
                    showBottomSheet.toggle()
                }, label: {
                    Image("ic_filter")
                        .resizable()
                        .frame(width: 35, height: 35)
                })
                .sheet(isPresented: $showBottomSheet, content: {
                    BottomSheetSortView(result: $result, type: "question").presentationDetents([.height(200), .large])
                })
                
            }
            .padding(.bottom, 20)
            .padding([.leading, .trailing], 20)
            .background(Color.white)
            .frame(maxWidth: .infinity, alignment: .top)
            
            ScrollView {
                LazyVStack {
                    ForEach(viewModel.expertQuestion) { question in
                        if question.postid == viewModel.expertQuestion.last?.postid {
                            ExpertQuestionView(question: question)
                            .task {
                                await viewModel.loadNextPageExpertQuestion(category: category, doctorid: doctorid, act: "question", sortby: result)
                            }
                        } else {
                            ExpertQuestionView(question: question)
                        }
                    }
                }
            }
            
        }
        .onAppear {
            viewModel.loadDataExpertQuestion(category: category, doctorid: doctorid, act: "question", sortby: "recent")
        }
        .gesture(
            DragGesture()
                .onEnded { gesture in
                    if gesture.translation.width > 100 {
                        dismiss()
                        viewModel.removeCacheExpertQuestion()
                    }
                }
        )
        .onChange(of: result) { output in
            viewModel.removeCacheExpertQuestion()
            viewModel.loadDataExpertQuestion(category: category, doctorid: doctorid, act: "question", sortby: result)
        }
    }
}

struct ExpertQuestionView: View {
    var question: CatalogQuestion
    @State var content: String = ""
    @State var isExpand: Bool = false
    
    var body: some View {
        VStack {
            VStack {
                HStack {
                    KFImage
                        .url((URL(string: "https://ws.suckhoe123.vn\(question.user_info?.avatar ?? "")")))
                        .resizable()
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                        .padding(5)

                    VStack {
                        Text(question.user_info?.fullname ?? "")
                            .foregroundColor(Color.black)
                            .font(.system(size: 20, weight: .bold))
                            .frame(maxWidth: .infinity, alignment: .leading)

                        Text("• \(question.addtime ?? "")")
                            .foregroundColor(Color.gray)
                            .font(.system(size: 16))
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }

                Text(question.title ?? "")
                    .foregroundColor(Color.black)
                    .font(.system(size: 20, weight: .bold))
                    .frame(maxWidth: .infinity, alignment: .leading)

    //                            Text(viewModel.catalogQuestionDetail?.content ?? "")
    //                                .foregroundColor(Color.gray)
    //                                .font(.system(size: 20))
    //                                .frame(maxWidth: .infinity, alignment: .leading)

                HStack {
                    Image("ic_eye")
                        .frame(width: 16, height: 16)

                    Text("\(question.hitstotal ?? "") lượt xem")
                        .foregroundColor(Color.gray)
                        .font(.system(size: 13))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(15)
            .background(Color(red: 244/255, green: 244/255, blue: 244/255))
            .cornerRadius(10)
            
            ZStack {
                VStack {
                    Text("")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .background(Color(red: 23/255, green: 136/255, blue: 192/255))
                .cornerRadius(6)
                
                VStack {
//                    HStack {
////                        KFImage
////                            .url((URL(string: "https://suckhoe123.vn\(listAnswer.user_info?.avatar ?? "")")))
////                            .resizable()
////                            .frame(width: 50, height: 50)
////                            .clipShape(Circle())
////                            .padding(5)
////
//                        VStack {
//                            Text(question.user_info?.fullname ?? "")
//                                .foregroundColor(Color.black)
//                                .font(.system(size: 20, weight: .bold))
//                                .frame(maxWidth: .infinity, alignment: .leading)
//
////                            Text("• \(listAnswer.addtime ?? "")")
////                                .foregroundColor(Color.gray)
////                                .font(.system(size: 16))
////                                .frame(maxWidth: .infinity, alignment: .leading)
//                        }
//                    }
                    
                    VStack {
//                        Text(question.title ?? "")
//                            .foregroundColor(Color.black)
//                            .font(.system(size: 18, weight: .bold))
//                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Text(content)
                            .foregroundColor(Color.gray)
                            .font(.system(size: 18))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .lineLimit(isExpand ? nil : 3)
                    }
                    .padding([.leading, .trailing, .top], 10)
                    
                    HStack {
                        Button(action: {
                            
                        }, label: {
                            HStack {
                                ShareLink(item: content) {
                                    Image("ic_share")
                                        .resizable()
                                        .foregroundColor(Color.gray)
                                        .frame(width: 20, height: 20)
                                    
                                    Text("Chia sẻ")
                                        .font(.headline)
                                        .foregroundColor(Color.gray)
                                }
                                
                            }
                            .padding(10)
                            
                                
                        })
                        .background(Color.white)
                        .cornerRadius(15)
                        .padding(10)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Button(action: {
                            isExpand.toggle()
                        }, label: {
                            HStack {
                                Text(isExpand ? "Thu gọn" : "Xem thêm")
                                    .font(.headline)
                                    .foregroundColor(Color(red: 23/255, green: 136/255, blue: 192/255))
                                
                                Image(isExpand ? "ic_up" : "ic_dropdown")
                                    .resizable()
                                    .foregroundColor(Color(red: 23/255, green: 136/255, blue: 192/255))
                                    .frame(width: 20, height: 20)
                            }
                            .padding(10)
                            
                                
                        })
                        .background(Color(red: 238/255, green: 249/255, blue: 255/255))
                        .cornerRadius(15)
                        .padding(10)
                    }
                }
                .background(Color.white)
                .padding(.leading, 5)
                .cornerRadius(6)
            }
            .overlay(
                RoundedRectangle(cornerRadius: 6)
                    .stroke(Color(red: 0.957, green: 0.957, blue: 0.957), lineWidth: 2)
                    
            )
            .background(RoundedRectangle(cornerRadius: 6).fill(.white).shadow(radius: 2))
            .onAppear {
                DispatchQueue.main.async {
                    content = (question.doctor_answer ?? "").htmlToString()
                }
            }
        }
        .padding([.leading, .trailing], 15)
    }
}
