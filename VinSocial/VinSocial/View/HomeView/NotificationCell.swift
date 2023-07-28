//
//  NotificationCell.swift
//  VinSocial
//
//  Created by Đinh Thái Sơn on 16/03/2023.
//

import SwiftUI
import Kingfisher

struct NotificationCell: View {
    @ObservedObject var viewModel:NotiCellViewModel
    @State var dateNow = Date.now
    
    func checkStyle()-> String {
        if viewModel.getStyleOf == "0" || viewModel.getStyleOf == "9" {
            return "ic_noti_heart"
        } else if viewModel.getStyleOf == "1" || viewModel.getStyleOf == "7"{
            return "ic_noti_comment"
        } else if  viewModel.getStyleOf == "2" || viewModel.getStyleOf == "8" {
            return "ic_noti_friends"
        } else if viewModel.getStyleOf == "3" || viewModel.getStyleOf == "4" || viewModel.getStyleOf == "5" || viewModel.getStyleOf == "6" {
            return "ic_noti_notify"
        }

        return ""
    }

    var body: some View {
        VStack {
            HStack(alignment: .center, spacing: 5) {
                KFImage(URL(string: viewModel.getLinkAvatarUser))
                    .resizable()
                    .scaledToFill()
                    .frame(width: 90, height: 90)
                    .clipShape(Circle())
                    .overlay(Image(checkStyle())
                            .clipShape(Circle())
                            .padding(4)
                            .background(Color.white)
                            .clipShape(Circle())
                            .offset(x: -5, y: 6)
                        
                        ,alignment: .bottomTrailing
                    )
                
                VStack {
                    Text("\(Text(viewModel.nameUser).foregroundColor(Color.black).font(.system(size: 18, weight: .bold))) \(viewModel.getContent)" )
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(Color.black)
                        .font(.system(size: 18))
                    
                    if CheckTime().convertTime(time: Int(viewModel.addTime)!) == CheckTime().getCurrentTime() {
                        Text("• Vừa xong")
                            .foregroundColor(Color.blue)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    } else {
                        Text("• \(CheckTime().compareTime(timeArr1: CheckTime().convertTime(time: Int(viewModel.addTime)!), timeArr2: CheckTime().getCurrentTime()))")
                            .font(.subheadline)
                            .foregroundColor(.blue)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                .padding(.leading, 10)
                    
            }
            .padding()
        }
        
    }
}
