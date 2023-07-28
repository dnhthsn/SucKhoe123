//
//  LoginTypeView.swift
//  Suckhoe123
//
//  Created by Đinh Thái Sơn on 17/07/2023.
//

import SwiftUI
import AuthenticationServices

struct LoginTypeView: View {
    let appleSignInHandler: AppleSignInHandler
    @State private var email = ""
    @State private var password = ""
    @State private var isUnlocked = false
    @ObservedObject var viewModel: AuthenViewModel
    @ObservedObject var homeViewModel = HomeViewModel()
    @State var loadingToggle = false
    @State var checkField = false
    @State private var showToast = false
    @State private var showForgetPassword = false
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode
    var onLoginCallBackForHome:() ->Void

    @State var showLoginView: Bool = false
    @State var checkFacebook: Bool = true
    
    init(viewModel: AuthenViewModel, homeViewModel: HomeViewModel, onLoginCallBackForHome: @escaping () -> Void) {
        self.viewModel = viewModel
        self.homeViewModel = homeViewModel
        self.onLoginCallBackForHome = onLoginCallBackForHome
        self.appleSignInHandler = AppleSignInHandler(viewModel: viewModel, homeViewModel: homeViewModel, onLoginCallBackForHome: onLoginCallBackForHome)
    }
    
    var body: some View {
        NavigationView {
            VStack {
                VStack(alignment: .leading, spacing: 12) {
                    
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
                    
                    VStack(alignment: .center) {
                        Image("logo3")
                            .resizable()
                            .scaledToFit()
                            .frame(width: UIScreen.main.bounds.width-100, height: 100, alignment: .center)
                            .padding([.leading, .trailing], 20)
                            .padding(.bottom, 30)
                        
                        Text(LocalizedStringKey("Description_Login"))
                            .font(.custom("r-normal", size: 16))
                            .foregroundColor(.white)
                            .padding([.leading, .trailing], 20)
                            .frame(width: UIScreen.main.bounds.width-100)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.bottom, 40)
                    .padding(.top, 90)
        
                    Spacer()
                    
                    VStack {
                        ScrollView(showsIndicators: false) {
                            VStack {
                                Text("Chọn phương thức đăng nhập")
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .font(.system(size: 18, weight: .bold))
                                    .padding()
                                
                                HStack(alignment: .center, spacing: 25) {
                                    Button(action: {
                                        let request = ASAuthorizationAppleIDProvider().createRequest()
                                        request.requestedScopes = [.fullName, .email]

                                        let controller = ASAuthorizationController(authorizationRequests: [request, ASAuthorizationPasswordProvider().createRequest()])

                                        controller.delegate = appleSignInHandler
                                        controller.presentationContextProvider = appleSignInHandler
                                        controller.performRequests()
                                    }, label: {
                                        Image("ic_apple")
                                            .resizable()
                                            .frame(width: 50, height: 50)
                                    })
                                    
//                                    SignInWithAppleButton(.signIn) { request in
//                                        request.requestedScopes = [.fullName, .email]
//                                    } onCompletion: { result in
//                                        homeViewModel.removeCache()
//                                        viewModel.loginWithAppleId(result: result){ check in
//                                            if viewModel.currentUser != nil {
//                                               homeViewModel.removeCache()
//                                                onLoginCallBackForHome()
//                                               presentationMode.wrappedValue.dismiss()
//                                            }
//                                        }
//                                    }
//                                    .signInWithAppleButtonStyle(.black)
//                                    .font(.system(size: 15))
//                                    .frame(height: 50)
//                                    .frame(maxWidth: .infinity, alignment: .center)
//                                    .padding()
                                    
//                                    Button(action: {
//                                        homeViewModel.removeCache()
//                                        viewModel.loginGoolge(){ check in
//                                            if viewModel.currentUser != nil {
//                                               homeViewModel.removeCache()
//                                                onLoginCallBackForHome()
//
//                                               presentationMode.wrappedValue.dismiss()
//                                            }
//                                        }
//                                    }){
//                                        HStack{
//                                            Image("logo_google1")
//                                                .resizable()
//                                                .scaledToFit()
//                                                .frame(width: 28, height: 28)
//
//                                            Text(LocalizedStringKey("Label_Login_Google"))
//                                                .font(.system(size: 15))
//                                                .foregroundColor(.black)
//
//
//                                        }
//                                        .frame(height: 50)
//                                    }
//                                    .frame(maxWidth: .infinity, alignment: .center)
//                                    .overlay(
//                                        RoundedRectangle(cornerRadius: 6)
//                                            .stroke(Color(red: 158/255, green: 158/255, blue: 158/255), lineWidth: 1)
//
//                                    )
//                                    .background(RoundedRectangle(cornerRadius: 6).fill(.white))
//                                    .padding([.leading, .trailing], 15)
//
//
//                                    if checkFacebook {
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
//                                                Image("logo_facebook1")
//                                                    .resizable()
//                                                    .scaledToFit()
//                                                    .frame(width: 28, height: 28)
//
//                                                Text(LocalizedStringKey("Label_Login_Facebook"))
//                                                    .font(.system(size: 15))
//                                                    .foregroundColor(.black)
//
//
//                                            }
//                                            .frame(height: 50)
//                                        }
//                                        .frame(maxWidth: .infinity, alignment: .center)
//                                        .overlay(
//                                            RoundedRectangle(cornerRadius: 6)
//                                                .stroke(Color(red: 158/255, green: 158/255, blue: 158/255), lineWidth: 1)
//
//                                        )
//                                        .background(RoundedRectangle(cornerRadius: 6).fill(.white))
//                                        .padding([.leading, .trailing], 15)
//                                        .padding(.top)
//                                    }
                                    
                                    
                                    Button(action: {
                                        homeViewModel.removeCache()
                                        viewModel.loginGoolge(){ check in
                                            if viewModel.currentUser != nil {
                                               homeViewModel.removeCache()
                                                onLoginCallBackForHome()

                                               presentationMode.wrappedValue.dismiss()
                                            }
                                        }
                                    }){
                                        Image("logo_google")
                                            .resizable()
                                            .frame(width: 50, height: 50)
                                    }

                                    if checkFacebook {
                                        Button(action: {
                                            homeViewModel.removeCache()
                                            viewModel.loginFacebook(){ check in
                                                if viewModel.currentUser != nil {
                                                   homeViewModel.removeCache()
                                                    onLoginCallBackForHome()

                                                   presentationMode.wrappedValue.dismiss()
                                                }
                                            }
                                        }){
                                            Image("logo_facebook")
                                                .resizable()
                                                .frame(width: 50, height: 50)
                                        }
                                    }
                                }
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding()
                                
//                                Button(action: {
//                                    showLoginView.toggle()
//                                }, label: {
//                                    Text("Đăng nhập bằng tài khoản")
//                                        .underline(color: Color.black)
//                                        .font(.headline)
//                                        .foregroundColor(.black)
//                                        .frame(height: 50)
//                                        .frame(maxWidth: .infinity, alignment: .center)
//                                        .padding()
//                                })
////                                .shadow(radius: 5)
//                                .fullScreenCover(isPresented: $showLoginView, content: {
//                                    LoginView(onLoginCallBackForHome: {
//                                        homeViewModel.loadData()
//                                        presentationMode.wrappedValue.dismiss()
//                                    })
//                                    .environmentObject(viewModel)
//                                })
                                
                                NavigationLink(destination: {
                                    LoginView(onLoginCallBackForHome: {
                                        homeViewModel.loadData()
                                        presentationMode.wrappedValue.dismiss()
                                    })
                                    .environmentObject(viewModel)
                                    .navigationBarBackButtonHidden(true)
                                }, label: {
                                    Text("Đăng nhập bằng tài khoản")
                                        .underline(color: Color.black)
                                        .font(.headline)
                                        .foregroundColor(.black)
                                        .frame(height: 50)
                                        .frame(maxWidth: .infinity, alignment: .center)
                                        .padding()
                                })
                                
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
                                .padding(.top, 20)
                                .padding(.bottom, 10)
                            }
                            
                        }
                    }
                    .padding(10)
                    .background(Color.white)
                    .cornerRadius(30)
                    .ignoresSafeArea()
                    .frame(height: 300)
                    
                    
                }
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .alert(isPresented: $viewModel.shouldShowAlert, content: {
                Alert(title: Text(viewModel.alertTitle), message: Text(viewModel.alertMessage), dismissButton: .default(Text("OK")))
            })
            .background(Color(red: 23/255, green: 136/255, blue: 192/255))
            .blur(radius: viewModel.showLoading ? 5 : 0)
            .overlay(
                overlayView: ToastView(toast: Toast(title: viewModel.messageLogin, image: ""), show: $showToast), show: $showToast
            )
            .overlay(ActivityIndicatorView(isDisplayed: $viewModel.showLoading, textLoading: String(localized: "Label_Loading_Login"), imageName: "ic_login_loading"){
                Text("")
            }
            .shadow(radius: 10))
            .environmentObject(viewModel)
            .disabled(viewModel.showLoading)
            .gesture(
                DragGesture()
                    .onEnded { gesture in
                        if gesture.translation.width > 100 {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
            )
//            .onAppear{
//                viewModel.showNewPass = false
//                viewModel.checkForget = false
//                viewModel.finishChange = false
//            }
            
        }
        .accentColor(.white)
        //.navigationViewStyle(.stack)
    }
}

class AppleSignInHandler: NSObject, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    @ObservedObject var viewModel: AuthenViewModel
    @ObservedObject var homeViewModel: HomeViewModel
    var onLoginCallBackForHome:() -> Void
    
    init(viewModel: AuthenViewModel, homeViewModel: HomeViewModel, onLoginCallBackForHome:@escaping () -> Void) {
        self.viewModel = viewModel
        self.homeViewModel = homeViewModel
        self.onLoginCallBackForHome = onLoginCallBackForHome
    }
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return UIApplication.shared.connectedScenes
                     .first { $0.activationState == .foregroundActive }
                     .map { $0 as? UIWindowScene }
                     .flatMap { $0?.windows.first } ?? UIApplication.shared.windows.first!
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Error Login Apple Id: \(error.localizedDescription)")
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        // Your code to handle the authorization
//        switch authorization.credential {
//        case let appleIdCredential as ASAuthorizationAppleIDCredential:
//            let userId = appleIdCredential.user
//            let email = appleIdCredential.email
//            let firstName = appleIdCredential.fullName?.givenName
//            let lastName = appleIdCredential.fullName?.familyName
//
//            viewModel.loginSocial(server: "apple", id: userId, email: email ?? "", phone: "", first_name: firstName ?? "", gender: "", avatar_url: "", completion: { [self] state in
//                if self.viewModel.currentUser != nil {
//                   homeViewModel.removeCache()
//                    onLoginCallBackForHome()
//
//                   //presentationMode.wrappedValue.dismiss()
//                }
//            })
//        case let passwordCredential as ASPasswordCredential:
//            let username = passwordCredential.user
//            let password = passwordCredential.password
//            print("username: \(username)")
//            print("password: \(password)")
//        default:
//            break
//        }
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            let userId = appleIDCredential.user
            let email = appleIDCredential.email
            let firstName = appleIDCredential.fullName?.givenName
            let lastName = appleIDCredential.fullName?.familyName

            viewModel.loginSocial(server: "apple", id: userId, email: email ?? "", phone: "", first_name: firstName ?? "", gender: "", avatar_url: "", completion: { [self] state in
                if self.viewModel.currentUser != nil {
                   homeViewModel.removeCache()
                    onLoginCallBackForHome()

                   //presentationMode.wrappedValue.dismiss()
                }
            })
        }
    }
}

