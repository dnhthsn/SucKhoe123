//
//  SplashView.swift
//  Messenger
//
//  Created by Đinh Thái Sơn on 14/02/2023.
//

import SwiftUI

struct SplashView: View {
    @ObservedObject var viewModel: AuthenViewModel = AuthenViewModel()
    @State var isActive: Bool = false
    @State var changePassSuccess: Bool = false
    @State private var downloadAmount = 0.0
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack {
            VStack {
                if self.isActive {
                    Group {
                        MainTabView(changePassSuccess: changePassSuccess).environmentObject(MainTabViewModel())
                            .environmentObject(HomeViewModel())
                            .environmentObject(viewModel)
                    }
                } else {
                    ZStack {
                        Image("logo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 300, height: 150, alignment: .top)
                            .padding(.top)
                        
                        ProgressView("", value: downloadAmount, total: 50)
                            .onReceive(timer) { _ in
                                DispatchQueue.global().async {
                                    DispatchQueue.main.async {
                                        if downloadAmount < 50 {
                                            downloadAmount += 2
                                        } else {
                                            self.isActive = true
                                        }
                                    }
                                }       
                            }
                            .frame(maxHeight: .infinity, alignment: .bottom)
                            .padding(.bottom, 50)
                            .padding([.leading, .trailing], 80)
                            .tint(Color(red: 23/255, green: 136/255, blue: 192/255))
                            .animation(.spring())
                    }.onAppear{
                        if viewModel.currentUser != nil{
                            viewModel.getUinfo(profileid: "")
                        }
                    }
                    
                    
                    
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .background(Color.white)
        }
        .ignoresSafeArea()
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation {
                    //                    self.isActive = true
                }
            }
        }
        .environmentObject(viewModel)
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView().environmentObject(AuthenViewModel())
    }
}
