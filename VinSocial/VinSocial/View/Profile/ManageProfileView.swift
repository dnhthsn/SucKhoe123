//
//  ManageProfileView.swift
//  Suckhoe123
//
//  Created by Đinh Thái Sơn on 18/05/2023.
//

import SwiftUI
import Kingfisher

struct ManageProfileView: View {
    @EnvironmentObject var viewModel: AuthenViewModel
    @EnvironmentObject var homeViewModel: HomeViewModel
    let user: UserResponse?
    @StateObject private var profileViewModel: ProfileViewModel
    @StateObject private var groupViewModel: GroupViewModel
    @State var isShowProfileView:Bool = false
    @State var isShowManageGroupView: Bool = false
    @State var isShowForgotPasswordView: Bool = false
    @State var isLogOut: Bool = false
    @State var nameUser: String = ""
    
    init(user: UserResponse?){
        self.user = user
        _profileViewModel  = StateObject(wrappedValue: ProfileViewModel(currentUserId: AuthenViewModel.shared.currentUser?.userid ?? "",userDetailInfo: AuthenViewModel.shared.userDetailInfo,"from ManageProfileView MaintabView"))
        _groupViewModel = StateObject(wrappedValue: GroupViewModel())
    }
    
    func getAvatarProfile()->String{
        if profileViewModel.userDetailInfo?.avatar != nil {
            if let avatar = profileViewModel.userDetailInfo?.avatar {
                if ((avatar.contains("https"))){
                    return avatar
                }else{
                    if user != nil {
                        return user?.photo ?? stringURL
                    }
                }
            }
        }
        return user?.photo ?? stringURL
    }
    
    var body: some View {
        
        
        VStack(spacing: 0) {
            if viewModel.currentUser == nil {
                ViewWithouLogin(actionBack: false).environmentObject(viewModel).environmentObject(homeViewModel)
                    .tag(tabItems[3])
                    .ignoresSafeArea(.all, edges: .all)
                    
            } else {
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        Button(action: {
                            isShowProfileView.toggle()
                        }, label: {
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
                                    .padding()
                                    
                                
                                VStack(alignment: .center, spacing: 4) {
                                    Text(LocalizedStringKey("Label_Name_Display"))
                                        .foregroundColor(Color.gray)
                                        .font(.subheadline)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    
                                    Text(profileViewModel.userDetailInfo?.fullname ?? "")
                                        .font(.title2)
                                        .foregroundColor(Color.black)
                                        .font(.footnote.weight(.bold))
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .frame(height: 40)
                                        .multilineTextAlignment(.leading)
                                        .truncationMode(.tail)
                                }
                            }
                            .padding(.top, 32)
                        })
                        .background(Color.white)
                        .fullScreenCover(isPresented: $isShowProfileView, content: {
                            ProfileView(user: viewModel.currentUser, isShowBackPress: true, profileViewModel: profileViewModel)
                        })
                        .ignoresSafeArea(.all, edges: .top)
                        
                        Rectangle().fill(Color(red: 0.957, green: 0.957, blue: 0.957)).frame(height: 3)
                        
    //                        Divider()
                        
                        VStack {
                            if profileViewModel.userDetailInfo?.isdoctor == 1{
                                HStack {
                                    Image("ic_client")
                                        .frame(width: 20, height: 20)
                                    
                                    Text("Khách hàng của bạn")
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .foregroundColor(Color.black)
                                        .font(.system(size: 18))
                                    
                                    Image("ic_arrow_next")
                                        .frame(width: 15, height: 15)
                                        .foregroundColor(Color.black)
                                }
                                .background(Color.white)
                                .padding(20)
                                .padding(.top, 10)
                                
                                Rectangle().fill(Color(red: 0.957, green: 0.957, blue: 0.957)).frame(height: 2)
                            }
                                
                            
                            HStack {
                                Image("ic_checklist")
                                    .frame(width: 20, height: 20)
                                
                                Text("Check khách hàng")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .foregroundColor(Color.black)
                                    .font(.system(size: 18))
                                
                                Image("ic_arrow_next")
                                    .frame(width: 15, height: 15)
                                    .foregroundColor(Color.black)
                            }
                            .background(Color.white)
                            .padding(20)
                            .padding(.top, 10)
                            
                            Rectangle().fill(Color(red: 0.957, green: 0.957, blue: 0.957)).frame(height: 1)
                            
                            HStack {
                                Image("ic_dumbell")
                                    .frame(width: 20, height: 20)
                                
                                Text("Cẩm nang sức khoẻ")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .foregroundColor(Color.black)
                                    .font(.system(size: 18))
                                
                                Image("ic_arrow_next")
                                    .frame(width: 15, height: 15)
                                    .foregroundColor(Color.black)
                            }
                            .background(Color.white)
                            .padding(20)
                            
                            Rectangle().fill(Color(red: 0.957, green: 0.957, blue: 0.957)).frame(height: 1)
                            
                            HStack {
                                Image("ic_dollar")
                                    .frame(width: 20, height: 20)
                                
                                Text("Hoa hồng")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .foregroundColor(Color.black)
                                    .font(.system(size: 18))
                                
                                Image("ic_arrow_next")
                                    .frame(width: 15, height: 15)
                                    .foregroundColor(Color.black)
                            }
                            .background(Color.white)
                            .padding(20)
                            .padding(.bottom, 10)
                        }
                        .background(Color.white)
                        
                        Rectangle().fill(Color(red: 0.957, green: 0.957, blue: 0.957)).frame(height: 3)
                        
    //                        Divider()
                        
                        VStack {
                            Button(action: {
                                isShowManageGroupView.toggle()
                            }, label: {
                                HStack {
                                    Image("ic_manage_group")
                                        .frame(width: 20, height: 20)
                                    
                                    Text("Quản lý nhóm")
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .foregroundColor(Color.black)
                                        .font(.system(size: 18))
                                    
                                    Image("ic_arrow_next")
                                        .frame(width: 15, height: 15)
                                        .foregroundColor(Color.black)
                                }
                                .background(Color.white)
                                .padding(20)
                                .padding(.top, 10)
                            })
                            .fullScreenCover(isPresented: $isShowManageGroupView, content: {
                                ManageGroupView(viewModel: groupViewModel)
                            })
                            
                            Rectangle().fill(Color(red: 0.957, green: 0.957, blue: 0.957)).frame(height: 1)
                            
                            Button(action: {
                                isShowForgotPasswordView.toggle()
                            }, label: {
                                HStack {
                                    Image("ic_change_password")
                                        .frame(width: 20, height: 20)
                                    
                                    Text("Đổi mật khẩu")
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .foregroundColor(Color.black)
                                        .font(.system(size: 18))
                                    
                                    Image("ic_arrow_next")
                                        .frame(width: 15, height: 15)
                                        .foregroundColor(Color.black)
                                }
                                .background(Color.white)
                                .padding(20)
                            })
                            .fullScreenCover(isPresented: $isShowForgotPasswordView, content: {
                                ChangePasswordView(viewModel: viewModel)
                            })
                            
                            Rectangle().fill(Color(red: 0.957, green: 0.957, blue: 0.957)).frame(height: 1)
                            
                            HStack {
                                Image("ic_log_out")
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(Color.red)
                                
                                Text("Đăng xuất")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .foregroundColor(Color.red)
                                    .font(.system(size: 18))
                                
                            }
                            .background(Color.white)
                            .padding(20)
                            .padding(.bottom, 10)
                            .onTapGesture {
                                homeViewModel.removeCache()
                                viewModel.signout()
                                isLogOut = true
                            }
                            
                        }
                        .background(Color.white)
                        
                        Spacer()
                    }
                    .background(Color(red: 0.957, green: 0.957, blue: 0.957))
                }
                .background(Color(red: 0.957, green: 0.957, blue: 0.957))
                
            }
        }
        .background(Color(red: 0.957, green: 0.957, blue: 0.957))
        .fullScreenCover(isPresented: $isShowProfileView, content: {
            ProfileView(user: viewModel.currentUser, profileViewModel: profileViewModel)
           
        })
        .fullScreenCover(isPresented: $isLogOut, content: {
            MainTabView()
        })
        .onAppear {
            DispatchQueue.main.async {
                self.nameUser = (profileViewModel.userDetailInfo?.fullname ?? "").htmlToString()
            }
        }
    }
}
