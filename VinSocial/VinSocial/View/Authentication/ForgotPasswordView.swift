//
//  ForgotPasswordView.swift
//  Messenger
//
//  Created by Đinh Thái Sơn on 10/02/2023.
//

import SwiftUI

struct ForgotPasswordView: View {
    @ObservedObject var viewModel = AuthenViewModel()
    @Environment(\.dismiss) var dismiss
    @State private var email = ""
    @State var showInputOtp = false
    
//    func renderingMode(_ renderingMode: Image.TemplateRenderingMode?) -> Image
    
    var body: some View {
        //VStack {
//            NavigationView{
                VStack {
                    HStack(spacing: 12) {
                        Image("ic_back_arrow")
                            .resizable()
                            .frame(width: 10, height: 18)
                            .foregroundColor(.white)
                            .onTapGesture {
                                dismiss()
                            }
                        
                        Text(LocalizedStringKey("Label_Back"))
                            .foregroundColor(.white)
                            .font(.title3)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(.leading)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        
                        Text(LocalizedStringKey("Label_Forgot_Password"))
                            .font(.largeTitle)
                            .bold()
                            .foregroundColor(.white)
                            .padding(.leading)
                        
                        Text(LocalizedStringKey("Description_Forgot_Password"))
                            .font(.body)
                            .foregroundColor(.white)
                            .padding(.leading)
            
                        VStack {
                            CustomValidationEmptyField(imageName: "ic_validate", validateText: viewModel.messageChangePass, text: $viewModel.messageChangePass).padding([.top, .leading, .trailing], 15)
                            
                            CustomTextField(imageName: "ic_edittext_email",
                                            placeholderText: String(localized: "Placeholder_Email"),
                                            isSecureField: false,
                                            text: $email)
                            .padding()
                        }
                        .padding(.top, 15)
                    }
                    
                    Button(action: {
                        viewModel.forget(userField: email, step: 1, verifykey: "", new_password: "", re_password: "")
                    }, label: {
                        Text(LocalizedStringKey("Label_Continue"))
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(height: 50)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .background(!email.isEmpty ? Color(red: 255/255, green: 170/255, blue: 41/255) : Color(red: 217/255, green: 217/255, blue: 217/255))
                            .cornerRadius(10)
                            .padding()
                    })
                    .disabled(email.isEmpty)

                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .background(Color(red: 23/255, green: 136/255, blue: 192/255))
                .fullScreenCover(isPresented: $viewModel.checkForget, content: {
                    InputOtpView(viewModel: viewModel, email: $email)
                })
                .navigationBarBackButtonHidden(true)
                .disabled(viewModel.showLoadingForget)
                .environmentObject(viewModel)
                .blur(radius: viewModel.showLoadingForget ? 5 : 0)
                .navigationBarTitle("")
                .navigationBarHidden(true)
                .padding(.top, 50)
                .edgesIgnoringSafeArea(.top)
                //.frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(red: 23/255, green: 136/255, blue: 192/255))
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
                    }.shadow(radius: 5)
                )

//            }
            //.navigationViewStyle(.stack)
//            .environmentObject(viewModel)
//            .navigationBarBackButtonHidden(true)
//            .fullScreenCover(isPresented: $viewModel.checkForget, content: {
//                InputOtpView(viewModel: viewModel, email: $email)
//            })
//            .disabled(viewModel.showLoading)
//            .blur(radius: viewModel.showLoading ? 5 : 0)
//            .overlay(
//                ActivityIndicatorView(isDisplayed: $viewModel.showLoading, textLoading: String(localized: "Label_Loading_Login"), imageName: "ic_login_loading"){
//                Text("")
//            })
        //}
        
    }
}
//
//struct ForgotPasswordView_Previews: PreviewProvider {
//    static var previews: some View {
//        ForgotPasswordView()
//    }
//}
