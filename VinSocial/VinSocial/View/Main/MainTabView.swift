//
//  MainTabView.swift
//  VinSocial
//
//  Created by Stealer Of Souls on 3/14/23.
//

import SwiftUI

struct MainTabView: View {
    @State var changePassSuccess: Bool = false
    
    var body: some View {
        Home(changePassSuccess: changePassSuccess)
    }
}
//
//struct MainTabView_Previews: PreviewProvider {
//    static var previews: some View {
//        MainTabView()
//    }
//}

// TabItems..

//var tabItems = ["Video","Hình Ảnh","Trang chủ","Nhóm","Cá nhân"]
var tabItems = ["Sức khoẻ","Thẩm mỹ","Trang chủ","Nhóm","Cá nhân"]

func getImageString(value:String)->String{
    switch value {
    case "Sức khoẻ":
        return "Health"
    case "Thẩm mỹ":
        return "Star"
    case "Trang chủ":
        return "Home"
    case "Nhóm":
        return "Group"
    case "Cá nhân":
        return "User"
    default:
        return "Home"
    }
}

struct Home : View {
    @State var selected = "Trang chủ"
    @State var changePassSuccess: Bool = false
    @EnvironmentObject var authenViewModel: AuthenViewModel
    @ObservedObject var viewModel = HomeViewModel()
    @ObservedObject var groupViewModel = GroupViewModel()
    
    @State var centerX : CGFloat = 0
    
    @Environment(\.verticalSizeClass) var size
    
    var body: some View{
        NavigationView{
            VStack(spacing: 0){
                TabView(selection: $selected){
                    BeautyView(title: "suckhoe", viewModel: BeautyViewModel(catalog:"suc-khoe"))
                        .environmentObject(viewModel)
                        .tag(tabItems[0])
                        //.ignoresSafeArea(.all, edges: .top)
                    
                    BeautyView(title: "thammy", viewModel: BeautyViewModel(catalog:"tham-my"))
                        .environmentObject(viewModel)
                        .tag(tabItems[1])
                        //.ignoresSafeArea(.all, edges: .top)
                    
                    HomeView().environmentObject(viewModel)
                        .tag(tabItems[2])
                    
                    GroupView(groupViewModel: groupViewModel).environmentObject(viewModel)
                        .tag(tabItems[3])
                        .ignoresSafeArea(.all, edges: .top)
                    
                    ManageProfileView(user: AuthenViewModel.shared.currentUser)
                        .environmentObject(viewModel)
                        .tag(tabItems[4])
                        .ignoresSafeArea(.all, edges: .top)
                    
                    
                }
                
                
                // Custom TabBar...
                
                HStack(spacing: 0){
                    
                    ForEach(tabItems,id: \.self){value in
                        
                        GeometryReader{reader in
                            
                            TabBarButton(selected: $selected, value: value,centerX: $centerX,rect: reader.frame(in: .global))
                            // setting First Intial Curve...
                                .onAppear(perform: {
                                    
                                    if value == "Trang chủ" {
//                                        centerX = reader.frame(in: .global).midX
                                        centerX = UIScreen.main.bounds.width / 2
                                    }
                                })
                            // For Landscape Mode....
//                                .onChange(of: size) { (_) in
//                                    if selected == value{
//                                        centerX = reader.frame(in: .global).midX
//                                    }
//                                }
                        }
                        .frame(width: 70, height: 50)
                        
                        if value != tabItems.last{Spacer(minLength: 0)}
                    }
                    
                }
                .padding(.horizontal,25)
                .padding(.top)
                // For Smaller Size iPhone Padding Will be 15 And For Notch Phones No Padding
                .padding(.bottom,UIApplication.shared.windows.first?.safeAreaInsets.bottom == 0 ? 15 : UIApplication.shared.windows.first?.safeAreaInsets.bottom)
                //.frame(maxWidth: .infinity, alignment: .center)
                .background(Color.white)
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: -5)
                .padding(.top,-15)
                //.ignoresSafeArea(.all, edges: .horizontal)
            }
            .onAppear{
                DispatchQueue.main.async {
                    AuthenViewModel.shared = AuthenViewModel()
                }
                
            }
            .ignoresSafeArea(.all, edges: .bottom)
            .preferredColorScheme(.light)
        }
        .onAppear {
            UITabBar.appearance().isHidden = true
        }
        .disabled(changePassSuccess)
        .blur(radius: changePassSuccess ? 5 : 0)
        .overlay {
            if changePassSuccess {
                CustomNotifyDialog(image: "ic_success", title: "Thành công", description: "Bạn đã đổi mật khẩu thành công, hãy đăng nhập với mật khẩu mới để tiếp tục sử dụng dịch vụ", textButton: "OK", shown: $changePassSuccess)
                    .shadow(radius: 5)
            }
            
        }
    }
}

struct TabBarButton : View {
    @Binding var selected : String
    var value: String
    @Binding var centerX : CGFloat
    var rect : CGRect
    
    var body: some View{
        Button(action: {
            withAnimation(.spring()){
                selected = value
                centerX = rect.midX
            }
        }, label: {
            VStack{
                Image(getImageString(value: value))
                    .resizable()
                    .renderingMode(.template)
                    .frame(width: 26, height: 26)
                    .foregroundColor(selected == value ? Color(red: 0.09, green: 0.533, blue: 0.753) : .gray)
                
                Text(value)
                    .font(.caption2)
                    .foregroundColor(selected == value ? Color(red: 0.09, green: 0.533, blue: 0.753) : .gray)
                //.opacity(selected == value ? 1 : 0)
            }
            // Deafult Frame For Reading Mid X Axis Fro Curve....
            //.padding(.top)
            .frame(width: 70, height: 50)
            //.offset(y: selected == value ? -15 : 0)
//            .background(
//                Circle()
//                    .fill(selected == value ? Color(red: 0.09, green: 0.533, blue: 0.753) : .clear)
//                    .offset(x: -10, y: selected == value ? -10 : 0)
//
//            )
            
        })
    }
}

// Custom Shape....

struct AnimatedShape: Shape {
    
    var centerX : CGFloat
    
    // animating Path....
    
    var animatableData: CGFloat{
        
        get{return centerX}
        set{centerX = newValue}
    }
    
    func path(in rect: CGRect) -> Path {
        
        return Path{path in
            
            path.move(to: CGPoint(x: 0, y: 15))
            path.addLine(to: CGPoint(x: 0, y: rect.height))
            path.addLine(to: CGPoint(x: rect.width, y: rect.height))
            path.addLine(to: CGPoint(x: rect.width, y: 15))
            
            // Curve....
            
            path.move(to: CGPoint(x: centerX - 35, y: 15))
            
            path.addQuadCurve(to: CGPoint(x: centerX + 35, y: 15), control: CGPoint(x: centerX, y: -30))
        }
    }
}

