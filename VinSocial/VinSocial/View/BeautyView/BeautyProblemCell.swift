//
//  BeautyProblemCell.swift
//  VinSocial
//
//  Created by Đinh Thái Sơn on 23/03/2023.
//

import SwiftUI
import Kingfisher

struct BeautyProblemCell: View {
    var title: String
    @ObservedObject var viewModelCell:CatalogCellViewModel
    @ObservedObject var viewModel:BeautyViewModel
    @State var isRotated = false
    
    var animation:Animation {
        Animation.easeOut
    }
    
    @State var columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    //KFImage(URL(string: user.photo!))
    var body: some View {
        VStack {
//            Button(action: {
//                self.isRotated.toggle()
//            }, label: {
////                KFImage(URL(string: "https://ws.suckhoe123.vn\(viewModelCell.image)"))
////                    .resizable()
////                    .frame(width: 28, height: 28)
////                    .padding(.leading)
//
////                Text(viewModelCell.grouptitle)
////                    .foregroundColor(Color.black)
////                    .frame(maxWidth: .infinity, alignment: .leading)
////                    .padding()
//
////                Image("ic_arrow_next")
////                    .resizable()
////                    .frame(width: 35, height: 35)
////                    .foregroundColor(Color(red: 23/255, green: 136/255, blue: 192/255))
////                    .rotationEffect(Angle.degrees(isRotated ? 90 : 0))
////                    .animation(animation)
//            })
//            .overlay(
//                RoundedRectangle(cornerRadius: 6)
//                    .stroke(Color(red: 238/255, green: 249/255, blue: 255/255), lineWidth: 1)
//
//            )
//            .background(RoundedRectangle(cornerRadius: 6)
//                .fill(Color(red: 238/255, green: 249/255, blue: 255/255))
//                .shadow(radius: 2))
            
            Text(viewModelCell.grouptitle)
                .foregroundColor(Color(red: 23/255, green: 136/255, blue: 192/255))
                .font(.system(size: 20, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .leading)
                .frame(height: 20)
                .multilineTextAlignment(.leading)
                .truncationMode(.tail)
                
            
            Divider()
            
//            if isRotated {
//                VStack{
//                    ForEach(viewModelCell.getSubCatalog) { subcatalog in
//                        BeautyProblemCellItemView(subCatalog: subcatalog,viewModel:viewModel)
//
//                    }
//                }
//            }
            
            VStack{
                ScrollView {
                    LazyVGrid(columns: columns) {
                        ForEach(viewModelCell.getSubCatalog) { subcatalog in
                            BeautyProblemCellItemView(title: title, subCatalog: subcatalog,viewModel:viewModel)
                            
                        }
                    }
                }
                
            }
        }
        .padding([.leading, .trailing], 20)
        .padding(.top, 10)
    }
}

//struct BeautyProblemCell_Previews: PreviewProvider {
//    static var previews: some View {
//        BeautyProblemCell()
//    }
//}
