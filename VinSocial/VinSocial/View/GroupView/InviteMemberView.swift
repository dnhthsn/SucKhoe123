//
//  InviteMemberView.swift
//  Suckhoe123
//
//  Created by Đinh Thái Sơn on 10/05/2023.
//

import SwiftUI
import _PhotosUI_SwiftUI

struct InviteMemberView: View {
    @Environment(\.dismiss) var dismiss
    @State var searchText: String = ""
    @State var friends:[ListFriend] = []
    @State var showGroupDetail = false
    @State var showNotiDialog = false
    @Binding var groupName: String
    @Binding var groupDes: String
    @Binding var catid: String
    @Binding var group: String
    @Binding var selectedImageData: Data?
    @ObservedObject var viewModel: GroupViewModel
    @ObservedObject var friendViewModel: FriendViewModel
    @State var groupModel: GroupModel?
    @State var groupInfo: GroupInfo?
    var groupid: String
    @Binding var isCreateGroup : Bool

    
    @FocusState private var isKeyboardShowing: Bool
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    HStack {
                        Image("ic_back_arrow")
                            .resizable()
                            .frame(width: 26, height: 26)
                            .foregroundColor(Color.black)
                            .onTapGesture {
                                dismiss()
                                friendViewModel.removeCacheFriend()
                            }
                        
                        Text(LocalizedStringKey("Label_Invite_Member"))
                            .foregroundColor(Color.black)
                            .font(.system(size: 25, weight: .bold))
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding([.leading, .trailing], 20)
                    
                    Rectangle().fill(Color(red: 0.957, green: 0.957, blue: 0.957)).frame(height: 4)

                    HStack{
                        Image("ic_search")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30,height: 30)
                            .foregroundColor(Color.gray)
                            .padding(.horizontal,10)

                        TextField("", text: $searchText)
                            .placeholder(when: searchText.isEmpty) {
                                Text(String(localized: "Label_Search"))
                                    .foregroundColor(Color(red: 158/255, green: 158/255, blue: 158/255))
                            }
                            .focused($isKeyboardShowing)
                            .padding([.top, .bottom], 10)
                            .onChange(of: searchText) { newValue in
                                //send typing in here
                                let newLength = newValue.count
                                if newLength > 2 {
                                    
                                }else{
                                    
                                }
                                
                            }
                        
                        if !searchText.isEmpty {
                            Image("ic_clear")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .padding(.horizontal, 10)
                                .onTapGesture {
                                    searchText = ""
                                }
                        }
                        
                        
                       
                    }
                    .overlay(
                        RoundedRectangle(cornerRadius: 30)
                            .stroke(Color(red: 158/255, green: 158/255, blue: 158/255), lineWidth: 1)
                            
                    ).background(RoundedRectangle(cornerRadius: 30).fill(.white))
                        .toolbar {
                            ToolbarItem(placement: .keyboard) {
                                Button(LocalizedStringKey("Label_Cancel")){
                                    isKeyboardShowing.toggle()
                                }
                                .frame(maxWidth: .infinity,alignment: .trailing)
                            }
                        }
                        .padding([.leading, .trailing], 20)
                    
                    ScrollView {
                        LazyVStack {
                            if !friends.isEmpty {
                                ForEach(friends) { friend in
                                    if friend.userid == friends.last?.userid {
                                        
                                        UserCell(viewModel: viewModel, friendViewModel: friendViewModel, user: friend, groupid: groupid)
                                            .task {
                                                await friendViewModel.loadNextPageFriend(friendid: "", sort: 1) { friend in
                                                    self.friends = friend
                                                }
                                            }
                                            .padding(5)
                                        
                                    } else {
                                        
                                        UserCell(viewModel: viewModel, friendViewModel: friendViewModel, user: friend, groupid: groupid)
                                            .padding(5)
                                    }
                                }
                            } else {
                                HStack {
                                    Text("Danh sách bạn bè trống")
                                        .foregroundColor(.gray)
                                        .multilineTextAlignment(.center)
                                }
                                .frame(maxWidth: .infinity, alignment: .center)
                            }
                        }
                    }
                    .padding([.leading, .trailing], 20)
                    
                    Spacer()
                    
                    Button(action:{
//                        showGroupDetail.toggle()
//                        viewModel.createGroup(act: "create", title: groupName, about: groupDes, grouptype: Int(group)!, banner: selectedImageData!, catid: catid, member: 0) { groupModel in
//                            showGroupDetail = true
//                            self.groupModel = groupModel
//                            viewModel.getGroupInfo(groupid: self.groupModel?.groupid ?? "") { groupInfoRes in
//                                self.groupInfo = groupInfoRes
//                            }
//                        }
//                        showNotiDialog.toggle()
                        showGroupDetail = true
                        },label: {
                            VStack {
                                Rectangle().fill(Color(red: 0.957, green: 0.957, blue: 0.957)).frame(height: 4)
                                
                                Text(LocalizedStringKey("Label_Finish"))
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
                    .keyboardAdaptive()
                }
                .onTapGesture {
                    isKeyboardShowing = false
                }
                .gesture(
                    DragGesture()
                        .onEnded { gesture in
                            if gesture.translation.width > 100 {
                                dismiss()
                                friendViewModel.removeCacheFriend()
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
                
                if(viewModel.isCreateGroup){
                    ProgressView()
                }
                
                if showGroupDetail {
                    NavigationLink(destination: GroupDetailView(groupInfo: self.groupInfo, viewModel: viewModel, groupid: self.groupModel?.groupid ?? "",isCreateGroup:$isCreateGroup), isActive: $showGroupDetail) {

                    }
                }
                
            }
            .onAppear {
                Task {
                    await friendViewModel.loadFirstPageFriend(friendid: "",sort: 1) { friend in
                        self.friends = friend
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        
    }
}

struct InviteMemberView1: View {
    @Environment(\.dismiss) var dismiss
    @State var searchText: String = ""
    @State var friends:[ListFriend] = []
    @ObservedObject var viewModel: GroupViewModel
    @ObservedObject var friendViewModel: FriendViewModel
    var groupid: String
    
    @FocusState private var isKeyboardShowing: Bool
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    HStack {
                        Image("ic_back_arrow")
                            .resizable()
                            .frame(width: 26, height: 26)
                            .foregroundColor(Color.black)
                            .onTapGesture {
                                dismiss()
                                friendViewModel.removeCacheFriend()
                            }
                        
                        Text(LocalizedStringKey("Label_Invite_Member"))
                            .foregroundColor(Color.black)
                            .font(.system(size: 25, weight: .bold))
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding([.leading, .trailing], 20)
                    
                    Rectangle().fill(Color(red: 0.957, green: 0.957, blue: 0.957)).frame(height: 4)

                    HStack{
                        Image("ic_search")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30,height: 30)
                            .foregroundColor(Color.gray)
                            .padding(.horizontal,10)

                        TextField("", text: $searchText)
                            .placeholder(when: searchText.isEmpty) {
                                Text(String(localized: "Label_Search"))
                                    .foregroundColor(Color(red: 158/255, green: 158/255, blue: 158/255))
                            }
                            .focused($isKeyboardShowing)
                            .padding([.top, .bottom], 10)
                            .onChange(of: searchText) { newValue in
                                //send typing in here
                                let newLength = newValue.count
                                if newLength > 2 {
                                    
                                }else{
                                    
                                }
                                
                            }
                        
                        if !searchText.isEmpty {
                            Image("ic_clear")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .padding(.horizontal, 10)
                                .onTapGesture {
                                    searchText = ""
                                }
                        }
                        
                        
                       
                    }
                    .overlay(
                        RoundedRectangle(cornerRadius: 30)
                            .stroke(Color(red: 158/255, green: 158/255, blue: 158/255), lineWidth: 1)
                            
                    ).background(RoundedRectangle(cornerRadius: 30).fill(.white))
                        .toolbar {
                            ToolbarItem(placement: .keyboard) {
                                Button(LocalizedStringKey("Label_Cancel")){
                                    isKeyboardShowing.toggle()
                                }
                                .frame(maxWidth: .infinity,alignment: .trailing)
                            }
                        }
                        .padding([.leading, .trailing], 20)
                    
                    ScrollView(showsIndicators: false) {
                        LazyVStack {
                            if !friends.isEmpty {
                                ForEach(friends) { friend in
                                    if !viewModel.groupMemberId.contains(friend.userid ?? "") {
                                        if friend.userid == friends.last?.userid {
                                            
                                            UserCell(viewModel: viewModel, friendViewModel: friendViewModel, user: friend, groupid: groupid)
                                                .task {
                                                    await friendViewModel.loadNextPageFriend(friendid: "", sort: 1) { friend in
                                                        self.friends = friend
                                                    }
                                                }
                                            
                                        } else {
                                            
                                            UserCell(viewModel: viewModel, friendViewModel: friendViewModel, user: friend, groupid: groupid)
                                        }
                                    }
                                }
                            } else {
                                HStack {
                                    Text("Danh sách bạn bè trống")
                                        .foregroundColor(.gray)
                                        .multilineTextAlignment(.center)
                                }
                                .frame(maxWidth: .infinity, alignment: .center)
                            }
                        }
                    }
                    .padding([.leading, .trailing], 20)
                    
                    Spacer()
                    
                    Button(action:{
                        dismiss()
                        },label: {
                            VStack {
                                Rectangle().fill(Color(red: 0.957, green: 0.957, blue: 0.957)).frame(height: 4)
                                
                                Text(LocalizedStringKey("Label_Finish"))
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
                    .keyboardAdaptive()
                }
                .onTapGesture {
                    isKeyboardShowing = false
                }
                .gesture(
                    DragGesture()
                        .onEnded { gesture in
                            if gesture.translation.width > 100 {
                                dismiss()
                                friendViewModel.removeCacheFriend()
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
            }
            .onAppear {
                Task {
                    await friendViewModel.loadFirstPageFriend(friendid: "",sort: 1) { friend in
                        self.friends = friend
                    }
                }
                
            }
        }
        .navigationBarBackButtonHidden(true)
        
    }
}
