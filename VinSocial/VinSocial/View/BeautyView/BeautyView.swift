//
//  BeautyView.swift
//  VinSocial
//
//  Created by Đinh Thái Sơn on 23/03/2023.
//

import SwiftUI

struct BeautyView: View {
    var title: String
    @State var searchText: String = ""
    @Environment(\.dismiss) var dismiss
    @State var catalog:String = ""
    @FocusState private var isKeyboardShowing: Bool
    @State var showContent: Bool = false
    
    @State var columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    @State var columns1 = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    @ObservedObject var viewModel: BeautyViewModel
    
    @State var showTopDoctors: Bool = false

    var body: some View {
//        NavigationView {
//
//        }
        VStack {
            HStack {
                if title == "thammy" {
                    Text(LocalizedStringKey("Label_Beauty"))
                        .font(.system(size: 30, weight: .bold))
                        .foregroundColor(Color.black)
                        .padding(.trailing)
                } else {
                    Text(LocalizedStringKey("Label_Health"))
                        .font(.system(size: 30, weight: .bold))
                        .foregroundColor(Color.black)
                        .padding(.trailing)
                }
                
                
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
                                if title == "thammy" {
                                    viewModel.searchCatalog(mod: "lam-dep", showsuggest: "1", keyword: newValue)
                                } else {
                                    viewModel.searchCatalog(mod: "suc-khoe", showsuggest: "1", keyword: newValue)
                                }
                                
                            }else{
                                viewModel.clearSearch()
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
                   
                }.overlay(
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
            }
            .padding([.leading, .trailing], 20)
            
            Rectangle().fill(Color(red: 0.957, green: 0.957, blue: 0.957)).frame(height: 4)
            
            if viewModel.catalogSearch.isEmpty {
                ScrollView {
                    VStack {
                        VStack {
                            HStack {
                                if title == "thammy" {
                                    Text("Top bác sĩ thẩm mỹ")
                                        .foregroundColor(Color.black)
                                        .font(.system(size: 20, weight: .bold))
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                } else {
                                    Text("Bác sĩ chuyên khoa uy tín")
                                        .foregroundColor(Color.black)
                                        .font(.system(size: 20, weight: .bold))
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                                
                                
                                Text("Xem thêm")
                                    .foregroundColor(Color.blue)
                                    .font(.system(size: 16))
                                    .onTapGesture {
                                        showTopDoctors.toggle()
                                    }
                            }
                            
                            LazyVGrid(columns: columns, spacing: 10) {
                                ForEach(viewModel.topDoctors.prefix(6)) { topDoctor in
                                    TopDoctorCell(viewModel: viewModel, topDoctor: topDoctor)
                                }
                            }
                        }
                        .padding([.leading, .trailing], 20)
                        
                        Rectangle().fill(Color(red: 0.957, green: 0.957, blue: 0.957)).frame(height: 4)
                        
                        if !viewModel.catalogs.isEmpty {
                            ScrollView {
                                VStack {
                                    if title == "thammy" {
                                        Text("Các vấn đề thẩm mỹ")
                                            .foregroundColor(Color.black)
                                            .font(.system(size: 20, weight: .bold))
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .padding([.leading, .trailing], 20)
                                    } else {
                                        Text("Các vấn đề sức khoẻ")
                                            .foregroundColor(Color.black)
                                            .font(.system(size: 20, weight: .bold))
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .padding([.leading, .trailing], 20)
                                    }

                                    Text("Thứ tự danh mục theo bộ phận cơ thể")
                                        .foregroundColor(Color.gray)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding([.leading, .trailing], 20)
                                    
                                    VStack{
                                        ForEach(viewModel.catalogs) { catalog in
                                            BeautyProblemCell(title: title, viewModelCell: CatalogCellViewModel(catalog), viewModel: viewModel)
                                        }
                                    }
                                    
                                    Spacer()
                                }
                            }
                            
                            Rectangle().fill(Color(red: 0.957, green: 0.957, blue: 0.957)).frame(height: 4)
                        }
                        
                        
                        
                        
                        VStack {
                            if title == "thammy" {
                                Text("Danh mục thẩm mỹ")
                                    .foregroundColor(Color.black)
                                    .font(.system(size: 20, weight: .bold))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding([.leading, .trailing], 20)
                            } else {
                                Text("Danh mục sức khoẻ")
                                    .foregroundColor(Color.black)
                                    .font(.system(size: 20, weight: .bold))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding([.leading, .trailing], 20)
                            }
                            
                            
                            Text("Thứ tự danh mục theo bảng chữ cái")
                                .foregroundColor(Color.gray)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding([.leading, .trailing], 20)
                                if viewModel.listCatalogs.count > 0{
                                    ForEach(viewModel.alphabetSections(), id: \.self) { section in
                                        let listFilter = viewModel.filteredData(for: section,listCatalogs:viewModel.listCatalogs)
                                        if listFilter.count > 0 {
                                            Section(header: Text(section).foregroundColor(Color(red: 23/255, green: 136/255, blue: 192/255))
                                                .font(.system(size: 20, weight: .bold))
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                                .frame(height: 20)
                                                .multilineTextAlignment(.leading)
                                                .truncationMode(.tail).padding([.leading, .trailing], 20)) {
                                                    VStack {
                                                        Divider()
                                                        ScrollView {
                                                            LazyVGrid(columns: columns1) {
                                                                ForEach(listFilter) { item in
                                                                    AlphabetCatalogsView(title: title, viewModel: viewModel, item: item)
                                                                }
                                                            }
                                                        }
                                                    }
                                                    .padding([.leading, .trailing], 20)
                                            }
                                        }
                                      
                                    }
                                }
                        }
                    }
                }
            } else {
                CatalogSearchView(viewModel: viewModel, title: title, catalogSearch: viewModel.catalogSearch)
            }
        }
        //.padding(.top, 30)
        .onAppear{
            if title == "thammy" {
                DispatchQueue.main.async {
                    viewModel.topDoctor(act: "lam-dep")
                    viewModel.listCatalog(act: "lam-dep")
                }
            } else {
                DispatchQueue.main.async {
                    viewModel.topDoctor(act: "suc-khoe")
                    viewModel.listCatalog(act: "suc-khoe")
                }
            }
        }
        .fullScreenCover(isPresented: $showTopDoctors, content: {
            TopDoctorView(viewModel: viewModel, topDoctors: viewModel.topDoctors)
        })
    }
}
