//
//  CatalogQuestionAnswerView.swift
//  Suckhoe123
//
//  Created by Đinh Thái Sơn on 30/05/2023.
//

import SwiftUI
import Kingfisher

struct CatalogAnswerView: View {
    var listAnswer: ListAnswer
    @State var isExpand: Bool = false
    @State var content: String = ""
    
    var body: some View {
        ZStack {
            VStack {
                Text("")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .background(Color(red: 23/255, green: 136/255, blue: 192/255))
            .cornerRadius(6)
            
            VStack {
                HStack {
                    KFImage
                        .url((URL(string: "https://suckhoe123.vn\(listAnswer.user_info?.avatar ?? "")")))
                        .resizable()
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                        .padding(5)
                    
                    VStack {
                        Text(listAnswer.user_info?.fullname ?? "")
                            .foregroundColor(Color.black)
                            .font(.system(size: 20, weight: .bold))
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        if CheckTime().getCurrentTime() == CheckTime().convertTime(time: Int(listAnswer.addtime ?? "") ?? 0) {
                            Text("• Vừa xong")
                                .foregroundColor(Color.gray)
                                .font(.system(size: 16))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .truncationMode(.tail)
                                .frame(height: 30)
                        } else {
                            Text(CheckTime().compareTime(timeArr1: CheckTime().convertTime(time: Int(listAnswer.addtime ?? "") ?? 0), timeArr2: CheckTime().getCurrentTime()))
                                .foregroundColor(Color.gray)
                                .font(.system(size: 16))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .truncationMode(.tail)
                                .frame(height: 30)
                        }
                    }
                }
                
                VStack {
                    Text(listAnswer.title ?? "")
                        .foregroundColor(Color.black)
                        .font(.system(size: 18, weight: .bold))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text(content)
                        .foregroundColor(Color.gray)
                        .font(.system(size: 18))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .lineLimit(isExpand ? nil : 3)
                }
                .padding([.leading, .trailing], 10)
                
                HStack {
                    Button(action: {
                        
                    }, label: {
                        HStack {
                            ShareLink(item: listAnswer.content ?? "") {
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
                content = (listAnswer.content ?? "").htmlToString()
            }
        }
    }
}
