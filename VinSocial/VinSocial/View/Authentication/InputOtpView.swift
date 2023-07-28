//
//  InputOtpView.swift
//  Messenger
//
//  Created by Đinh Thái Sơn on 16/02/2023.
//

import SwiftUI

struct InputOtpView: View {
    @ObservedObject var viewModel: AuthenViewModel
    @Environment(\.dismiss) var dismiss
    @State var otpText: String = ""
    @State var timeRemaining = 300
    @State var timeResendOtp = 90
    @State var showLogin: Bool = false
    
    let timer = Timer.publish(every: 1.3, on: .main, in: .common).autoconnect()
    @Binding var email: String
    /// - Keyboard State
    @FocusState private var isKeyboardShowing: Bool
    
    func convertSecondsToTime(timeInSeconds : Int) -> String {
        let minutes = timeInSeconds / 60
        let seconds = timeInSeconds % 60
        return String(format: "%02i:%02i", minutes, seconds)
    }
    
    var body: some View {
//        NavigationView{
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
                
                
                VStack (alignment: .leading, spacing: 12){
                    Text(LocalizedStringKey("Label_Verify_Otp"))
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.white)
                    
                    Text(LocalizedStringKey("Description_Verify_Otp \(self.email)"))
                        .font(.body)
                        .foregroundColor(.white)

                    CustomValidationEmptyField(imageName: "ic_validate", validateText: viewModel.messageChangePass, text: $viewModel.messageChangePass).padding([.top, .leading, .trailing], 15)
                    
                    HStack{
                        /// - OTP Text Boxes
                        /// Change Count Based on your OTP Text Size
                        ForEach(0..<6,id: \.self){index in
                            OTPTextBox(index)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 6)
                                        .stroke(viewModel.messageChangePass.isEmpty ? Color.white : Color.red, lineWidth: 1)
                                        .frame(width: 45, height: 50)
                                )
                        }
                    }
                    .background(content: {
                        TextField("", text: $otpText.limit(6))
                            .keyboardType(.numberPad)
                            .textContentType(.oneTimeCode)
                            /// - Hiding it Out
                            .frame(width: 1, height: 1)
                            .opacity(0.001)
                            .focused($isKeyboardShowing)
                    })
                    .contentShape(Rectangle())
                    /// - Opening Keyboard When Tapped
                    .onTapGesture {
                        isKeyboardShowing.toggle()
                    }
                    .padding(.bottom,20)
                    .padding(.top,10)
                    
                    HStack {
                        Text(LocalizedStringKey("Label_Otp_Available"))
                            .foregroundColor(.white)

                        Text(convertSecondsToTime(timeInSeconds:timeRemaining))
                            .foregroundColor(.white)
                            .onReceive(timer) {_ in
                                if timeRemaining > 0 {
                                    timeRemaining -= 1
                                }
                            }

                    }.frame(maxWidth: .infinity, alignment: .leading)
                }
                
                Button(action:{
                    viewModel.forget(userField: email, step: 2, verifykey: otpText, new_password: "", re_password: "")
                    },label: {
                    Text(LocalizedStringKey("Label_Confirm"))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.vertical,12)
                        .frame(maxWidth: .infinity)
                        .background {
                            RoundedRectangle(cornerRadius: 6, style: .continuous)
                                .fill(.blue)
                        }
                })
                .disableWithOpacity(otpText.count < 6)
                Spacer()
                
//                HStack {
//                    Text(LocalizedStringKey("Label_Resend_Otp"))
//                        .foregroundColor(.white)
//                        .bold()
//
//                    Text(LocalizedStringKey("Label_Time_Resend_Otp \(convertSecondsToTime(timeInSeconds:timeResendOtp))"))
//                        .foregroundColor(.white)
//                        .onReceive(timer) {_ in
//                            if(timeResendOtp > 0) {
//                                timeResendOtp -= 1
//                            }
//
//                        }
//                }.frame(maxWidth: .infinity, alignment: .leading)
                
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarTitle("")
            .navigationBarHidden(true)
            .edgesIgnoringSafeArea(.top)
            .gesture(
                DragGesture()
                    .onEnded { gesture in
                        if gesture.translation.width > 100 {
                            dismiss()
                        }
                    }
            )
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .background(Color(red: 23/255, green: 136/255, blue: 192/255))
            .disabled(viewModel.showLoadingForget)
            .blur(radius: viewModel.showLoadingForget ? 5 : 0)
            .overlay(
                ActivityIndicatorView(isDisplayed: $viewModel.showLoadingForget, textLoading: String(localized: "Label_Loading"), imageName: "ic_login_loading"){
                    Text("")
                }.shadow(radius: 5)
            )
            .fullScreenCover(isPresented: $viewModel.showNewPass, content: {
                InputNewPasswordView(viewModel: viewModel, email: $email, otpText: $otpText)
            })
            .environmentObject(viewModel)
            .padding(.all)
            .background(Color(red: 23/255, green: 136/255, blue: 192/255))
            .toolbar {
                ToolbarItem(placement: .keyboard) {
                    Button(LocalizedStringKey("Label_Cancel")){
                        isKeyboardShowing.toggle()
                    }
                    .frame(maxWidth: .infinity,alignment: .trailing)
                }
            }
//        }
        //.navigationViewStyle(.stack)
        
    }
    
    // MARK: OTP Text Box
    @ViewBuilder
    func OTPTextBox(_ index: Int)->some View{
        ZStack{
            if otpText.count > index{
                /// - Finding Char At Index
                let startIndex = otpText.startIndex
                let charIndex = otpText.index(startIndex, offsetBy: index)
                let charToString = String(otpText[charIndex])
                Text(charToString)
            }else{
                Text(" ")
            }
        }
        .frame(width: 45, height: 50)
        .background {
            /// - Highlighting Current Active Box
            let status = (isKeyboardShowing && otpText.count == index)
            RoundedRectangle(cornerRadius: 6, style: .continuous)
                .stroke(status ? Color.primary : Color.gray,lineWidth: status ? 1 : 0.5)
                /// - Adding Animation
                .animation(.easeInOut(duration: 0.2), value: isKeyboardShowing)
        }
        .background(RoundedRectangle(cornerRadius: 6).fill(Color.white))
        .frame(maxWidth: .infinity)
    }
}

//struct InputOtpView_Previews: PreviewProvider {
//    @State static var email: String = ""
//    static var previews: some View {
//        InputOtpView(email: $email)
//    }
//}

// MARK: View Extensions
extension View{
    func disableWithOpacity(_ condition: Bool)->some View{
        self
            .disabled(condition)
            .opacity(condition ? 0.6 : 1)
    }
}

// MARK: Binding <String> Extension
extension Binding where Value == String{
    func limit(_ length: Int)->Self{
        if self.wrappedValue.count > length{
            DispatchQueue.main.async {
                self.wrappedValue = String(self.wrappedValue.prefix(length))
            }
        }
        return self
    }
}
