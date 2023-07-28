//
//  ListLikeView.swift
//  VinSocial
//
//  Created by Đinh Thái Sơn on 27/03/2023.
//

import SwiftUI
import Kingfisher

struct ListLikeView: View {
    var like: Like
    var total: Int
    var body: some View {
        ZStack{
            VStack {
                HStack {
                    Text("Tất cả (\(total))")
                        .foregroundColor(Color.black)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 20)
                }
                    
                Divider()
                
                HStack {
                    KFImage(URL(string: "https://suckhoe123.vn\(like.photo!)"))
                        .resizable()
                        .scaledToFill()
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                        .padding()
                    
                    Text(like.fullname!.htmlToString())
                        .font(.system(size: 18))
                        .foregroundColor(Color.black)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                Spacer()
            }
            .padding(20)
            .padding(.top, 10)
            .background(Color.white)
        }
        .background(Color.white)
        .cornerRadius(40)
    }
}

//struct ListLikeView_Previews: PreviewProvider {
//    static var previews: some View {
//        ListLikeView()
//    }
//}
