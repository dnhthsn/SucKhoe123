//
//  CatalogImageDetailView.swift
//  Suckhoe123
//
//  Created by Đinh Thái Sơn on 01/06/2023.
//

import SwiftUI
import Kingfisher

struct CatalogImageDetailView: View {
    let catalogImage: [CatalogImage]
    @State var position: Int
    @State private var offset = CGSize.zero
    @Environment(\.dismiss) var dismiss
    @State var content: String = ""
    
//    init(catalogImage: [CatalogImage], position: Int) {
//        self.catalogImage = catalogImage
//        self.position = position
//    }
    
    var body: some View {
        VStack {
            HStack {
                Image("ic_previous")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundColor(Color.white)
                    .onTapGesture {
                        if position > 1 {
                            position = position - 1
                        }
                        
                    }
                
                Text("\(position)/\(catalogImage.count)")
                    .foregroundColor(Color.white)
                    .font(.system(size: 20))
                    .frame(maxWidth: .infinity, alignment: .center)
                
                Image("ic_following")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundColor(Color.white)
                    .onTapGesture {
                        if position < catalogImage.count {
                            position = position + 1
                        }
                        
                    }
            }
            .padding(.bottom, 20)
            .padding([.leading, .trailing], 20)
            .background(Color.black)
            .frame(maxWidth: .infinity, alignment: .top)
            
            ZStack {
                VStack {
                    Text("")
                    
                    Spacer()
                    
                    VStack {
                        VStack {
                            HStack {
                                Text(catalogImage[position-1].user_info?.fullname ?? "")
                                    .foregroundColor(Color.white)
                                    .font(.system(size: 16, weight: .bold))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                if CheckTime().getCurrentTime() == CheckTime().convertTime(time: Int(catalogImage[position-1].addtime ?? "") ?? 0) {
                                    Text("• Vừa xong")
                                        .foregroundColor(Color.gray)
                                        .font(.system(size: 16))
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .truncationMode(.tail)
                                        .frame(height: 30)
                                } else {
                                    Text("• \(CheckTime().compareTime(timeArr1: CheckTime().convertTime(time: Int(catalogImage[position-1].addtime ?? "") ?? 0), timeArr2: CheckTime().getCurrentTime()))")
                                        .foregroundColor(Color.gray)
                                        .font(.system(size: 16))
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .truncationMode(.tail)
                                        .frame(height: 30)
                                }
                            }
                            
                            Text(catalogImage[position-1].title ?? "")
                                .foregroundColor(Color.white)
                                .font(.system(size: 16, weight: .bold))
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            ExpandableTextView(text: content, maxLines: 2)
                                .foregroundColor(Color.white)
                                .font(.system(size: 16, weight: .bold))
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .padding(20)
                        
                        HStack {
                            HStack {
                                Image("ic_comment")
                                    .frame(width: 16, height: 16)
                                    .foregroundColor(Color.white)
                                
                                Text("Bình luận")
                                    .foregroundColor(Color.white)
                                    .font(.system(size: 16))
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            
                            ShareLink(item: "https://suckhoe123.vn\(catalogImage[position-1].image ?? "")") {
                                HStack {
                                    Image("ic_share")
                                        .frame(width: 16, height: 16)
                                        .foregroundColor(Color.white)
                                    
                                    Text("Chia sẻ")
                                        .foregroundColor(Color.white)
                                        .font(.system(size: 16))
                                }
                                .frame(maxWidth: .infinity, alignment: .center)
                            }
                            
                            
                            HStack {
                                Image("ic_download")
                                    .frame(width: 16, height: 16)
                                
                                Text("Lưu lại")
                                    .foregroundColor(Color.white)
                                    .font(.system(size: 16))
                            }
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .onTapGesture {
                                loadImage()
                            }
                            
                        }
                        .padding([.leading, .trailing, .bottom], 25)
                    }
                    .frame(width: UIScreen.main.bounds.width)
                    .background(Color(red: 33/255, green: 33/255, blue: 33/255, opacity: 0.6))
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(KFImage(URL(string: "https://suckhoe123.vn\(catalogImage[position-1].image ?? "")")).resizable().frame(maxWidth: .infinity, maxHeight: .infinity).ignoresSafeArea())
            .ignoresSafeArea()
            
        }
        .onAppear {
            DispatchQueue.main.async {
                content = (catalogImage[position-1].hometext ?? "").htmlToString()
            }
        }
        .gesture(
            DragGesture()
                .onChanged { gesture in
                    self.offset = gesture.translation
                }
                .onEnded { gesture in
                    if self.offset.height > 200 {
                        withAnimation {
                            self.offset = CGSize(width: 0, height: UIScreen.main.bounds.height)
                            dismiss()
                        }
                    } else {
                        self.offset = .zero
                    }
                }
        )
        .offset(y: offset.height)
        .animation(.spring())
    }
    
    func loadImage() {
        guard let imageUrl = URL(string: "https://suckhoe123.vn\(catalogImage[position-1].image ?? "")") else {return}
        
        URLSession.shared.dataTask(with: imageUrl) { data, response, error in
            guard let data = data, error == nil else {
                return
            }
            
            DispatchQueue.main.async {
                guard let inputImage = UIImage(data: data) else {return}
                
                let imageSaver = ImageSaver()
                imageSaver.writeToPhotoAlbum(image: inputImage)
            }
        }.resume()
    }
}

//struct CatalogImageDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        CatalogImageDetailView()
//    }
//}
