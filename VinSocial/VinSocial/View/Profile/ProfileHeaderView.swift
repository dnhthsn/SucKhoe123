//
//  ProfileHeaderView.swift
//  Messenger
//
//  Created by Đinh Thái Sơn on 27/02/2023.
//

import SwiftUI
import Kingfisher

struct ProfileHeaderView: View {
    private let user: UserResponse?
    @ObservedObject var profileViewModel: ProfileViewModel
    let radius: CGFloat = 50
    let pi = Double.pi
    let dotCount = 80
    let dotLength: CGFloat = 3
    let spaceLength: CGFloat
    @State var showEditView : Bool = false
    @State var isShowBackPress : Bool = false
    @State var currentUserId: String
    @State var showBottomSheet: Bool = false
    @State var result: String = ""
    @State var showExpertPage: Bool = false
    @State var nameUser: String = ""

    init(user: UserResponse?,profileViewModel:ProfileViewModel,isShowBackPress:Bool,currentUserId:String) {
        self.user = user
        self.profileViewModel = profileViewModel
        self.isShowBackPress = isShowBackPress
        let circumerence: CGFloat = CGFloat(2.0 * pi) * radius
        spaceLength = circumerence / CGFloat(dotCount) - dotLength
        self.currentUserId = currentUserId
    }
    
    func getAvatarProfile()->String{
        if user != nil {
            return user?.photo ?? stringURL
        }
        
        if profileViewModel.userDetailInfo?.avatar != nil {
            if let avatar = profileViewModel.userDetailInfo?.avatar {
                if ((avatar.contains("https"))){
                    return avatar
                }else{
                    
                    return "https://suckhoe123.vn\(avatar)"
                }
            }
        }
        return user?.photo ?? stringURL
        
    }
    
    var body: some View {
        HStack {
            KFImage(URL(string: getAvatarProfile()))
                .resizable()
                .scaledToFill()
                .frame(width: 90, height: 90)
                .clipShape(Circle())
                .overlay(Circle().frame(width: 0,height: 0)
                        .padding(6)
                        .background(Color.green)
                        .clipShape(Circle())
                        .padding(4)
                        .background(Color.white)
                        .clipShape(Circle())
                        .offset(x: -5, y: 6)
                    
                    ,alignment: .bottomTrailing
                )
                //.padding(.top, isShowBackPress ? 0 : 32)
                .padding(5)
                
            
            VStack(alignment: .center, spacing: 0) {
                Text(nameUser)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(Color.black)
                    .font(.footnote.weight(.bold))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .frame(height: 40)
                    .multilineTextAlignment(.leading)
                    .truncationMode(.tail)
                
                if !(profileViewModel.userDetailInfo?.description ?? "").isEmpty {
                    Text(profileViewModel.userDetailInfo?.description ?? "")
                        .foregroundColor(Color(red: 64/255, green: 64/255, blue: 64/255))
                        .font(.system(size: 16))
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                        .frame(height: 50)
                        .multilineTextAlignment(.leading)
                        .truncationMode(.tail)
                }
                
                HStack(spacing: 5) {
                    if user?.userid == AuthenViewModel.shared.currentUser?.userid{
                        HStack{
                            Image("ic_edit")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 15,height: 15)
                                .foregroundColor(Color(red: 23/255, green: 136/255, blue: 192/255))
                                .padding([.top, .bottom], 5)
                                .padding(.leading, 10)
                            
                            Text("Chỉnh sửa")
                                .font(.system(size: 13))
                                .foregroundColor(Color(red: 23/255, green: 136/255, blue: 192/255))
                                .padding([.top, .bottom], 5)
                                .padding(.trailing, 10)
                                
                           
                        }
                        .onTapGesture {
                            showEditView.toggle()
                        }
                        .fullScreenCover(isPresented: $showEditView, content: {
                            EditInformationView(user: user,profileViewModel: profileViewModel)
                        })
                        .overlay(
                            RoundedRectangle(cornerRadius: 30)
                                .stroke(Color(red: 238/255, green: 249/255, blue: 255/255), lineWidth: 1)
                                
                        )
                        .background(RoundedRectangle(cornerRadius: 30).fill(Color(red: 238/255, green: 249/255, blue: 255/255)))
                    }
                    
                    if user?.isdoctor == 1 || profileViewModel.userDetailInfo?.isdoctor == 1 {
                        HStack{
                            Image("ic_refresh")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 15,height: 15)
                                .foregroundColor(Color(red: 23/255, green: 136/255, blue: 192/255))
                                .padding([.top, .bottom], 5)
                                .padding(.leading, 10)
                            
                            Text("Trang chuyên gia")
                                .font(.system(size: 13))
                                .foregroundColor(Color(red: 23/255, green: 136/255, blue: 192/255))
                                .padding([.top, .bottom], 5)
                                .padding(.trailing, 10)
                                
                           
                        }
                        .onTapGesture {
                            showBottomSheet.toggle()
                        }
                        .sheet(isPresented: $showBottomSheet, content: {
                            BottomSheetChangePage(profileViewModel: profileViewModel, result: $result, closeAndDisplayFullScreen: {
                                showBottomSheet = false
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    showExpertPage = true
                                }
                            }).presentationDetents([.height(250), .large])
                        })
                        .overlay(
                            RoundedRectangle(cornerRadius: 30)
                                .stroke(Color(red: 238/255, green: 249/255, blue: 255/255), lineWidth: 1)
                                
                        )
                        .background(RoundedRectangle(cornerRadius: 30).fill(Color(red: 238/255, green: 249/255, blue: 255/255)))
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                
            }
            .padding(.top, isShowBackPress ? 0 : 32)
        }
        .frame(maxWidth: .infinity, alignment: .top)
        .padding(5)
        .background(Color.white)
        .onAppear {
            DispatchQueue.main.async {
                self.nameUser = (self.profileViewModel.userDetailInfo?.fullname ?? "").htmlToString()
            }
        }
        .fullScreenCover(isPresented: $showExpertPage) {
            DoctorPageView(viewModel: profileViewModel, doctorid: profileViewModel.currentUserId, act: result)
        }
        .onChange(of: result) { output in
            profileViewModel.getExpert(category: result, doctorid: profileViewModel.currentUserId)
        }
        Spacer()
    }
}

