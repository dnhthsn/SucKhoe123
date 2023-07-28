//
//  TopDoctorCell.swift
//  Suckhoe123
//
//  Created by Đinh Thái Sơn on 23/05/2023.
//

import SwiftUI
import Kingfisher

struct TopDoctorCell: View {
    @ObservedObject var viewModel: BeautyViewModel
    var topDoctor: TopDoctor
    @State var showProfile: Bool = false
    
    var body: some View {
        VStack {
            KFImage(URL(string: "https://suckhoe123.vn\(topDoctor.avatar!)"))
                .resizable()
                .scaledToFill()
                .frame(width: 75, height: 75)
                .clipShape(Circle())
                .padding(5)
            
            Text(topDoctor.fullname ?? "")
                .foregroundColor(Color.black)
                .font(.system(size: 15, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .center)
                .frame(height: 20)
                .multilineTextAlignment(.center)
                .truncationMode(.tail)
            
            Text(topDoctor.clinic_name ?? "")
                .foregroundColor(Color.gray)
                .font(.system(size: 15))
                .frame(maxWidth: .infinity, alignment: .center)
                .frame(height: 20)
                .multilineTextAlignment(.center)
                .truncationMode(.tail)
            
            Button(action: {
                //open other app here
                let application = UIApplication.shared;
                let appURLScheme = "VinChat" // Replace with the URL scheme of the target app
               
                if topDoctor.firebaseuid == nil{
                    return
                }
                let json = topDoctor.toJSON()
                let dataToTransfer = json// Data you want to transfer
                var urlComponents = URLComponents()
                urlComponents.scheme = appURLScheme
                urlComponents.queryItems = [URLQueryItem(name: "user_id", value: topDoctor.userid ?? ""), URLQueryItem(name: "firebaseuid", value: topDoctor.firebaseuid ?? "")]
                if let url = urlComponents.url, UIApplication.shared.canOpenURL(url) {
                    let test = print(" hoi nx \(url)")
                           UIApplication.shared.open(url) { success in
                               if !success {
                                   // Failed to open the other app
                                   print("Failed to open other app.")
                               }
                           }
                       }
                
            }, label: {
                
                Text(LocalizedStringKey("Label_Send_Message"))
                    .font(.system(size: 15))
                    .foregroundColor(.white)
                    
            })
            .frame(width: 80, height: 31.0)
            .background(Color(red: 23/255, green: 136/255, blue: 192/255))
            .cornerRadius(5)
        }
        .padding(10)
        .overlay(
            RoundedRectangle(cornerRadius: 6)
                .stroke(Color(red: 0.957, green: 0.957, blue: 0.957), lineWidth: 2)
                
        )
        .background(RoundedRectangle(cornerRadius: 6).fill(.white).shadow(radius: 2))
        .onTapGesture {
            self.showProfile.toggle()
        }
        .fullScreenCover(isPresented: $showProfile, content: {
            ProfileView(user: nil, isShowBackPress: true,profileViewModel: ProfileViewModel(currentUserId: topDoctor.userid ?? "", userDetailInfo: viewModel.initUserInfo(topDoctor: topDoctor),"Top Doctor view"))
        })
    }
}
