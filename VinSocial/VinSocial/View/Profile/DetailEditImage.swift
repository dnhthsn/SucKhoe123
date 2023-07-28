//
//  DetailEditImage.swift
//  Suckhoe123
//
//  Created by Mrskee on 05/07/2023.
//

import SwiftUI

struct DetailEditImage: View {
    @Binding var medias : [ImagePost]
    @Environment(\.dismiss) var dismiss
    @State var isShowingImagePicker = false

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
                        dismiss()
                        
                    }, label: {
                        Text(LocalizedStringKey("Label_Done"))
                            .font(.headline)
                            .frame(width: 120, height: 40)
                            .cornerRadius(30)
                            
                    })
                    .padding(.leading, 10)
               
                
            }
            .padding(.bottom, 20)
            .padding([.leading, .trailing], 20)
            .background(Color.white)
            .frame(maxWidth: .infinity, alignment: .top)
            .background(RoundedRectangle(cornerRadius: 0).fill(.white).shadow(radius: 5))

            listView
        
            Button {
                isShowingImagePicker.toggle()
            } label: {
                HStack {
                    Image("ic_add_photo")
                        .resizable()
                        .frame(width: 35, height: 35)
                    
                    Text(LocalizedStringKey("Label_Add_Image"))
                        .foregroundColor(Color.black)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding([.leading, .trailing])
            }
            HStack {
                Image("ic_add_video")
                    .resizable()
                    .frame(width: 35, height: 35)
                
                Text(LocalizedStringKey("Label_Add_Video"))
                    .foregroundColor(Color.black)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding([.leading, .trailing])
            
            Spacer()
        }
        .sheet(isPresented: $isShowingImagePicker) {
            MultiImagePicker(selectedImages: $medias)
        }
        .gesture(
            DragGesture()
                .onEnded { gesture in
                    if gesture.translation.width > 100 {
                        dismiss()
                    }
                }
        )
    }
    
    
    @ViewBuilder
    private var listView: some View {
        ScrollView {
            LazyVStack{
                ForEach(medias.indices, id: \.self) { index in
                    Image(uiImage: medias[index].imagePost)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: (getRect().width - 45), height: 250)
                        .cornerRadius(0)
                        .overlay(
                            Button(action: {
                                withAnimation(.easeInOut) {
                                    medias.remove(atOffsets: IndexSet(integer: index))
                                }
                            }, label: {
                                Image(systemName: "xmark")
                                    .foregroundColor(.white)
                                    .padding(5)
                                    .background(Color.gray.opacity(1))
                                    .clipShape(Circle())
                            })
                            .padding(5)
                            
                            , alignment: .topLeading
                        )
                }
               
            }
            .padding(.top, 2)

        }
        
    }
}
