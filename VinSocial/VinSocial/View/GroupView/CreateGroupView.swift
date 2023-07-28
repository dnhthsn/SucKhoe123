//
//  CreateGroupView.swift
//  Suckhoe123
//
//  Created by Đinh Thái Sơn on 09/05/2023.
//

import SwiftUI
import Combine
import _PhotosUI_SwiftUI
import Kingfisher

struct CreateGroupView: View {
    @ObservedObject var viewModel: GroupViewModel
    @State var selectedCatalog = "..."
    @State var selectedCatalogImage = ""
    @State var catid: String = ""
    @Environment(\.dismiss) var dismiss
    @State var groupName: String = ""
    @State var groupDes: String = ""
    @State var group: String = "1"
    @State var selectedItem: PhotosPickerItem? = nil
    @State var selectedImageData: Data?
    @State var selected = "1"
    @State var showNotiDialog = false
    let groups = ["Nhóm công khai", "Nhóm kín"]
    @State var action = false
    @State var groupModel:GroupModel?
    @State var groupInfo: GroupInfo?
    
    @Binding var isCreateGroup : Bool
    
    @FocusState private var isKeyboardShowing: Bool
    
    var body: some View {
        NavigationView(content: {
            ZStack {
                VStack {
                    HStack {
                        Image("ic_back_arrow")
                            .resizable()
                            .frame(width: 26, height: 26)
                            .foregroundColor(Color.black)
                            .onTapGesture {
                                dismiss()
                            }
                        
                        Text(LocalizedStringKey("Label_Create_Group"))
                            .foregroundColor(Color.black)
                            .font(.system(size: 25, weight: .bold))
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding([.leading, .trailing], 20)
                    
                    Rectangle().fill(Color(red: 0.957, green: 0.957, blue: 0.957)).frame(height: 4)
                    
                    ScrollView {
                        VStack {
                            VStack {
                                Text("Tên nhóm")
                                    .foregroundColor(.black)
                                    .font(.system(size: 18, weight: .bold))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                TextField("", text: $groupName)
                                    .placeholder(when: groupName.isEmpty) {
                                        Text(String(localized: "Placeholder_Group_Name"))
                                            .foregroundColor(Color(red: 158/255, green: 158/255, blue: 158/255))
                                    }
                                    .padding()
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 6)
                                            .stroke(Color(red: 244/255, green: 244/255, blue: 244/255), lineWidth: 1)
                                            
                                    ).background(RoundedRectangle(cornerRadius: 6).fill(Color(red: 244/255, green: 244/255, blue: 244/255)))
                                    .focused($isKeyboardShowing)
                                    .padding([.top, .bottom], 10)
                            }
                            
                            VStack {
                                Text("Danh mục")
                                    .foregroundColor(.black)
                                    .font(.system(size: 18, weight: .bold))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                Menu {
                                    ForEach(0..<(viewModel.groupCatalog?.count ?? 0), id: \.self) { index in
                                        Button(action: {
                                            selectedCatalog = viewModel.groupCatalog?[index].title ?? ""
                                            selectedCatalogImage = viewModel.groupCatalog?[index].image ?? ""
                                            catid = viewModel.groupCatalog?[index].catid ?? ""
                                        }, label: {
                                            Text(viewModel.groupCatalog?[index].title ?? "")
                                                .foregroundColor(Color.black)
                                                .font(.system(size: 18))
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                                .frame(height: 50)
                                        })
                                    }
                                    
                                } label: {
                                    Label(title: {
                                        HStack {
                                            KFImage
                                                .url((URL(string: "https://suckhoe123.vn\(selectedCatalogImage)")))
                                                .resizable()
                                                .frame(width: 30, height: 30)
                                                .cornerRadius(20)
                                            Text("\(selectedCatalog)")
                                                .foregroundColor(Color.black)
                                                .font(.system(size: 18))
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                                .frame(height: 50)
                                            Image("ic_drop_down")
                                        }
                                        
                                    }, icon: {})
                                }
                                .padding([.top, .bottom], 5)
                                .padding([.leading, .trailing], 10)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 6)
                                        .stroke(Color(red: 244/255, green: 244/255, blue: 244/255), lineWidth: 1)
                                        
                                )
                                .background(RoundedRectangle(cornerRadius: 6).fill(Color(red: 244/255, green: 244/255, blue: 244/255)))
                            }
                            
                            VStack {
                                Text("Mô tả")
                                    .foregroundColor(.black)
                                    .font(.system(size: 18, weight: .bold))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                TextEditor(text: $groupDes)
                                    .scrollContentBackground(.hidden)
                                    .placeholder(when: groupDes.isEmpty) {
                                        Text(LocalizedStringKey("Placeholder_Group_Description"))
                                            .foregroundColor(Color(red: 158/255, green: 158/255, blue: 158/255))
                                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                                            .padding(7)
                                    }
                                    .onReceive(Just(groupDes)) { _ in limitText(200)
                                        
                                    }
                                    .padding()
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 6)
                                            .stroke(Color(red: 244/255, green: 244/255, blue: 244/255), lineWidth: 1)
                                            
                                    )
                                    .background(RoundedRectangle(cornerRadius: 6)
                                        .fill(Color(red: 244/255, green: 244/255, blue: 244/255))
                                        )
                                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                                    .frame(height: 120)
                                    .focused($isKeyboardShowing)
                                    .overlay(
                                        Text("\(String(groupDes.count))/200 ký tự")
                                            .font(.system(size: 13))
                                            .foregroundColor(Color.gray)
                                            .padding(6)
                                            .padding(4)
                                            .offset(x: -5, y: 6)
                                        , alignment: .bottomTrailing
                                    )
                                    .padding([.top, .bottom], 10)
                            }
                            
                            VStack {
                                Text("Ảnh đại diện")
                                    .foregroundColor(.black)
                                    .font(.system(size: 18, weight: .bold))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                HStack {
                                    if let selectedImageData,
                                       let uiImage = UIImage(data: selectedImageData) {
                                        Image(uiImage: uiImage)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 120, height: 120)
                                            .cornerRadius(10)
                                    } else {
                                        Image("no_image")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 120, height: 120)
                                            .cornerRadius(10)
                                    }

                                    PhotosPicker (
                                        selection: $selectedItem,
                                        matching: .images,
                                        photoLibrary: .shared()) {
                                            HStack {
                                                Image("ic_upload")
                                                    .frame(width: 40, height: 40)
                                                    .padding(.leading, 5)
                                                
                                                Text(LocalizedStringKey("Label_Upload_Avatar"))
                                                    .foregroundColor(Color(red: 23/255, green: 136/255, blue: 192/255))
                                                    .font(.system(size: 15))
                                                    .padding(.trailing, 5)
                                            }
                                            .padding(5)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 10)
                                                    .stroke(Color(red: 234/255, green: 240/255, blue: 255/255), lineWidth: 1)
                                                    
                                            )
                                            .background(RoundedRectangle(cornerRadius: 10).fill(Color(red: 234/255, green: 240/255, blue: 255/255)))
                                            .frame(maxWidth: .infinity, alignment: .center)
                                        }
                                        .onChange(of: selectedItem) { newItem in
                                            Task {
                                                if let data = try? await newItem?.loadTransferable(type: Data.self) {
                                                    selectedImageData = data
                                                }
                                            }
                                        }
                                    
                                    
                                }
                                
                            }
                            
                            VStack {
                                Text(LocalizedStringKey("Label_Group_Type"))
                                    .foregroundColor(.black)
                                    .font(.system(size: 18, weight: .bold))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                HStack {
                                    
                                    VStack{
                                        RadioButtonField(
                                            id: "1",
                                            label: "Nhóm công khai",
                                            image: "ic_public_group",
                                            description: "Bất kỳ ai cũng có thể nhìn thấy mọi người trong nhóm và những bài họ đăng",
                                            color:.black,
                                            bgColor: .blue,
                                            isMarked: $group.wrappedValue == "1" ? true : false,
                                            callback: { selected in
                                                self.group = selected
                                                print("Selected Group is: \(selected)")
                                            }
                                        )
                                        RadioButtonField(
                                            id: "2",
                                            label: "Nhóm kín",
                                            image: "ic_private_group",
                                            description: "Chỉ thành viên được mời vào nhóm mới thấy mọi người trong nhóm và những bài họ đăng",
                                            color:.black,
                                            bgColor: .blue,
                                            isMarked: $group.wrappedValue == "2" ? true : false,
                                            callback: { selected in
                                                self.group = selected
                                                print("Selected Group is: \(selected)")
                                            }
                                        )
                                        
                                    }
                                }
                            }
                        }
                        .padding([.leading, .trailing], 20)
                    }

                    Spacer()
                    
                    Button(action:{
                        viewModel.createGroup(act: "create", title: groupName, about: groupDes, grouptype: Int(group)!, banner: selectedImageData ?? Data(), catid: catid, member: 0) { groupModel in
                            
                            self.groupModel = groupModel
                            viewModel.getGroupInfo(groupid: self.groupModel?.groupid ?? "") { groupInfoRes in
                                self.groupInfo = groupInfoRes
                            }
                        }
                        showNotiDialog.toggle()
                        
                        },label: {
                            VStack {
                                Rectangle().fill(Color(red: 0.957, green: 0.957, blue: 0.957)).frame(height: 4)
                                
                                Text(LocalizedStringKey("Label_Create_Group_1"))
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .padding(.vertical,12)
                                    .frame(maxWidth: .infinity)
                                    .background {
                                        RoundedRectangle(cornerRadius: 6, style: .continuous)
                                            .fill(Color(red: 23/255, green: 136/255, blue: 192/255))
                                    }
                                    .padding([.leading, .trailing], 20)
                            }
                    })
                    .padding(.bottom, 5)
                    
                }
                .disabled(showNotiDialog)
                .blur(radius: showNotiDialog ? 5:0)
//                .keyboardAdaptive()
                .toolbar {
                    ToolbarItem(placement: .keyboard) {
                        Button(LocalizedStringKey("Label_Cancel")){
                            isKeyboardShowing.toggle()
                        }
                        .frame(maxWidth: .infinity,alignment: .trailing)
                    }
                }
                
                if showNotiDialog {
                    if (groupName == "" || groupDes == "" || selectedImageData == nil) {
                        CustomNotifyDialog(image: "about", title: "Chưa đủ thông tin", description: "Vui lòng điền đầy đủ các trường thông tin để tạo nhóm", textButton: "OK", shown: $showNotiDialog).shadow(radius: 15)
                    } else {
//                        CustomNotifyDialog2(image: "success", title: "Tạo nhóm thành công", description: "Hãy mời thêm bạn bè tham gia vào nhóm của bạn", textButton1: "Để sau", textButton2: "Mời thêm", shown: $showNotiDialog, action: $action).shadow(radius: 15)
                        
                    }
                    
                }
                
                if groupModel != nil {
                    NavigationLink(destination: InviteMemberView(groupName: $groupName, groupDes: $groupName, catid: $catid, group: $group, selectedImageData: $selectedImageData, viewModel: viewModel, friendViewModel: FriendViewModel(), groupid: self.groupModel?.groupid ?? "",isCreateGroup:$isCreateGroup), isActive: $showNotiDialog) {
                        
                    }
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
        })
        .navigationBarBackButtonHidden(true)
        .onAppear{
            viewModel.getGroupCatalog(act: "catalog")
        }
    }
    
    func limitText(_ upper: Int) {
        if groupDes.count > upper {
            groupDes = String(groupDes.prefix(upper))
        }
    }
}

//struct CreateGroupView_Previews: PreviewProvider {
//    static var previews: some View {
//        CreateGroupView()
//    }
//}
