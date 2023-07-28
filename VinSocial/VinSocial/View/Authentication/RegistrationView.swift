//
//  RegistrationView.swift
//  Messenger
//
//  Created by Stealer Of Souls on 2/7/23.
//

import SwiftUI
import Foundation

struct RegistrationView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var rePassword = ""
    @State private var fullname = ""
    @State private var username = ""
    @Environment(\.presentationMode) var mode
    @EnvironmentObject var viewModel: AuthenViewModel
    @EnvironmentObject var homeViewModel: HomeViewModel
    @State private var isSelected: Bool = true
    @Environment(\.dismiss) var dismiss
    @State var presentInputOtpView: Bool = false
    @State private var showToast = false
    @State var currentEmail = ""
    @State var messageRegister = ""
    
    var body: some View {
//        NavigationView {
        ZStack {
            VStack {
                
//                NavigationLink(
//                    destination: ProfilePhotoSelectorView(),
//                    isActive: $viewModel.didAuthenticateUser,
//                    label: { })
                
                HStack(spacing: 12) {
                    Image("ic_back_arrow")
                        .resizable()
                        .frame(width: 26, height: 26)
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
                    Text(LocalizedStringKey("Label_Register"))
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.white)
                        .padding(.leading)
                    
                    Text(LocalizedStringKey("Description_Register"))
                        .font(.body)
                        .foregroundColor(.white)
                        .padding(.leading)
                    
                    Spacer()
                    
                    VStack {
                        ScrollView {
                            VStack {
                                VStack {
                                    if password != rePassword && !password.isEmpty && !rePassword.isEmpty && self.messageRegister.isEmpty {
                                        CustomValidateField(imageName: "ic_validate", validateText: String(localized: "Validate_Retype_Password"))
                                    }
                                    
                                    if email == currentEmail {
                                        CustomValidationEmptyField(imageName: "ic_validate", validateText: viewModel.messageRegister, text: $viewModel.messageRegister).padding([.top, .leading, .trailing, .bottom], 15)
                                    }
                                    
                                    
                                    CustomTextField(imageName: "ic_edittext_email",
                                                    placeholderText: String(localized: "Placeholder_Full_Name"),
                                                    isSecureField: false,
                                                    text: $fullname)
                                    .padding(.bottom, 10)
                                    
                                    CustomTextField(imageName: "ic_placeholder_email",
                                                    placeholderText: String(localized: "Placeholder_Your_Email"),
                                                    isSecureField: false,
                                                    text: $email)
                                    .padding(.bottom, 10)
                                               
                                    CustomPasswordField(imageName: "ic_edittext_password",
                                                    placeholderText: String(localized: "Placeholder_Password"),
                                                    text: $password)
                                    .padding(.bottom, 10)
                                    
                                    CustomValidationPasswordField(text: $password).frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(.bottom, 10)
                                    
                                    CustomPasswordField(imageName: "ic_edittext_password",
                                                    placeholderText: String(localized: "Placeholder_Retype_Password"),
                                                    text: $rePassword)
                                    .padding(.bottom, 10)
                                }
                                .padding([.top, .leading, .trailing], 15)
                                
                                HStack(spacing: 10) {
                                    
                                    Group {
                                        Toggle("", isOn: $isSelected)
                                            .labelsHidden()
                                            .toggleStyle(CheckBoxView())
                                            .font(.title)
                                    }.padding(.bottom)
                                    
                                    VStack {
                                        Text(LocalizedStringKey("Label_Confirm_Terms_Conditions \(Text("SUCKHOE123").foregroundColor(Color(red: 23/255, green: 136/255, blue: 192/255)).bold())"))
                                            .font(.subheadline)
                                            .foregroundColor(.black)
                                            .padding(.bottom)
                                            .fixedSize(horizontal: false, vertical: true)
                                    }
                                    
                                    
                                }.padding()
                                
                                Button(action: {
                                    viewModel.register(withEmail: email, password: password, fullname: fullname, username: username)
                                    showToast = true
                                    if viewModel.messageRegister.isEmpty {
                                        presentInputOtpView = true
                                    }
                                    self.currentEmail = email
                                    
                                }, label: {
                                    Text(LocalizedStringKey("Label_Continue"))
                                        .font(.headline)
                                        .foregroundColor(.white)
                                        .frame(width: 340, height: 50)
                                        .background(!email.isEmpty && password == rePassword ? Color(red: 23/255, green: 136/255, blue: 192/255) : Color(red: 217/255, green: 217/255, blue: 217/255))
                                        .cornerRadius(10)
                                })
                                .fullScreenCover(isPresented: $viewModel.checkRegister, content: {
        //                            LoginView(onLoginCallBackForHome: loadData)
        //                                .environmentObject(viewModel)
        //                                .environmentObject(homeViewModel)
                                    
                                    LoginTypeView(viewModel: viewModel, homeViewModel: homeViewModel, onLoginCallBackForHome: {
                                        homeViewModel.loadData()
                                    })
                                })
                                .disabled(email.isEmpty || password != rePassword)
                                .shadow(radius: 5)
                                .padding(.top, 10)
                                Spacer()
                            }
                        }
                    }
                    .padding(10)
                    .background(Color.white)
                    .cornerRadius(30)
                    .ignoresSafeArea()
                }
            }
            .blur(radius: viewModel.showLoading ? 5:0)
            .disabled(viewModel.showLoading)
            .navigationBarTitle("")
            .navigationBarHidden(true)
            .padding(.top, 50)
            .edgesIgnoringSafeArea(.top)
            .navigationBarBackButtonHidden(true)
            //.frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(red: 23/255, green: 136/255, blue: 192/255))
            .onAppear {
                self.messageRegister = viewModel.messageRegister
                if email != currentEmail {
                    self.messageRegister = ""
                }
            }
            .gesture(
                DragGesture()
                    .onEnded { gesture in
                        if gesture.translation.width > 100 {
                            dismiss()
                        }
                    }
            )
            .overlay(ActivityIndicatorView(isDisplayed: $viewModel.showLoading, textLoading: String(localized: "Label_Loading_Login"), imageName: "ic_login_loading"){
                Text("")
            })
        }
            
//        }
        
    }
    
    func loadData(){
        
    }
}

struct Overlay<T: View>: ViewModifier {
    @Binding var show: Bool
    let overlayView: T
    
    func body(content: Content) -> some View {
        ZStack {
            content
            if show {
                overlayView
            }
        }
    }
}

extension View {
    func overlay<T: View>(overlayView: T, show: Binding<Bool>) -> some View {
        self.modifier(Overlay(show: show, overlayView: overlayView))
    }
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView().environmentObject(AuthenViewModel())
    }
}
