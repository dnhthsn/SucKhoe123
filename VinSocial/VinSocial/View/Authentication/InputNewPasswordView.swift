//
//  InputNewPasswordView.swift
//  VinChat
//
//  Created by Đinh Thái Sơn on 06/04/2023.
//

import SwiftUI

struct InputNewPasswordView: View {
    @ObservedObject var viewModel: AuthenViewModel
    @State var showLogin: Bool = false
    @State var newPass: String = ""
    @State var rePass: String = ""
    @Binding var email: String
    @Binding var otpText: String
    @Environment(\.dismiss) var dismiss
    
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
                
                Text(LocalizedStringKey("Label_Back"))
                    .foregroundColor(.black)
                    .font(.title3)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding([.top, .leading, .trailing], 15)
            
            Divider()
            
            VStack {
                Text(LocalizedStringKey("Label_New_Password"))
                    .foregroundColor(Color.black)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                CustomValidationEmptyField(imageName: "ic_validate", validateText: viewModel.messageChangePass, text: $viewModel.messageChangePass)
                
                
                CustomPasswordField(imageName: "ic_edittext_password",
                                placeholderText: String(localized: "Placeholder_Password"),
                                text: $newPass)
                .foregroundColor(Color.black)
                
                CustomValidationPasswordField(text: $newPass).frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 10)
                
                
                Text(LocalizedStringKey("Label_Retype_Password"))
                    .foregroundColor(Color.black)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                CustomPasswordField(imageName: "ic_edittext_password",
                                placeholderText: String(localized: "Placeholder_Password"),
                                text: $rePass)
                .foregroundColor(Color.black)
                
                Spacer()
                
                Button(action:{
                    viewModel.forget(userField: email, step: 3, verifykey: otpText, new_password: newPass, re_password: rePass)
                    
                    },label: {
                    Text(LocalizedStringKey("Label_Finish"))
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
        .disabled(viewModel.showLoadingForget)
        .blur(radius: viewModel.showLoadingForget ? 5 : 0)
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
            ActivityIndicatorView(isDisplayed: $viewModel.showLoadingForget, textLoading: String(localized: "Label_Loading"), imageName: "ic_login_loading"){
                Text("")
            }
                .shadow(radius: 5)
        )
        .fullScreenCover(isPresented: $viewModel.finishChange, content: {
//            LoginView(viewModel: viewModel)
            SplashView(isActive: true)
        })
        .environmentObject(viewModel)
    }
}

//struct InputNewPasswordView_Previews: PreviewProvider {
//    static var previews: some View {
//        InputNewPasswordView()
//    }
//}
