//
//  BottomSheetChangePage.swift
//  Suckhoe123
//
//  Created by Đinh Thái Sơn on 28/06/2023.
//

import SwiftUI

struct BottomSheetChangePage: View {
    @ObservedObject var profileViewModel: ProfileViewModel
    @State var sorted: String = ""
    @Environment(\.dismiss) var dismiss
    @Binding var result: String
    @State var actItems: [String] = []
    //@Binding var showExpertPage: Bool
    @State var isBeauty: Bool = false
    @State var isHealth: Bool = false
    
    var closeAndDisplayFullScreen: () -> Void

    func checkFunction(){
        actItems.removeAll()
        if let listFunction = profileViewModel.userDetailInfo?.list_function {
            for item in listFunction {
                actItems.append(item.act ?? "")
            }
        }
    }
    
    var body: some View {
        ZStack {
            VStack {
                ZStack {
                    HStack {
                        Button(action: {
                            result = self.sorted
                            closeAndDisplayFullScreen()
                            dismiss()
                        }, label: {
                            Text("Áp dụng")
                                .foregroundColor(Color.blue)
                                .font(.system(size: 20))
                        })
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Image("ic_close")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(Color.black)
                            .frame(width: 20, height: 20)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .onTapGesture {
                                dismiss()
                            }
                    }
                    
                    HStack {
                        Text("Đổi trang")
                            .foregroundColor(Color.black)
                            .font(.system(size: 20, weight: .bold))
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                }

                VStack {
                    if actItems.contains("lam-dep") && actItems.contains("suc-khoe") {
                        HealtExpertView()

                        BeautyExpertView()
                    } else if actItems.contains("lam-dep") && !actItems.contains("suc-khoe"){
                        BeautyExpertView()
                    } else {
                        HealtExpertView()
                    }
                }
                .padding(.top, 20)
            }
            .padding(20)
            .padding(.top, 20)
            .background(Color.white)
            .cornerRadius(40)
            .onAppear{
                self.sorted = result
                checkFunction()
            }
        }
        .shadow(radius: 20)
        .background(Color.white)
        .cornerRadius(40)
    }
    
    @ViewBuilder
    private func HealtExpertView() -> some View {
        HStack(spacing: 10) {
            Image("ic_admin")
                .resizable()
                .frame(width: 30, height: 30)
            
            Text("Chuyên gia sức khoẻ")
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(Color.black)
        }
        .onTapGesture {
            self.result = "suc-khoe"
            //self.showExpertPage = true
            self.isHealth = true
            self.isBeauty = false
        }
        .padding()
        .background(Rectangle().fill(isHealth ? Color(red: 234/255, green: 240/255, blue: 255/255) : Color.white))
    }
    
    @ViewBuilder
    private func BeautyExpertView() -> some View {
        HStack(spacing: 10) {
            Image("ic_person")
                .resizable()
                .frame(width: 30, height: 30)
            
            Text("Chuyên gia thẩm mỹ")
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(Color.black)
        }
        .onTapGesture {
            self.result = "lam-dep"
            //self.showExpertPage = true
            self.isHealth = false
            self.isBeauty = true
        }
        .padding()
        .background(Rectangle().fill(isBeauty ? Color(red: 234/255, green: 240/255, blue: 255/255) : Color.white))
    }
}
