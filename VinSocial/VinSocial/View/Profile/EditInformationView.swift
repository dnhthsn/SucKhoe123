//
//  EditInformationView.swift
//  VinSocial
//
//  Created by Đinh Thái Sơn on 17/03/2023.
//

import SwiftUI
import Kingfisher
import Combine
import PhotosUI
import Mantis

struct EditInformationView: View {
    
    @EnvironmentObject var viewModel: AuthenViewModel
    private let user: UserResponse?
    @ObservedObject var profileViewModel: ProfileViewModel

    @State private var fullName: String = ""
    @State private var selfDescription: String = ""
    @State private var gender: String = ""
    @State private var dateOfBirth: String = ""
    @State private var address: String = ""
    @State private var mobile: String = ""
    @State private var education: String = ""
    @State private var working: String = ""
    @Environment(\.dismiss) private var dismiss
    @State var checkEdit: Int = 0
    @State var actionSaveName: Bool = false
    @State var actionSaveDes: Bool = false
    @State var confirm: Bool = false
    @State var confirmDes: Bool = false
    @State var showEditDetail: Bool = false
    @State var selectedItem: PhotosPickerItem? = nil
    @State var selectedImageData: Data? = nil
    @State var saveDetailInfo: Bool = false
    @State var cropImage: UIImage?
    @State var finishCrop = false
    @State var cropWidth = 0
    @State var cropHeight = 0
    @State var isShowing = false
    
    init(user: UserResponse?, profileViewModel: ProfileViewModel) {
        self.user = user
        self.profileViewModel = profileViewModel
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func loadImage(){
        if finishCrop {
            guard let image = cropImage  else { return}
            guard let imageData = image.pngData() else{return}
            let fileName = getDocumentsDirectory().appendingPathComponent("image_file.png")
            try? imageData.write(to: fileName)
            
            viewModel.updateAvatar(act: 1, image_file: selectedImageData ?? Data(), crop_x: 0, crop_y: 0, crop_width: cropWidth, crop_height: cropHeight)
        }
        
    }
    
    @FocusState var isKeyboardShowing: Bool
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Image("ic_back_arrow")
                        .resizable()
                        .frame(width: 26, height: 26)
                        .foregroundColor(Color.white)
                        .onTapGesture {
                            //showEditDetail = false
                            dismiss()
                        }
                    
                    Text(LocalizedStringKey("Label_Edit_Profile_Information"))
                        .foregroundColor(Color.white)
                        .font(.system(size: 20))
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.bottom, 20)
                .padding([.leading, .trailing], 20)
                .background(Color(red: 23/255, green: 136/255, blue: 192/255))
                .frame(maxWidth: .infinity, alignment: .top)
                
                ScrollView {
                    VStack {
                        VStack {
                            HStack {
                                Text(LocalizedStringKey("Label_Avatar"))
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(Color.black)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
//                                PhotosPicker (
//                                    selection: $selectedItem,
//                                    matching: .images,
//                                    photoLibrary: .shared()) {
//                                        HStack {
//                                            Image("ic_edit")
//                                                .resizable()
//                                                .frame(width: 15, height: 15)
//                                                .foregroundColor(Color.blue)
//
//                                            Text(LocalizedStringKey("Label_Edit"))
//                                                .foregroundColor(Color.blue)
//                                        }
//                                    }
//                                    .onChange(of: selectedItem) { newItem in
//                                        Task {
//                                            if let data = try? await newItem?.loadTransferable(type: Data.self) {
//                                                selectedImageData = data
//                                            }
//                                        }
//                                    }
                                
                                PhotosPicker (
                                    selection: $selectedItem,
                                    matching: .images,
                                    photoLibrary: .shared()) {
                                        HStack {
                                            Image("ic_edit")
                                                .resizable()
                                                .frame(width: 15, height: 15)
                                                .foregroundColor(Color.blue)
                                            
                                            Text(LocalizedStringKey("Label_Edit"))
                                                .foregroundColor(Color.blue)
                                        }
                                    }
                                    .onChange(of: selectedItem) { newItem in
                                        Task {
                                            if let data = try? await newItem?.loadTransferable(type: Data.self) {
                                                selectedImageData = data
                                                cropImage = UIImage(data: data)
                                                isShowing = true
                                            }
                                        }
                                    }
                                    .fullScreenCover(isPresented: $isShowing, onDismiss: loadImage, content: {
                                        ImageEditor(image: $cropImage, isShowing: $isShowing, finishCrop: $finishCrop, cropWidth: $cropWidth, cropHeight: $cropHeight)
                                    })
                                
                            }
                            
//                            if let selectedImageData,
//                               let uiImage = UIImage(data: selectedImageData) {
//                                Image(uiImage: uiImage)
//                                    .resizable()
//                                    .scaledToFill()
//                                    .frame(width: 90, height: 90)
//                                    .clipShape(Circle())
//                            } else {
//                                KFImage(URL(string: user?.photo ?? ""))
//                                    .resizable()
//                                    .scaledToFill()
//                                    .frame(width: 90, height: 90)
//                                    .clipShape(Circle())
//                            }
                            
                            if (cropImage != nil && isShowing == false){
                                Image(uiImage: cropImage!)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 90, height: 90)
                                    .clipShape(Circle())
                            } else {
                                KFImage(URL(string: "https://ws.suckhoe123.vn\(profileViewModel.userDetailInfo?.avatar ?? "")"))
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 90, height: 90)
                                    .clipShape(Circle())
                            }
                        }
                        .padding([.leading, .trailing], 20)
                        
                        Divider()
                        
                        VStack {
                            HStack {
                                Text(LocalizedStringKey("Label_Name_Display"))
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(Color.black)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                if checkEdit == 2 {
                                    Button(action: {
                                        checkEdit = 0
                                        actionSaveName.toggle()
                                        viewModel.editUinfo(fullname: fullName, gender: profileViewModel.userDetailInfo?.gender ?? "", birthday: profileViewModel.userDetailInfo?.birthday ?? "", address: profileViewModel.userDetailInfo?.address ?? "", mobile: profileViewModel.userDetailInfo?.mobile ?? "", education: profileViewModel.userDetailInfo?.education ?? "", working: profileViewModel.userDetailInfo?.working ?? "", description: profileViewModel.userDetailInfo?.description ?? "",profile:profileViewModel)
                                    }, label: {
                                        Image("ic_save")
                                            .resizable()
                                            .frame(width: 25, height: 25)
                                        
                                        Text(LocalizedStringKey("Label_Save_Change"))
                                            .font(.system(size: 18))
                                            .foregroundColor(.white)
                                            .padding(5)
                                            
                                    })
                                    .frame(width: 150, height: 32)
                                    .background(Color(red: 23/255, green: 136/255, blue: 192/255))
                                    .cornerRadius(30)
                                    .padding(.leading, 8)
                                } else if checkEdit != 2 {
                                    HStack {
                                        Image("ic_edit")
                                            .resizable()
                                            .frame(width: 15, height: 15)
                                            .foregroundColor(Color.blue)
                                        
                                        Text(LocalizedStringKey("Label_Edit"))
                                            .foregroundColor(Color.blue)
                                    }
                                    .onTapGesture {
                                        checkEdit = 2
                                    }
                                }
                                
                                
                                
                            }
                            
                            if checkEdit == 2 {
                                TextField("", text: $fullName)
                                    .placeholder(when: fullName.isEmpty) {
                                        Text(String(localized: "Placeholder_Full_Name"))
                                            .foregroundColor(Color(red: 158/255, green: 158/255, blue: 158/255))
                                    }
                                    .padding()
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 6)
                                            .stroke(Color(red: 244/255, green: 244/255, blue: 244/255), lineWidth: 1)
                                            
                                    ).background(RoundedRectangle(cornerRadius: 6).fill(Color(red: 244/255, green: 244/255, blue: 244/255)))
                                    .focused($isKeyboardShowing)
                                    .padding([.top, .bottom], 10)
                            } else {
                                Text(fullName)
                                    .padding()
                                    .foregroundColor(Color.gray)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 6)
                                            .stroke(Color(red: 244/255, green: 244/255, blue: 244/255), lineWidth: 1)
                                            
                                    ).background(RoundedRectangle(cornerRadius: 6).fill(Color(red: 244/255, green: 244/255, blue: 244/255)))
                                    .padding([.top, .bottom], 10)
                            }
                            
                        }
                        .padding([.leading, .trailing], 20)
                        
                        Divider()
                        
                        VStack {
                            HStack {
                                Text(LocalizedStringKey("Label_Self_Describe"))
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(Color.black)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                if checkEdit == 3 {
                                    Button(action: {
                                        checkEdit = 0
                                        actionSaveDes.toggle()
                                        viewModel.editUinfo(fullname: fullName, gender: profileViewModel.userDetailInfo?.gender ?? "", birthday: profileViewModel.userDetailInfo?.birthday ?? "", address: profileViewModel.userDetailInfo?.address ?? "", mobile: profileViewModel.userDetailInfo?.mobile ?? "", education: profileViewModel.userDetailInfo?.education ?? "", working: profileViewModel.userDetailInfo?.working ?? "", description: selfDescription,profile:profileViewModel)
                                    }, label: {
                                        Image("ic_save")
                                            .resizable()
                                            .frame(width: 25, height: 25)
                                        
                                        Text(LocalizedStringKey("Label_Save_Change"))
                                            .font(.system(size: 18))
                                            .foregroundColor(.white)
                                            .padding(5)
                                            
                                    })
                                    .frame(width: 150, height: 32)
                                    .background(Color(red: 23/255, green: 136/255, blue: 192/255))
                                    .cornerRadius(30)
                                    .padding(.leading, 8)
                                } else {
                                    HStack {
                                        Image("ic_edit")
                                            .resizable()
                                            .frame(width: 15, height: 15)
                                            .foregroundColor(Color.blue)
                                        
                                        Text(LocalizedStringKey("Label_Edit"))
                                            .foregroundColor(Color.blue)
                                    }
                                    .onTapGesture {
                                        checkEdit = 3
                                    }
                                }
                            }
                            
                            if checkEdit == 3 {
                                TextEditor(text: $selfDescription)
                                    .scrollContentBackground(.hidden)
                                    .placeholder(when: selfDescription.isEmpty) {
                                        Text(LocalizedStringKey("Label_Add_Self_Describe"))
                                            .foregroundColor(Color(red: 158/255, green: 158/255, blue: 158/255))
                                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                                            .padding(7)
                                    }
                                    .onReceive(Just(selfDescription)) { _ in limitText(100)
                                        
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
                                        Text("\(String(selfDescription.count))/100 ký tự")
                                            .font(.system(size: 13))
                                            .foregroundColor(Color.gray)
                                            .padding(6)
                                            .padding(4)
                                            .offset(x: -5, y: 6)
                                        , alignment: .bottomTrailing
                                    )
                                    .padding([.top, .bottom], 10)
                            } else {
                                Text(selfDescription)
                                    .foregroundColor(Color.gray)
                                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                                    .onReceive(Just(selfDescription)) { _ in limitText(100)
                                        
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
                                    .padding([.top, .bottom], 10)
                            }
                            
                        }
                        .padding([.leading, .trailing], 20)
                        
                        Divider()
                        
                        VStack {
                            HStack {
                                Text(LocalizedStringKey("Label_Detail_Information"))
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(Color.black)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                HStack {
                                    Image("ic_edit")
                                        .resizable()
                                        .frame(width: 15, height: 15)
                                        .foregroundColor(Color.blue)
                                    
                                    Text(LocalizedStringKey("Label_Edit"))
                                        .foregroundColor(Color.blue)
                                }
                                .onTapGesture {
                                    showEditDetail.toggle()
                                }
                                .fullScreenCover(isPresented: $showEditDetail, content: {
                                    EditDetailInformationView(profileViewModel: profileViewModel, user: user, saveDetailInfo: $saveDetailInfo)
                                })
                                
//                                        NavigationLink(destination: EditDetailInformationView(user: user, userInfo: userInfo, saveDetailInfo: $saveDetailInfo), isActive: $showEditDetail) {
//
//                                        }
                            }
                            
                            
                            HStack {
                                Image("ic_education")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                
                                Text(LocalizedStringKey("Label_Education \(education)"))
                                    .foregroundColor(Color.black)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.leading, 5)
                            }
                            
                            HStack {
                                Image("ic_location")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                
                                Text(LocalizedStringKey("Label_Location \(address)"))
                                    .foregroundColor(Color.black)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.leading, 5)
                            }
                            
                            HStack {
                                Image("ic_group")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                
                                Text(LocalizedStringKey("Label_Group"))
                                    .foregroundColor(Color.black)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.leading, 5)
                            }
                            
                            HStack {
                                Image("ic_job")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                
                                if working.isEmpty {
                                    Text(LocalizedStringKey("Label_Add_Job_Information"))
                                        .foregroundColor(Color.black)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(.leading, 5)
                                } else {
                                    Text(working)
                                        .foregroundColor(Color.black)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(.leading, 5)
                                }
                                
                            }
                            
                        }
                        .padding([.leading, .trailing], 20)
                        
                        Divider()
                        
                        VStack {
                            HStack {
                                Text(LocalizedStringKey("Label_Account"))
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(Color.black)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                            }.padding([.leading, .trailing], 20)
                            
                            HStack {
                                Image("ic_phone1")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                
                                VStack {
                                    Text(LocalizedStringKey("Label_Phone_Number"))
                                        .font(.system(size: 12))
                                        .foregroundColor(Color.gray)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    
                                    Text(mobile)
                                        .font(.system(size: 18, weight: .bold))
                                        .foregroundColor(Color.black)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                            }.padding([.leading, .trailing], 20)
                            
                            HStack {
                                Image("ic_email")
                                    .scaledToFit()
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(Color(red: 23/255, green: 136/255, blue: 192/255))
                                
                                VStack {
                                    Text("Placeholder_Email")
                                        .font(.system(size: 12))
                                        .foregroundColor(Color.gray)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    
                                    Text(user?.email ?? "")
                                        .font(.system(size: 18, weight: .bold))
                                        .foregroundColor(Color.black)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                            }.padding([.leading, .trailing], 20)
                            
                            Divider()
                            
                            HStack {
                                Text(LocalizedStringKey("Label_Private"))
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(Color.black)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                            }.padding([.leading, .trailing], 20)
                            
                            
                            HStack {
                                Image("ic_gender")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                
                                VStack {
                                    Text(LocalizedStringKey("Label_Gender"))
                                        .font(.system(size: 12))
                                        .foregroundColor(Color.gray)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    
                                    Text(gender)
                                        .font(.system(size: 18, weight: .bold))
                                        .foregroundColor(Color.black)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                            }.padding([.leading, .trailing], 20)
                            
                            HStack {
                                Image("ic_date_of_birth")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                
                                VStack {
                                    Text(LocalizedStringKey("Label_Date_Of_Birth"))
                                        .font(.system(size: 12))
                                        .foregroundColor(Color.gray)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    
                                    Text(dateOfBirth)
                                        .font(.system(size: 18, weight: .bold))
                                        .foregroundColor(Color.black)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                            }.padding([.leading, .trailing], 20)
                        }
                        
                        
                        
                    }
                }
            }
            .disabled(actionSaveName || actionSaveDes || saveDetailInfo)
            .blur(radius: actionSaveDes || saveDetailInfo ? 2 : 0)
            .toolbar {
                ToolbarItem(placement: .keyboard) {
                    Button(LocalizedStringKey("Label_Cancel")){
                        isKeyboardShowing.toggle()
                    }
                    .frame(maxWidth: .infinity,alignment: .trailing)
                }
            }
            .onTapGesture {
                actionSaveName = false
                actionSaveDes = false
                saveDetailInfo = false
            }
            .gesture(
                DragGesture()
                    .onEnded { gesture in
                        if gesture.translation.width > 100 {
                            dismiss()
                        }
                    }
            )
            .onAppear{
                viewModel.getUinfo(profileid: "")
                self.fullName = profileViewModel.userDetailInfo?.fullname ?? ""
                self.selfDescription = profileViewModel.userDetailInfo?.description ?? ""
                if profileViewModel.userDetailInfo?.gender == "M" {
                   self.gender = "Nam"
                } else if profileViewModel.userDetailInfo?.gender == "F" {
                   self.gender = "Nữ"
                } else {
                   self.gender = "Khác"
                }
                self.dateOfBirth = profileViewModel.userDetailInfo?.birthday ?? ""
                self.address = profileViewModel.userDetailInfo?.address ?? ""
                self.mobile = profileViewModel.userDetailInfo?.mobile ?? ""
                self.education = profileViewModel.userDetailInfo?.education ?? ""
                self.working = profileViewModel.userDetailInfo?.working ?? ""
            }
            
            if actionSaveName {
//                CustomDialog(title: String(localized: "Label_Change_Display_Name"), description: String(localized: "Description_Change_Display_Name"), shown: $actionSaveName, confirm: $confirm).shadow(radius: 15)
                
            }
            
            if actionSaveDes {
                CustomDialog(title: "Thêm mô tả?", description: String(localized: ""), shown: $actionSaveDes, confirm: $confirmDes).shadow(radius: 15)
            }
            
            if saveDetailInfo {
                CustomNotifyDialog(image: "success", title: "Hoàn tất", description: "Bạn đã thay đổi thông tin thành công", textButton: "OK", shown: $saveDetailInfo).shadow(radius: 15)
            }
        }
    }
    
    func limitText(_ upper: Int) {
        if selfDescription.count > upper {
            selfDescription = String(selfDescription.prefix(upper))
        }
    }
}

struct ImageEditor: UIViewControllerRepresentable {
    typealias Coordinator = ImageEditorCoordinator
    @Binding var image: UIImage?
    @Binding var isShowing: Bool
    @Binding var finishCrop: Bool
    @Binding var cropWidth: Int
    @Binding var cropHeight: Int

    func makeCoordinator() -> ImageEditorCoordinator {
        return ImageEditorCoordinator(image: $image, isShowing: $isShowing, finishCrop: $finishCrop, cropWidth: $cropWidth, cropHeight: $cropHeight)
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImageEditor>) -> Mantis.CropViewController {
        let editor = Mantis.cropViewController(image: image!)
        editor.delegate = context.coordinator
        return editor
    }
}

class ImageEditorCoordinator: NSObject, CropViewControllerDelegate {
    @Binding var image: UIImage?
    @Binding var isShowing: Bool
    @Binding var finishCrop: Bool
    @Binding var cropWidth: Int
    @Binding var cropHeight: Int
    
    init(image: Binding<UIImage?>, isShowing: Binding<Bool>, finishCrop: Binding<Bool>, cropWidth: Binding<Int>, cropHeight: Binding<Int>) {
        _image = image
        _isShowing = isShowing
        _finishCrop = finishCrop
        _cropWidth = cropWidth
        _cropHeight = cropHeight
    }
    func cropViewControllerDidCrop(_ cropViewController: Mantis.CropViewController, cropped: UIImage, transformation: Mantis.Transformation, cropInfo: Mantis.CropInfo) {
        image = cropped
        isShowing = false
        finishCrop = true
        cropWidth = Int(cropInfo.cropSize.width)
        cropHeight = Int(cropInfo.cropSize.height)
    }
    
    func cropViewControllerDidCancel(_ cropViewController: Mantis.CropViewController, original: UIImage) {
        isShowing = false
        finishCrop = false
    }
    
    
}
