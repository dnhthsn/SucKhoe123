//
//  MemberCell.swift
//  Messenger
//
//  Created by Đinh Thái Sơn on 28/02/2023.
//

import SwiftUI
import Kingfisher

struct MemberCell: View {
    @State var user:UserObject
    @EnvironmentObject var viewModel: MainTabViewModel
    //isCreateGroup  false- > màn add member -> hiển thị toogle chọn
    
    @State var isCreateGroup:Bool
    @State var isIgnore:Bool = false 
    var body: some View {
                VStack {
                    HStack {
                        KFImage(URL(string: user.userFirebase.image ?? stringURL))
                            .resizable()
                            .scaledToFill()
                            .frame(width: 48, height: 48)
                            .clipShape(Circle())
                            .padding([.top, .bottom], 5)
                        
                        // message info
                        VStack(alignment: .leading, spacing: 4) {
//
                            Text(user.userFirebase.full_name ?? "")
                                .font(.system(size: 14, weight: .semibold))
                            
                            Text(user.userFirebase.userState?.state ?? "")
                                .font(.system(size: 15))
                        }.foregroundColor(.black)
                        
                        Spacer()
                        
                        if !isCreateGroup && !isIgnore{
                            Group {
                                Toggle("", isOn: $user.isSelected)
                                    .labelsHidden()
                                    .toggleStyle(CheckBoxView())
                                    .font(.title).onChange(of: user.isSelected) { newValue in
                                        
                                        
                                    }
                            }.padding([.top, .bottom])
                        }
                        
                        
                    }
                    .padding(.horizontal)
                }
                .onTapGesture{
                    user.isSelected.toggle()
                
                }
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(Color.white, lineWidth: 2)
                        
                ).background(RoundedRectangle(cornerRadius: 6).fill(.white).shadow(radius: 4))
            .padding([.leading, .trailing, .top], 5)
                
    }
}

