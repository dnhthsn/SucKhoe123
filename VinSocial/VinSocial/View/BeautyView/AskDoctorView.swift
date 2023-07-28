//
//  AskDoctorView.swift
//  Suckhoe123
//
//  Created by Đinh Thái Sơn on 30/05/2023.
//

import SwiftUI
import _PhotosUI_SwiftUI

struct AskDoctorView: View {
    @ObservedObject var viewModel: BeautyViewModel
    @Environment(\.dismiss) var dismiss
    @State var title: String = ""
    @State var question: String = ""
    @FocusState var isKeyboardShowing: Bool
    @State var topics: [String] = ["Da mặt", "Mắt", "Mũi"]
    @State var cities: [String] = ["Hà Nội", "Hải Phòng", "Hà Nam", "Ninh Bình"]
    @State var selectedTopic = "..."
    @State var selectedCity = "..."
    @State var selectedItem: PhotosPickerItem? = nil
    @State var selectedImageData: Data? = nil
    @State var catid: String = ""
    @State var provinceId: String = ""
    var titleCatalog: String
    @State var selectedImages: [UIImage] = []
    @Binding var showSuccess: Bool
    
    var body: some View {
        VStack {
            HStack {
                Image("ic_back_arrow")
                    .resizable()
                    .frame(width: 26, height: 26)
                    .foregroundColor(Color.white)
                    .onTapGesture {
                        dismiss()
                    }
                
                Text("Hỏi chuyên gia")
                    .foregroundColor(Color.white)
                    .font(.system(size: 20))
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.bottom, 20)
            .padding([.leading, .trailing], 20)
            .background(Color(red: 23/255, green: 136/255, blue: 192/255))
            .frame(maxWidth: .infinity, alignment: .top)
            
            VStack {
                CustomValidationEmptyField(imageName: "ic_validate", validateText: viewModel.messageAsk, text: $viewModel.messageAsk).padding([.top, .leading, .trailing], 15)
                
                VStack {
                    Text("\(Text("Tiêu đề").foregroundColor(Color.black).font(.system(size: 16, weight: .bold)))*").foregroundColor(Color.red)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    TextField("", text: $title)
                        .placeholder(when: title.isEmpty) {
                            Text("Nhập tiêu đề câu hỏi")
                                .foregroundColor(Color(red: 158/255, green: 158/255, blue: 158/255))
                        }
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(Color(red: 244/255, green: 244/255, blue: 244/255), lineWidth: 1)
                                
                        ).background(RoundedRectangle(cornerRadius: 6).fill(Color.white))
                        .focused($isKeyboardShowing)
                        .padding([.top, .bottom], 10)
                }
                
                VStack {
                    Text("\(Text("Chi tiết câu hỏi").foregroundColor(Color.black).font(.system(size: 16, weight: .bold)))*").foregroundColor(Color.red)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    TextEditor(text: $question)
                        .scrollContentBackground(.hidden)
                        .placeholder(when: question.isEmpty) {
                            Text("Hãy mô tả chi tiết câu hỏi để chuyên gia trả lời sớm nhất")
                                .foregroundColor(Color(red: 158/255, green: 158/255, blue: 158/255))
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                                .padding(7)
                        }
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(Color(red: 244/255, green: 244/255, blue: 244/255), lineWidth: 1)
                                
                        )
                        .background(RoundedRectangle(cornerRadius: 6)
                            .fill(Color.white)
                            )
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                        .frame(height: 120)
                        .focused($isKeyboardShowing)
                        .padding([.top, .bottom], 10)
                }
                
                VStack {
                    Text("\(Text("Chủ đề").foregroundColor(Color.black).font(.system(size: 16, weight: .bold)))*").foregroundColor(Color.red)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    
                    
                    Menu {
                        ForEach(0..<viewModel.listCatalogs.count, id: \.self) { index in
                            Button(action: {
                                selectedTopic = viewModel.listCatalogs[index].title ?? ""
                                catid = viewModel.listCatalogs[index].id ?? ""
                            }, label: {
                                Text(viewModel.listCatalogs[index].title ?? "")
                                    .foregroundColor(Color.black)
                                    .font(.system(size: 18))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .frame(height: 50)
                            })
                        }
                        
                    } label: {
                        Label(title: {
                            Text("\(selectedTopic)")
                                .foregroundColor(Color.black)
                                .font(.system(size: 18))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .frame(height: 50)
                            Image("ic_drop_down")
                        }, icon: {})
                    }
                    .padding([.top, .bottom], 5)
                    .padding([.leading, .trailing], 10)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(Color(red: 158/255, green: 158/255, blue: 158/255), lineWidth: 1)
                            
                    )
                    .background(RoundedRectangle(cornerRadius: 6).fill(.white))
                }
                
                VStack {
                    Text("\(Text("Thành phố").foregroundColor(Color.black).font(.system(size: 16, weight: .bold)))*").foregroundColor(Color.red)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    
                    
                    Menu {
                        ForEach(0..<viewModel.listProvince.count, id: \.self) { index in

                            Button(action: {
                                selectedCity = viewModel.listProvince[index].title ?? ""
                                provinceId = viewModel.listProvince[index].id ?? ""
                            }, label: {
                                Text(viewModel.listProvince[index].title ?? "")
                                    .foregroundColor(Color.black)
                                    .font(.system(size: 18))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .frame(height: 50)
                            })
                        }
                        
                    } label: {
                        Label(title: {
                            Text("\(selectedCity)")
                                .foregroundColor(Color.black)
                                .font(.system(size: 18))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .frame(height: 50)
                            Image("ic_drop_down")
                        }, icon: {})
                    }
                    .padding([.top, .bottom], 5)
                    .padding([.leading, .trailing], 10)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(Color(red: 158/255, green: 158/255, blue: 158/255), lineWidth: 1)
                            
                    )
                    .background(RoundedRectangle(cornerRadius: 6).fill(.white))
                }
                
                VStack {
                    Text("Tải lên hình ảnh (nếu có)")
                        .foregroundColor(Color.black)
                        .font(.system(size: 16, weight: .bold))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    HStack {
                        if let selectedImageData,
                           let uiImage = UIImage(data: selectedImageData) {
                            
                            HStack {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 120, height: 120)
                                    .cornerRadius(10)
                                
                                Text("Xoá")
                                    .foregroundColor(Color.red)
                                    .font(.system(size: 20))
                                    .padding([.leading, .trailing], 20)
                                    .padding([.top, .bottom], 5)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color(red: 252/255, green: 230/255, blue: 234/255), lineWidth: 1)
                                    )
                                    .background(RoundedRectangle(cornerRadius: 10).fill(Color(red: 252/255, green: 230/255, blue: 234/255)))
                                    .onTapGesture {
                                        selectedItem = nil
                                    }
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                                    .padding(.trailing, 20)
                            }
                            .padding(5)
                            
                        } else {
                            PhotosPicker (
                                selection: $selectedItem,
                                matching: .images,
                                photoLibrary: .shared()) {
                                    HStack {
                                        Image("ic_upload")
                                            .frame(width: 40, height: 40)
                                            .padding(.leading, 5)
                                        
                                        Text("Tải lên hình ảnh")
                                            .foregroundColor(Color(red: 23/255, green: 136/255, blue: 192/255))
                                            .font(.system(size: 16))
                                            .padding(.trailing, 5)
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(5)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color.white, lineWidth: 1)
                                            
                                    )
                                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.white))
                                }
                                .onChange(of: selectedItem) { newItem in
                                    Task {
                                        if let data = try? await newItem?.loadTransferable(type: Data.self) {
                                            selectedImageData = data
                                            selectedImages.append(UIImage(data: selectedImageData!)!)
                                        }
                                    }
                                }
                        }
                    }
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.blue, style: StrokeStyle(lineWidth: 1, lineCap: .butt, lineJoin: .miter, miterLimit: 0, dash: [3.0, ((2.0*Double.pi)*10)/(10-3.0)], dashPhase: 0))
                    )
                }
            }
            .padding([.leading, .trailing], 20)
            
            Spacer()
            
            Button(action: {
                viewModel.catalogAsk(act: "ask", title: title, content: question, catid: catid, province: provinceId, data: createMediaUpload())
                
            }, label: {
                HStack {
                    Image("ic_send")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundColor(Color.white)
                    
                    Text("Gửi câu hỏi")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
                .padding(.vertical,12)
                .frame(maxWidth: .infinity)
                .background {
                    RoundedRectangle(cornerRadius: 6, style: .continuous)
                        .fill(Color(red: 23/255, green: 136/255, blue: 192/255))
                        .shadow(radius: 10)
                }
                .frame(width: UIScreen.main.bounds.width-20)
            })
            .keyboardAdaptive()
        }
        .gesture(
            DragGesture()
                .onEnded { gesture in
                    if gesture.translation.width > 100 {
                        dismiss()
                    }
                }
        )
        .navigationBarBackButtonHidden(true)
        .onAppear {
            viewModel.listProvine()
            if titleCatalog == "thammy" {
                DispatchQueue.main.async {
                    viewModel.listCatalog(act: "lam-dep")
                }
            } else {
                DispatchQueue.main.async {
                    viewModel.listCatalog(act: "suc-khoe")
                }
            }
        }
        .overlay(
            ActivityIndicatorView(isDisplayed: $viewModel.askLoading, textLoading: String(localized: "Label_Loading"), imageName: "ic_login_loading"){
                Text("")
            }.shadow(radius: 5)
        )
        .disabled(viewModel.askLoading)
        .blur(radius: viewModel.askLoading ? 5 : 0)
        .onChange(of: viewModel.isAsked) { output in
            if output {
                dismiss()
                showSuccess.toggle()
            }
        }
        .toolbar {
            ToolbarItem(placement: .keyboard) {
                Button(LocalizedStringKey("Label_Cancel")){
                    isKeyboardShowing.toggle()
                }
                .frame(maxWidth: .infinity,alignment: .trailing)
            }
        }
        .navigationBarHidden(true)
    }
    
    func createMediaUpload()->[MediaUploadFile]{
        if selectedImages.count > 0 {
            var mediaUploadFiles:[MediaUploadFile] = []
            for uiImage in selectedImages {
                let imageData = uiImage.jpegData(compressionQuality: 0.5)
                if(imageData != nil ){
                    let media = MediaUploadFile(mediaType: "image", data: imageData ?? Data())
                    mediaUploadFiles.append(media)
                }
            }
            return mediaUploadFiles
        }
        return []
    }
}
