//
//  BottomSheetGroupNewFeed.swift
//  Suckhoe123
//
//  Created by Đinh Thái Sơn on 13/06/2023.
//

import SwiftUI
import UniformTypeIdentifiers

struct BottomSheetGroupNewFeed: View {
    @ObservedObject var viewModel: GroupViewModel
    @Binding var actionDelete : Bool
    @Binding var confirmDelete: Bool
    var url: String
    var actionShare: Bool
    var postid: String
    var userid: String
    var groupid: String
    
    @Environment(\.dismiss) var dismiss
    @State var showEditPost: Bool = false
    
    var showToast: () -> Void
    
    var body: some View {
        if actionShare {
            ZStack {
                VStack(spacing: 15) {
                    HStack {
                        Image("ic_copy_link")
                            .resizable()
                            .frame(width: 30, height: 30)
                        
                        Button(action: {
                            UIPasteboard.general.setValue(self.url, forPasteboardType: UTType.plainText.identifier)
                            
                            dismiss()
                        }, label: {
                            Text(LocalizedStringKey("Label_Copy_Link"))
                                .font(.title3)
                                .padding(.leading, 10)
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        })
                    }
                    
                    HStack {
                        Image("ic_share")
                            .resizable()
                            .frame(width: 30, height: 30)
                        
                        Text(LocalizedStringKey("Label_Share"))
                            .font(.title3)
                            .padding(.leading, 10)
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    Spacer()
                }
                .padding(20)
                .padding(.top, 40)
                .background(Color.white)
            }
            .shadow(radius: 20)
            .background(Color.white)
            .cornerRadius(40)
        } else {
            ZStack {
                VStack(spacing: 15) {
                    if AuthenViewModel.shared.currentUser?.userid == userid {
                        HStack {
                            Image("ic_edit")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundColor(Color.black)
                            
                            Text(LocalizedStringKey("Label_Edit_Post"))
                                .font(.title3)
                                .padding(.leading, 10)
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .onTapGesture {
                            showEditPost.toggle()
                        }
                        .fullScreenCover(isPresented: $showEditPost, content: {
                            GroupWritePostView(user: AuthenViewModel.shared.currentUser!, groupViewModel: viewModel, groupid: groupid, postid: postid, isEditPost: true)
                        })
                    }
                    
                    HStack {
                        Image("ic_copy_link")
                            .resizable()
                            .frame(width: 30, height: 30)
                        
                        Button(action: {
                            UIPasteboard.general.setValue(self.url, forPasteboardType: UTType.plainText.identifier)
                            showToast()
                            dismiss()
                        }, label: {
                            Text(LocalizedStringKey("Label_Copy_Link"))
                                .font(.title3)
                                .padding(.leading, 10)
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        })
                    }
                    
                    HStack {
                        ShareLink(item: self.url) {
                            Image("ic_share")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundColor(Color.black)
                            
                            Text(LocalizedStringKey("Label_Share"))
                                .font(.title3)
                                .padding(.leading, 10)
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    
                    if AuthenViewModel.shared.currentUser?.userid == userid {
                        HStack {
                            Image("ic_red_delete_chat")
                                .resizable()
                                .frame(width: 30, height: 30)
                            
                            Text(LocalizedStringKey("Label_Delete_Post"))
                                .font(.title3)
                                .padding(.leading, 10)
                                .foregroundColor(Color(red: 239/255, green: 60/255, blue: 77/255))
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }.onTapGesture {
                            actionDelete.toggle()
                            viewModel.deleteGroupPost(act: "deletePost", postid: postid, groupid: groupid)
                            dismiss()
                        }
                    }
                    
         
                    Spacer()
                }
                .padding(20)
                .padding(.top, 40)
                .background(Color.white)
            }
            .shadow(radius: 20)
            .background(Color.white)
            .cornerRadius(40)
        }
    }
}
