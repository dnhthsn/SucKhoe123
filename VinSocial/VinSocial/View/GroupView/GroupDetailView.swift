//
//  GroupDetailView.swift
//  Suckhoe123
//
//  Created by Đinh Thái Sơn on 11/05/2023.
//

import SwiftUI
import Kingfisher

struct GroupDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var groupType = 1
    @ObservedObject var viewModel: GroupViewModel
    var groupid: String
    private var groupInfo: GroupInfo?
    @State var showWritePostView: Bool = false
    @State var presentBottomSheet: Bool = false
    @State var showNotiDialog: Bool = false
    @Binding var isCreateGroup : Bool
    
    init (groupInfo: GroupInfo?, viewModel: GroupViewModel, groupid: String, isCreateGroup:Binding<Bool>) {
        self.groupid = groupid
        self.viewModel = viewModel
        self.groupInfo = groupInfo
        _isCreateGroup = isCreateGroup

    }
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    
                    VStack(alignment: .leading) {
                        HStack {
                            Image("ic_back_arrow")
                                .resizable()
                                .frame(width: 26, height: 26)
                                .foregroundColor(Color.white)
                                .onTapGesture {
                                    isCreateGroup.toggle()
                                    viewModel.removeCache()
                                    presentationMode.wrappedValue.dismiss()
//                                    _ = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { timer in
//                                        presentationMode.wrappedValue.dismiss()
//
//                                    }
                                }
                                .padding(.leading, 20)
                                .padding(.top, 40)
                            
                            Text("")
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding(.top, 40)
                            
                            Image("ic_search")
                                .foregroundColor(Color.white)
                                .frame(width: 50, height: 50)
                                .padding(.trailing, 20)
                                .padding(.top, 40)
                        }
                        .background(Color(red: 23/255, green: 136/255, blue: 192/255))
                        .frame(maxWidth: .infinity, alignment: .center)
                        //.ignoresSafeArea()
                        
                        ScrollView(.vertical) {
                            VStack(spacing: 5) {
                                KFImage(URL(string: "https://ws.suckhoe123.vn\(viewModel.groupInfo?.banner ?? "")"))
                                    .resizable()
                                    .frame(width: UIScreen.main.bounds.width, height: 250)
                                    .frame(maxWidth: .infinity, alignment: .center)
                                
                                Text(viewModel.groupInfo?.title ?? "")
                                    .padding(.top, 10)
                                    .padding(.bottom, 10)
                                    .foregroundColor(Color.black)
                                    .font(.system(size: 25, weight: .bold))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding([.leading, .trailing], 20)
                                    .background(Color.white)
                                
                                HStack {
                                    if groupType == 1 {
                                        Image("ic_public_group")
                                            .frame(width: 32, height: 32)
                                    } else {
                                        Image("ic_private_group")
                                            .frame(width: 32, height: 32)
                                    }
                                    
                                    if groupInfo?.grouptype == "1" {
                                        Text("Nhóm công khai")
                                            .foregroundColor(Color.gray)
                                            .font(.system(size: 15, weight: .bold))
                                    } else {
                                        Text("Nhóm kín")
                                            .foregroundColor(Color.gray)
                                            .font(.system(size: 15, weight: .bold))
                                    }
                                    
                                    
                                    Text("•")
                                        .foregroundColor(Color(red: 217/255, green: 217/255, blue: 217/255))
                                    
                                    Text("\(groupInfo?.membertotal ?? "") thành viên")
                                        .foregroundColor(Color.gray)
                                        .font(.system(size: 15, weight: .bold))
                                }
                                .padding([.leading, .trailing], 20)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                
                                HStack {
                                    Button(action: {
                                        self.showWritePostView.toggle()
                                    }, label: {
                                        Image("ic_add")
                                            .foregroundColor(Color.white)
                                            .padding([.leading, .top, .bottom], 20)
                                            .padding(.trailing, 10)
                                            .frame(width: 20, height: 20)
                                        
                                        Text("Đăng bài")
                                            .font(.headline)
                                            .padding([.trailing, .top, .bottom], 20)
                                            .foregroundColor(.white)
                                            
                                            
                                    })
                                    .frame(width: 140, height: 50)
                                    .background(Color(red: 23/255, green: 136/255, blue: 192/255))
                                    .cornerRadius(15)
                                    .fullScreenCover(isPresented: $showWritePostView, content: {
                                        GroupWritePostView(user: AuthenViewModel.shared.currentUser!, groupViewModel: viewModel, groupid: groupid, postid: "", isEditPost: false)
                                    })
                                    
                                    NavigationLink(destination: {
                                        InviteMemberView1(viewModel: viewModel, friendViewModel: FriendViewModel(), groupid: groupid)
                                    }, label: {
                                        HStack {
                                            Image("ic_add_member_group")
                                                .padding([.leading, .top, .bottom], 20)
                                                .padding(.trailing, 10)
                                                .foregroundColor(Color(red: 23/255, green: 136/255, blue: 192/255))
                                                .frame(width: 20, height: 20)
                                            
                                            Text("Mời bạn")
                                                .font(.headline)
                                                .padding([.trailing, .top, .bottom], 20)
                                                .foregroundColor(Color(red: 23/255, green: 136/255, blue: 192/255))
                                        }
                                        .frame(width: 140, height: 50)
                                        .background(Color(red: 234/255, green: 240/255, blue: 255/255))
                                        .cornerRadius(15)
                                    })
                                    
                                    if groupInfo?.user_info?.isadmin == "1" {
                                        NavigationLink(destination: {
                                            SettingGroupView(viewModel: viewModel, groupid: groupInfo?.id ?? "")
                                        }, label: {
                                            Image("ic_settings")
                                                .frame(width: 20, height: 20)
                                                .padding()
                                                .foregroundColor(Color(red: 23/255, green: 136/255, blue: 192/255))
                                                .background(Color(red: 234/255, green: 240/255, blue: 255/255))
                                                .cornerRadius(15)
                                        })
                                    } else {
                                        Button(action: {
                                            presentBottomSheet.toggle()
                                        }, label: {
                                            Image("ic_option")
                                                .frame(width: 20, height: 20)
                                                .padding()
                                                .foregroundColor(Color(red: 23/255, green: 136/255, blue: 192/255))
                                                .background(Color(red: 234/255, green: 240/255, blue: 255/255))
                                                .cornerRadius(15)
                                        })
                                        .sheet(isPresented: $presentBottomSheet) {
                                            BottomSheetGroupView(viewModel: viewModel, friendViewModel: FriendViewModel(), groupid: groupid, groupInfo: groupInfo, showNotiDialog: $showNotiDialog).presentationDetents([.height(200), .large])
                                        }
                                    }
                                    
                                }
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding([.leading, .trailing], 20)
                                
                                //Rectangle().fill(Color(red: 0.957, green: 0.957, blue: 0.957)).frame(height: 4)
                                
                                if (viewModel.newFeeds.isEmpty) {
                                    Text("Hiện chưa có bài đăng nào")
                                        .foregroundColor(Color(red: 23/255, green: 136/255, blue: 192/255))
                                        .padding(.top, 100)
                                }else{
                                    if viewModel.newFeedSearchs.isEmpty {
                                        GroupNewFeedView(viewModel:viewModel, groupid: groupid, isAllNewFeed: false, isSearching: false, showType: TypeShowScreen.HOME)
                                            .padding([.leading, .trailing], 10)
                                    }else{
                                        GroupNewFeedView(viewModel:viewModel, groupid: groupid, isAllNewFeed: false, isSearching:true, showType: TypeShowScreen.HOME)
                                            .padding([.leading, .trailing], 10)
                                    }
                                    
                                   
                                }
                            }
                        }
                    }
                    .ignoresSafeArea()
                    .onAppear{
                        loadData(act: "list", groupid: groupid)
                    }
                    
                    
                }
        //        .padding([.leading, .trailing], 20)
                .navigationBarBackButtonHidden(true)
                .blur(radius: showNotiDialog ? 5:0)
                .disabled(showNotiDialog)
                .gesture(
                    DragGesture()
                        .onEnded { gesture in
                            if gesture.translation.width > 100 {
                                isCreateGroup.toggle()
                                viewModel.removeCache()
                                presentationMode.wrappedValue.dismiss()
                            }
                        }
                )
                
                if showNotiDialog {
                    GroupNotifyDialog(viewModel: viewModel, groupid: groupid, image: "leave", title: "Rời khỏi nhóm", description: "Bạn có chắc muốn rời khỏi nhóm này?", textButton1: "Huỷ", textButton2: "Rời khỏi", shown: $showNotiDialog)
                }
            }
            .navigationBarBackButtonHidden(true)
        }
        .navigationBarBackButtonHidden(true)
    }
    
    func loadData(act: String, groupid: String){
        viewModel.loadData(act: act, groupid: groupid)
    }
}

//struct GroupDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        GroupDetailView()
//    }
//}
