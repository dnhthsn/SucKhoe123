import SwiftUI

struct EditDetailInformationView: View {
    @EnvironmentObject var viewModel: AuthenViewModel
    @ObservedObject var profileViewModel: ProfileViewModel
    @Environment(\.dismiss) var dismiss
    let user: UserResponse?
    @State var education: String = ""
    @State var location: String = ""
    @State var job: String = ""
    @State var phoneNumber: String = ""
    @State var dateOfBirth: String = ""
    @State var gender: String = ""
    @State var birthDate = Date.now
    @FocusState var isKeyboardShowing: Bool
    @Binding var saveDetailInfo: Bool
    
    var body: some View {
        VStack {
            HStack {
                Image("ic_back_arrow")
                    .resizable()
                    .frame(width: 26, height: 26)
                    .foregroundColor(Color.black)
                    .onTapGesture {
                        dismiss()
                    }
                
                Text(LocalizedStringKey("Label_Edit"))
                    .foregroundColor(Color.black)
                    .font(.system(size: 20))
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Button(action: {
                    saveDetailInfo.toggle()
                    viewModel.editUinfo(fullname: profileViewModel.userDetailInfo?.fullname ?? "", gender: gender, birthday: dateOfBirth, address: location, mobile: phoneNumber, education: education, working: job, description: profileViewModel.userDetailInfo?.description ?? "",profile: profileViewModel)
                    dismiss()
                }, label: {
                    Image("ic_save")
                        .resizable()
                        .frame(width: 25, height: 25)
                        .padding([.top, .bottom, .leading])
                    
                    Text(LocalizedStringKey("Label_Save"))
                        .font(.system(size: 18))
                        .foregroundColor(.white)
                        .padding([.top, .bottom, .trailing])
                        
                })
                .frame(width: 100, height: 35)
                .background(Color(red: 23/255, green: 136/255, blue: 192/255))
                .cornerRadius(30)
                .padding(.leading, 8)
            }
            .padding(.bottom, 20)
            .padding([.leading, .trailing], 20)
            .background(Color.white)
            .frame(maxWidth: .infinity, alignment: .top)
            
            Divider()
            
            ScrollView {
                VStack(spacing: 10) {
                    HStack {
                        Text(LocalizedStringKey("Label_Detail_Information"))
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(Color.black)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        
                    }
                    
                    
                    HStack {
                        Image("ic_education")
                            .resizable()
                            .frame(width: 30, height: 30)
                        
                        VStack {
                            Text(LocalizedStringKey("Label_Education \("")"))
                                .foregroundColor(Color.gray)
                                .font(.system(size: 15))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.leading, 5)
                            
                            TextField(education, text: $education)
                                .foregroundColor(Color.black)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .placeholder(when: education.isEmpty) {
                                    Text(String(localized: "Label_Education \("")"))
                                        .foregroundColor(Color(red: 158/255, green: 158/255, blue: 158/255))
                                }
                                .padding()
                                .focused($isKeyboardShowing)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 6)
                                        .stroke(Color(red: 244/255, green: 244/255, blue: 244/255), lineWidth: 1)
                                        
                                ).background(RoundedRectangle(cornerRadius: 6).fill(Color(red: 244/255, green: 244/255, blue: 244/255)))
                                .overlay(
                                    Image("ic_edit")
                                        .resizable()
                                        .frame(width: 17, height: 17)
                                        .foregroundColor(Color.gray)
                                        .padding(.trailing), alignment: .trailing
                                )
                                .padding(.leading, 5)
                        }
                    }
                    .padding(.bottom, 5)
                    
                    HStack {
                        Image("ic_location")
                            .resizable()
                            .frame(width: 30, height: 30)
                        
                        VStack {
                            Text(LocalizedStringKey("Label_Location \("")"))
                                .foregroundColor(Color.gray)
                                .font(.system(size: 15))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.leading, 5)
                            
                            TextField(location, text: $location)
                                .foregroundColor(Color.black)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .placeholder(when: location.isEmpty) {
                                    Text(String(localized: "Label_Location \("")"))
                                        .foregroundColor(Color(red: 158/255, green: 158/255, blue: 158/255))
                                }
                                .focused($isKeyboardShowing)
                                .padding()
                                .overlay(
                                    RoundedRectangle(cornerRadius: 6)
                                        .stroke(Color(red: 244/255, green: 244/255, blue: 244/255), lineWidth: 1)
                                        
                                ).background(RoundedRectangle(cornerRadius: 6).fill(Color(red: 244/255, green: 244/255, blue: 244/255)))
                                .overlay(
                                    Image("ic_edit")
                                        .resizable()
                                        .frame(width: 17, height: 17)
                                        .foregroundColor(Color.gray)
                                        .padding(.trailing), alignment: .trailing
                                )
                                .padding(.leading, 5)
                        }
                    }
                    .padding(.bottom, 5)
                    
                    HStack {
                        Image("ic_job")
                            .resizable()
                            .frame(width: 30, height: 30)
                        
                        VStack {
                            Text(LocalizedStringKey("Label_Job"))
                                .foregroundColor(Color.gray)
                                .font(.system(size: 15))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.leading, 5)
                            
                            TextField(job, text: $job)
                                .foregroundColor(Color.black)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .placeholder(when: job.isEmpty) {
                                    Text(String(localized: "Label_Job"))
                                        .foregroundColor(Color(red: 158/255, green: 158/255, blue: 158/255))
                                }
                                .padding()
                                .focused($isKeyboardShowing)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 6)
                                        .stroke(Color(red: 244/255, green: 244/255, blue: 244/255), lineWidth: 1)
                                        
                                ).background(RoundedRectangle(cornerRadius: 6).fill(Color(red: 244/255, green: 244/255, blue: 244/255)))
                                .overlay(
                                    Image("ic_edit")
                                        .resizable()
                                        .frame(width: 17, height: 17)
                                        .foregroundColor(Color.gray)
                                        .padding(.trailing), alignment: .trailing
                                )
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
                                .foregroundColor(Color.gray)
                                .font(.system(size: 15))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.leading, 5)
                            
                            TextField(phoneNumber, text: $phoneNumber)
                                .foregroundColor(Color.black)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .placeholder(when: phoneNumber.isEmpty) {
                                    Text(String(localized: "Label_Phone_Number"))
                                        .foregroundColor(Color(red: 158/255, green: 158/255, blue: 158/255))
                                }
                                .padding()
                                .focused($isKeyboardShowing)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 6)
                                        .stroke(Color(red: 244/255, green: 244/255, blue: 244/255), lineWidth: 1)
                                        
                                ).background(RoundedRectangle(cornerRadius: 6).fill(Color(red: 244/255, green: 244/255, blue: 244/255)))
                                .overlay(
                                    Image("ic_edit")
                                        .resizable()
                                        .frame(width: 17, height: 17)
                                        .foregroundColor(Color.gray)
                                        .padding(.trailing), alignment: .trailing
                                )
                                .padding(.leading, 5)
                        }
                    }.padding([.leading, .trailing], 20)
                    
                    HStack {
                        Image("ic_email")
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                            .foregroundColor(Color(red: 23/255, green: 136/255, blue: 192/255))
                        
                        VStack {
                            Text(LocalizedStringKey("Placeholder_Email"))
                                .foregroundColor(Color.gray)
                                .font(.system(size: 15))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.leading, 5)
                            
                            Text(user?.email ?? "")
                                .foregroundColor(Color.black)
                                .font(.system(size: 20, weight: .bold))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.leading, 5)
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
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                        
                        VStack {
                            Text(LocalizedStringKey("Placeholder_Gender"))
                                .foregroundColor(Color.gray)
                                .font(.headline)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            HStack(spacing: 0) {
                                RadioButtonField(
                                    id: "M",
                                    label: "Nam",
                                    image: "",
                                    description: "",
                                    color:.black,
                                    bgColor: .blue,
                                    isMarked: $gender.wrappedValue == "M" ? true : false,
                                    callback: { selected in
                                        self.gender = selected
                                        print("Selected Gender is: \(selected)")
                                    }
                                )
                                RadioButtonField(
                                    id: "F",
                                    label: "Nữ",
                                    image: "",
                                    description: "",
                                    color:.black,
                                    bgColor: .blue,
                                    isMarked: $gender.wrappedValue == "F" ? true : false,
                                    callback: { selected in
                                        self.gender = selected
                                        print("Selected Gender is: \(selected)")
                                    }
                                )
                                
                                RadioButtonField(
                                    id: "N",
                                    label: "Khác",
                                    image: "",
                                    description: "",
                                    color:.black,
                                    bgColor: .blue,
                                    isMarked: $gender.wrappedValue == "N" ? true : false,
                                    callback: { selected in
                                        self.gender = selected
                                        print("Selected Gender is: \(selected)")
                                    }
                                )
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        
                    }
                    .padding([.leading, .trailing], 20)
                    
                    HStack {
                        Image("ic_date_of_birth")
                            .resizable()
                            .frame(width: 30, height: 30)
                        
                        VStack {
                            Text(LocalizedStringKey("Label_Date_Of_Birth"))
                                .foregroundColor(Color.gray)
                                .font(.system(size: 15))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.leading, 5)
                            
                            DateTimePickerView(dateString: $dateOfBirth)
                            .padding(.leading, 5)
                            
                        }
                    }.padding([.leading, .trailing], 20)
                }
            }
            
            
        }
        .onTapGesture {
            dismissKeyboard()
        }
        .gesture(
            DragGesture()
                .onEnded { gesture in
                    if gesture.translation.width > 100 {
                        dismiss()
                    }
                }
        )
        .toolbar {
            ToolbarItem(placement: .keyboard) {
                Button(LocalizedStringKey("Label_Cancel")){
                    isKeyboardShowing.toggle()
                }
                .frame(maxWidth: .infinity,alignment: .trailing)
            }
        }
        .onAppear{
            education = profileViewModel.userDetailInfo?.education ?? ""
            location = profileViewModel.userDetailInfo?.address ?? ""
            job = profileViewModel.userDetailInfo?.working ?? ""
            phoneNumber = profileViewModel.userDetailInfo?.mobile ?? ""
            dateOfBirth = profileViewModel.userDetailInfo?.birthday ?? ""
        }
    }
}

//struct EditDetailInformationView_Previews: PreviewProvider {
//    static var previews: some View {
//        EditDetailInformationView()
//    }
//}
