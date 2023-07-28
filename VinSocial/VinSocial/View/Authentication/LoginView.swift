//
//  LoginView.swift
//  Messenger
//
//  Created by Stealer Of Souls on 2/7/23.
//

import SwiftUI
import AuthenticationServices

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var isUnlocked = false
    @EnvironmentObject var viewModel: AuthenViewModel
    @EnvironmentObject var homeViewModel: HomeViewModel
    @State var loadingToggle = false
    @State var checkField = false
    @State private var showToast = false
    @State private var showForgetPassword = false
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode

    @AppStorage("email") var emailApple: String = ""
    @AppStorage("firstName") var firstNameApple: String = ""
    @AppStorage("lastName") var lastNameApple: String = ""
    @AppStorage("userId") var userIdApple: String = ""
    
    @State var messageRegister: String = ""
    @State var showPolicyView: Bool = false
    @State private var isSelected: Bool = true
    @State var errorCheckBox: String = ""
    
    var onLoginCallBackForHome:() ->Void
    
    var body: some View {
        NavigationView {
            VStack {
                VStack {
                    HStack {
                        Button {
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            Image("ic_back_arrow")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 26, height: 26)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding([.leading, .trailing], 15)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Spacer()
                        Image("logo2")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 300, height: 50, alignment: .leading)
                            .padding([.leading, .trailing], 20)
                        
                        Text(LocalizedStringKey("Label_Login"))
                            .font(.custom("r-normal", size: 32))
                            .bold()
                            .foregroundColor(.white)
                            .padding([.leading, .trailing], 20)
                        
                        Text(LocalizedStringKey("Description_Login"))
                            .font(.custom("r-normal", size: 16))
                            .foregroundColor(.white)
                            .padding([.leading, .trailing], 20)
                        
                        Spacer()
            
                        VStack {
                            ScrollView(showsIndicators: false) {
                                VStack {
                                    CustomValidationEmptyField(imageName: "ic_validate", validateText: errorCheckBox, text: $errorCheckBox).padding([.top, .leading, .trailing], 15)
                                    
                                    CustomValidationEmptyField(imageName: "ic_validate", validateText: viewModel.messageLogin, text: $viewModel.messageLogin).padding([.top, .leading, .trailing], 15)
                                    
                                    CustomValidationEmptyField(imageName: "ic_validate", validateText: messageRegister, text: $messageRegister).padding([.top, .leading, .trailing], 15)
                                    
    //                                CustomValidationEmptyField(check: checkField, imageName: "ic_validate", validateText: String(localized: "Validate_Empty_Password"), text: $password).padding([.top, .leading, .trailing], 15)
                                    
                                    CustomTextField(
                                        imageName: "ic_edittext_email", placeholderText: String(localized: "Placeholder_Email"),
                                                    isSecureField: false,
                                        text: $email)
                                    .foregroundColor(Color.black)
                                    .padding([.top, .leading, .trailing], 15)
                                    
                                    CustomPasswordField(imageName: "ic_edittext_password",
                                                    placeholderText: String(localized: "Placeholder_Password"),
                                                    text: $password)
                                    .foregroundColor(Color.black)
                                    .padding([.top, .leading, .trailing], 15)
                                    
                                    HStack {
                                        Spacer()

                                        NavigationLink(
                                            destination: ForgotPasswordView(),
                                            label: {
                                                Text(LocalizedStringKey("Label_Forgot_Password"))
                                                    .underline()
                                                    .padding(.top)
                                                    .font(.system(size: 15))
                                                    .padding(.trailing, 28)
                                                    .foregroundColor(.blue)
                                            })
                                        .navigationTitle(LocalizedStringKey("Label_Back"))
                                        .navigationBarHidden(true)

                                    }
                                    
                                    HStack(spacing: 10) {
                                        
                                        Group {
                                            Toggle("", isOn: $isSelected)
                                                .labelsHidden()
                                                .toggleStyle(CheckBoxView())
                                                .font(.title)
                                        }.padding(.bottom)
                                        
                                        
                                        VStack {
                                            Text("Tôi đã đọc, hiểu rõ và đồng ý với ")
                                                .font(.subheadline)
                                                .foregroundColor(.black)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                            
                                            HStack {
                                                Button(action: {
                                                    showPolicyView.toggle()
                                                }, label: {
                                                    Text("điều kiện, điều khoản").underline(color: Color(red: 23/255, green: 136/255, blue: 192/255)).foregroundColor(Color(red: 23/255, green: 136/255, blue: 192/255))
                                                        .font(.subheadline)
                                                })
                                                .fullScreenCover(isPresented: $showPolicyView, content: {
                                                    PolicyView()
                                                })
                                                Text("của 123Chat")
                                                    .font(.subheadline)
                                                    .foregroundColor(.black)
                                            }
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            
                                        }
                                        .padding(.bottom, 10)
                                        
                                        
                                    }.padding([.leading, .trailing, .top])

                                    Button(action: {
                                        //loadingToggle.toggle()
                                        checkField = true
                                        
                                        if (!viewModel.messageLogin.isEmpty || !viewModel.messageRegister.isEmpty) {
                                            showToast = true
                                        }
                                        
                                        viewModel.login(withEmail: email, password: password) { check in
                                            if viewModel.currentUser != nil {
                                                homeViewModel.removeCache()
                                                onLoginCallBackForHome()
                                                //presentationMode.wrappedValue.dismiss()
                                            }
                                        }
                                        
                                    }, label: {
                                        Text(LocalizedStringKey("Label_Login"))
                                            .font(.headline)
                                            .foregroundColor(.white)
                                            .frame(height: 50)
                                            .frame(maxWidth: .infinity, alignment: .center)
                                            .background(Color(red: 23/255, green: 136/255, blue: 192/255))
                                            .cornerRadius(10)
                                            .padding()
                                    })
                                    //.padding([.leading, .trailing], 15)
                                    .shadow(radius: 5)
                                    .disabled(!isSelected)
                                    
//                                    HStack {
//                                        VStack {
//                                            Divider()
//                                        }
//
//                                        Text(LocalizedStringKey("Label_Or"))
//                                            .font(.system(size: 14))
//                                            .foregroundColor(.gray)
//
//                                        VStack {
//                                            Divider()
//                                        }
//                                    }
//                                    .padding([.leading, .trailing], 15)
                                    
                                        
                                    
//                                    VStack {
//                                        Button(action: {
//                                            homeViewModel.removeCache()
//                                            viewModel.loginGoolge(){ check in
//                                                if viewModel.currentUser != nil {
//                                                   homeViewModel.removeCache()
//                                                    onLoginCallBackForHome()
//
//                                                   presentationMode.wrappedValue.dismiss()
//                                                }
//                                            }
//                                        }){
//                                            HStack{
//                                                Image("logo_google")
//                                                    .resizable()
//                                                    .scaledToFit()
//                                                    .frame(width: 32, height: 32)
//
//                                                Text(LocalizedStringKey("Label_Login_Google"))
//                                                    .font(.system(size: 15))
//                                                    .foregroundColor(.black)
//
//
//                                            }
//                                            .frame(height: 50)
//                                        }
//                                        .frame(width: UIScreen.main.bounds.width - 30)
//                                        .overlay(
//                                            RoundedRectangle(cornerRadius: 6)
//                                                .stroke(Color(red: 158/255, green: 158/255, blue: 158/255), lineWidth: 1)
//
//                                        )
//                                        .background(RoundedRectangle(cornerRadius: 6).fill(.white))
//                                        .padding([.leading, .trailing], 15)
//                                        .padding(.top)
//
//                                        Button(action: {
//                                            homeViewModel.removeCache()
//                                            viewModel.loginFacebook(){ check in
//                                                if viewModel.currentUser != nil {
//                                                   homeViewModel.removeCache()
//                                                    onLoginCallBackForHome()
//
//                                                   presentationMode.wrappedValue.dismiss()
//                                                }
//                                            }
//                                        }){
//                                            HStack{
//
//                                                Image("logo_facebook")
//                                                    .resizable()
//                                                    .scaledToFit()
//                                                    .frame(width: 32, height: 32)
//
//                                                Text(LocalizedStringKey("Label_Login_Facebook"))
//                                                    .font(.system(size: 15))
//                                                    .foregroundColor(.black)
//
//
//                                            }
//                                            .frame(height: 50)
//                                        }
//                                        .frame(width: UIScreen.main.bounds.width - 30)
//                                        .overlay(
//                                            RoundedRectangle(cornerRadius: 6)
//                                                .stroke(Color(red: 158/255, green: 158/255, blue: 158/255), lineWidth: 1)
//
//                                        )
//                                        .background(RoundedRectangle(cornerRadius: 6).fill(.white))
//                                        .padding([.leading, .trailing], 15)
//                                        .padding(.top)
//
//
//    //                                    HStack(spacing: 10) {
//    //
//    //
//    //
//    //
//    //                                    }
//    //                                    .padding([.leading, .trailing], 15)
//    //                                    .padding(.top)
//
//                                        VStack {
//                                            SignInWithAppleButton(.signIn) { request in
//                                                request.requestedScopes = [.fullName, .email]
//                                            } onCompletion: { result in
//                                                homeViewModel.removeCache()
//                                                viewModel.loginWithAppleId(result: result){ check in
//                                                    if viewModel.currentUser != nil {
//                                                       homeViewModel.removeCache()
//                                                        onLoginCallBackForHome()
//                                                       presentationMode.wrappedValue.dismiss()
//                                                    }
//                                                }
//                                            }
//                                            .signInWithAppleButtonStyle(.black)
//                                            .font(.system(size: 15))
//                                            .frame(height: 50)
//                                            .padding()
//
//                                        }
//                                    }
                                    
                                    Spacer()
                                    
                                    HStack {
                                        Text(LocalizedStringKey("Label_No_Account"))
                                            .font(.system(size: 14))
                                            .foregroundColor(.black)
                                            .bold()
                                        
                                        NavigationLink(
                                            destination: RegistrationView(),
                                            label: {

                                                    Text(LocalizedStringKey("Label_Register_Now"))
                                                        .font(.system(size: 14, weight: .semibold))
                                                        .foregroundColor(Color(red: 255/255, green: 130/255, blue: 30/255))
                                                        .bold()
                                                    
                                            }).navigationTitle(LocalizedStringKey("Label_Back"))
                                            .navigationBarHidden(true)
                                    }
                                    .padding(.top, 115)
                                    .padding(.bottom, 10)
                                }
                                
                            }
                            Spacer()
                        }
                        .padding(10)
                        .background(Color.white)
                        .cornerRadius(30)
                        .ignoresSafeArea()
                        
                        
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .alert(isPresented: $viewModel.shouldShowAlert, content: {
                Alert(title: Text(viewModel.alertTitle), message: Text(viewModel.alertMessage), dismissButton: .default(Text("OK")))
            })
            .background(Color(red: 23/255, green: 136/255, blue: 192/255))
            .blur(radius: viewModel.showLoading ? 5 : 0)
//            .overlay(
//                overlayView: ToastView(toast: Toast(title: viewModel.messageLogin.isEmpty ? viewModel.messageRegister : viewModel.messageLogin , image: ""), show: $showToast), show: $showToast
//            )
            .overlay(ActivityIndicatorView(isDisplayed: $viewModel.showLoading, textLoading: String(localized: "Label_Loading_Login"), imageName: "ic_login_loading"){
                Text("")
            }
            .shadow(radius: 10))
            .environmentObject(viewModel)
            .disabled(viewModel.showLoading)
            .onAppear{
                DispatchQueue.main.async {
                    messageRegister = (viewModel.messageRegister).htmlToString()
                }
             
            }
            .gesture(
                DragGesture()
                    .onEnded { gesture in
                        if gesture.translation.width > 100 {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
            )
            .onChange(of: isSelected) { output in
                if output == false {
                    errorCheckBox = "Bạn chưa đồng ý với điều kiện điều khoản"
                } else {
                    errorCheckBox = ""
                }
            }
        }
        .accentColor(.white)
        //.navigationViewStyle(.stack)
    }
}

//struct LoginView_Previews: PreviewProvider {
//    static var previews: some View {
//        LoginView().environmentObject(AuthenViewModel())
//    }
//}
