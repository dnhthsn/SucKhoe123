//
//  ViewWithouLogin.swift
//  VinSocial
//
//  Created by Stealer Of Souls on 4/21/23.
//

import SwiftUI

struct ViewWithouLogin: View {
    var actionBack: Bool
    @State var showLoginView: Bool = false
    @EnvironmentObject var viewModel: AuthenViewModel
    @EnvironmentObject var homeViewModel: HomeViewModel
    @Environment(\.dismiss) var dismiss
    var body: some View {
        NavigationView {
            VStack{
                if actionBack {
                    HStack {
                        Button {
                            dismiss()
                            
                        } label: {
                            Image("ic_back_arrow")
                                .resizable()
                                .scaledToFit().frame(width: 24,height: 24)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding([.leading, .trailing], 20)
                }
                
                Spacer()
                
                Text(LocalizedStringKey("Description_Login"))
                    .foregroundColor(Color.blue)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24.0)
                Button(action: {
                    //loadingToggle.toggle()
                    showLoginView.toggle()
                    
                }, label: {
                    Text(LocalizedStringKey("Label_Login"))
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(width: 150, height: 50)
                        .background(Color(red: 23/255, green: 136/255, blue: 192/255))
                        .cornerRadius(30)
                })
                .padding(.leading, 10)
                .shadow(radius: 5)

                Spacer()
            }
            .background(Color.white)
            .fullScreenCover(isPresented: $showLoginView, content: {
//                LoginView(onLoginCallBackForHome: loadData)
//                    .environmentObject(viewModel)
//                    .environmentObject(homeViewModel)
                
                LoginTypeView(viewModel: viewModel, homeViewModel: homeViewModel, onLoginCallBackForHome: {
                    homeViewModel.loadData()
                    dismiss()
                })
            })
        }
        
    }
    func loadData(){
        
    }
}

//struct ViewWithouLogin_Previews: PreviewProvider {
//    static var previews: some View {
//        ViewWithouLogin()
//    }
//}
