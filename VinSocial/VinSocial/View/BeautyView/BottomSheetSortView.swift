//
//  BottomSheetSortView.swift
//  Suckhoe123
//
//  Created by Đinh Thái Sơn on 26/05/2023.
//

import SwiftUI

struct BottomSheetSortView: View {
    @State var sorted: String = ""
    @Environment(\.dismiss) var dismiss
    @Binding var result: String
    var type: String
    
    var body: some View {
        ZStack {
            VStack {
                ZStack {
                    HStack {
                        Button(action: {
                            result = self.sorted
                            dismiss()
                        }, label: {
                            Text("Áp dụng")
                                .foregroundColor(Color.blue)
                                .font(.system(size: 20))
                        })
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Image("ic_close")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(Color.black)
                            .frame(width: 20, height: 20)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .onTapGesture {
                                dismiss()
                            }
                    }
                    
                    HStack {
                        Text("Sắp xếp theo")
                            .foregroundColor(Color.black)
                            .font(.system(size: 20, weight: .bold))
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
                
                if type == "media" {
                    VStack {
                        RadioButtonField1(id: "new", label: "Mới nhất", color:.black,
                                          bgColor: .blue,
                                          isMarked: $sorted.wrappedValue == "new" ? true : false, callback: { selected in
                            self.sorted = selected
                        })
                        .padding()
                        
                        RadioButtonField1(id: "default", label: "Mặc định", color:.black,
                                          bgColor: .blue,
                                          isMarked: $sorted.wrappedValue == "default" ? true : false, callback: { selected in
                            self.sorted = selected
                        })
                        .padding()
                        
                        RadioButtonField1(id: "visited", label: "Lượt xem", color:.black,
                                          bgColor: .blue,
                                          isMarked: $sorted.wrappedValue == "visited" ? true : false, callback: { selected in
                            self.sorted = selected
                        })
                        .padding()
                    }
                } else if type == "doctor" {
                    VStack {
                        RadioButtonField1(id: "recent", label: "Mặc định", color:.black,
                                          bgColor: .blue,
                                          isMarked: $sorted.wrappedValue == "recent" ? true : false, callback: { selected in
                            self.sorted = selected
                        })
                        .padding()
                        
                        RadioButtonField1(id: "visited", label: "Lượt xem", color:.black,
                                          bgColor: .blue,
                                          isMarked: $sorted.wrappedValue == "visited" ? true : false, callback: { selected in
                            self.sorted = selected
                        })
                        .padding()
                    }
                } else if type == "question" {
                    VStack {
                        RadioButtonField1(id: "recent", label: "Mới nhất", color:.black,
                                          bgColor: .blue,
                                          isMarked: $sorted.wrappedValue == "recent" ? true : false, callback: { selected in
                            self.sorted = selected
                        })
                        .padding()
                        
                        RadioButtonField1(id: "answer", label: "Số trả lời", color:.black,
                                          bgColor: .blue,
                                          isMarked: $sorted.wrappedValue == "answer" ? true : false, callback: { selected in
                            self.sorted = selected
                        })
                        .padding()
                        
                        RadioButtonField1(id: "visited", label: "Lượt xem", color:.black,
                                          bgColor: .blue,
                                          isMarked: $sorted.wrappedValue == "visited" ? true : false, callback: { selected in
                            self.sorted = selected
                        })
                        .padding()
                    }
                }
                
            }
            .padding(20)
            .padding(.top, 40)
            .background(Color.white)
            .cornerRadius(40)
            .onAppear{
                self.sorted = result
            }
        }
        .shadow(radius: 20)
        .background(Color.white)
        .cornerRadius(40)
    }
}
