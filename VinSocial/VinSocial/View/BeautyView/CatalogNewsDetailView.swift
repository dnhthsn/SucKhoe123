//
//  CatalogNewsDetailView.swift
//  Suckhoe123
//
//  Created by Đinh Thái Sơn on 29/05/2023.
//

import SwiftUI
import Kingfisher

struct CatalogNewsDetailView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: BeautyViewModel
    let postid: String
    var title: String
    @State var hometext: String = ""
    @State var bodytext: String = ""
    @State var description: String = ""
    @State var newTitle: String = ""
    
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
                        VStack {
                            HStack {
                                KFImage
                                    .url((URL(string: "https://ws.suckhoe123.vn\(viewModel.catalogNewsDetail?.user_info?.avatar! ?? "")")))
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .clipShape(Circle())
                                    .padding(5)
                                
                                VStack {
                                    Text(viewModel.catalogNewsDetail?.user_info?.fullname ?? "")
                                        .foregroundColor(Color.black)
                                        .font(.system(size: 18, weight: .bold))
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    
                                    if CheckTime().getCurrentTime() == CheckTime().convertTime(time: Int(viewModel.catalogNewsDetail?.addtime ?? "") ?? 0) {
                                        Text("• Vừa xong")
                                            .foregroundColor(Color.gray)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .truncationMode(.tail)
                                            .frame(height: 30)
                                    } else {
                                        Text(CheckTime().compareTime(timeArr1: CheckTime().convertTime(time: Int(viewModel.catalogNewsDetail?.addtime ?? "") ?? 0), timeArr2: CheckTime().getCurrentTime()))
                                            .foregroundColor(Color.gray)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .truncationMode(.tail)
                                            .frame(height: 30)
                                    }
                                }
                                
                                Button(action: {
                                    
                                }, label: {
                                    HStack {
                                        ShareLink(item: viewModel.catalogNewsDetail?.linkpost ?? "") {
                                            Image("ic_share")
                                                .resizable()
                                                .foregroundColor(Color(red: 23/255, green: 136/255, blue: 192/255))
                                                .frame(width: 20, height: 20)
                                            
                                            Text("Chia sẻ")
                                                .font(.headline)
                                                .foregroundColor(Color(red: 23/255, green: 136/255, blue: 192/255))
                                        }
                                        
                                    }
                                    .padding(10)
                                    
                                        
                                })
                                .background(Color(red: 238/255, green: 249/255, blue: 255/255))
                                .cornerRadius(15)
                                .padding(10)
                            }
                            .padding([.leading, .trailing], 20)
                            
                            Divider()
                                .padding([.leading, .trailing], 20)
                            
                            VStack {
                                Text(newTitle)
                                    .foregroundColor(Color.black)
                                    .font(.system(size: 18, weight: .bold))
                                    .frame(maxWidth: .infinity, alignment: .leading)

                                KFImage
                                    .url((URL(string: "https://suckhoe123.vn\(viewModel.catalogNewsDetail?.image ?? "")")))
                                    .resizable()
                                    .frame(width: UIScreen.main.bounds.width-20, height: 300)
                                    .cornerRadius(10)

                                Text(description)
                                    .foregroundColor(Color.black)
                                    .font(.system(size: 18, weight: .bold))
                                    .frame(maxWidth: .infinity, alignment: .leading)

                                Text(hometext)
                                    .foregroundColor(Color.black)
                                    .font(.system(size: 16))
                                    .frame(maxWidth: .infinity, alignment: .leading)

                                Text(bodytext)
                                    .foregroundColor(Color.black)
                                    .font(.system(size: 16))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .padding([.leading, .trailing], 20)
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
            }
            
            
        }
        .onAppear {
            if title == "thammy" {
                viewModel.catalogNewsDetail(category: "lam-dep", postid: postid, act: "news-detail")
            } else {
                viewModel.catalogNewsDetail(category: "suc-khoe", postid: postid, act: "news-detail")
            }
            
            DispatchQueue.main.async {
                hometext = (viewModel.catalogNewsDetail?.hometext ?? "").htmlToString()
                bodytext = (viewModel.catalogNewsDetail?.bodytext ?? "").htmlToString()
                description = (viewModel.catalogNewsDetail?.description ?? "").htmlToString()
                newTitle = (viewModel.catalogNewsDetail?.title ?? "").htmlToString()
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
