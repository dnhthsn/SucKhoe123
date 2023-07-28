//
//  ChangePasswordView.swift
//  Suckhoe123
//
//  Created by Đinh Thái Sơn on 26/06/2023.
//

import SwiftUI

struct ChangePasswordView: View {
    @ObservedObject var viewModel: AuthenViewModel
    @Environment(\.dismiss) var dismiss
    
    @State var currentPass: String = ""
    @State var newPass: String = ""
    @State var rePass: String = ""
    
    var body: some View {
        VStack {
            HStack(spacing: 12) {
                Image("ic_back_arrow")
                    .resizable()
                    .frame(width: 10, height: 18)
                    .foregroundColor(.black)
                    .onTapGesture {
                        dismiss()
                    }
                
                Text("Đổi mật khẩu")
                    .foregroundColor(.black)
                    .font(.title3)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding([.top, .leading, .trailing], 15)
            
            Divider()
            
            VStack {
                if !viewModel.messageChangePass.isEmpty {
                    CustomValidationEmptyField(imageName: "ic_validate", validateText: viewModel.messageChangePass, text: $currentPass)
                }
                
                Text("Mật khẩu hiện tại\(Text("*").foregroundColor(Color.red))")
                    .foregroundColor(Color.black)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                CustomPasswordField(imageName: "ic_edittext_password",
                                placeholderText: "Nhập mật khẩu hiện tại",
                                text: $currentPass)
                .foregroundColor(Color.black)
                
//                CustomValidationPasswordField(text: $newPass).frame(maxWidth: .infinity, alignment: .leading)
//                    .padding(.bottom, 10)
                
                
                Text("Mật khẩu mới\(Text("*").foregroundColor(Color.red))")
                    .foregroundColor(Color.black)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
//                CustomValidationEmptyField(imageName: "ic_validate", validateText: viewModel.messageChangePass, text: $viewModel.messageChangePass)
                
                
                CustomPasswordField(imageName: "ic_edittext_password",
                                placeholderText: "Nhập mật khẩu mới",
                                text: $newPass)
                .foregroundColor(Color.black)
                
                CustomValidationPasswordField(text: $newPass).frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 10)
                
                
                Text("Nhập lại mật khẩu mới\(Text("*").foregroundColor(Color.red))")
                    .foregroundColor(Color.black)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                CustomPasswordField(imageName: "ic_edittext_password",
                                placeholderText: "Nhập lại mật khẩu mới",
                                text: $rePass)
                .foregroundColor(Color.black)
                
                Spacer()
                
                Button(action:{
                    viewModel.changePassword(passwordold: currentPass, password: newPass, repassword: rePass)
                    
                    },label: {
                    Text("Hoàn tất")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.vertical,12)
                        .frame(maxWidth: .infinity)
                        .background {
                            RoundedRectangle(cornerRadius: 6, style: .continuous)
                                .fill(.blue)
                        }
                })
                .keyboardAdaptive()
                
            }
            .padding([.top, .leading, .trailing], 15)
            
            Spacer()
        }
        .disabled(viewModel.showLoadingChangePass)
        .blur(radius: viewModel.showLoadingChangePass ? 5 : 0)
        .navigationBarBackButtonHidden(true)
        .navigationBarTitle("")
        .navigationBarHidden(true)
        .padding(.top, 50)
        .edgesIgnoringSafeArea(.top)
        .gesture(
            DragGesture()
                .onEnded { gesture in
                    if gesture.translation.width > 100 {
                        dismiss()
                    }
                }
        )
        .overlay(
            ActivityIndicatorView(isDisplayed: $viewModel.showLoadingChangePass, textLoading: String(localized: "Label_Loading"), imageName: "ic_login_loading"){
                Text("")
            }
                .shadow(radius: 5)
        )
        .fullScreenCover(isPresented: $viewModel.finishChange, content: {
            SplashView(isActive: true, changePassSuccess: true)
        })
    }
}
