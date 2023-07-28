//
//  DetailNewFeedImage.swift
//  Suckhoe123
//
//  Created by Đinh Thái Sơn on 05/07/2023.
//

import SwiftUI
import Kingfisher

struct DetailNewFeedImage: View {
    @ObservedObject var viewModel:FeedCellViewModel
    let media: [Media]
    @State var position: Int
    @State private var offset = CGSize.zero
    @State private var pos = CGSize.zero
    @Environment(\.dismiss) var dismiss
    @State var content: String = ""
    @State var showContent: Bool = true
    
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
                
                Text("\(position)/\(media.count)")
                    .foregroundColor(Color.white)
                    .font(.system(size: 20))
                    .frame(maxWidth: .infinity, alignment: .center)
                
                Image("ic_following")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundColor(Color.white)
                    .onTapGesture {
                        if position < media.count {
                            position = position + 1
                        }
                        
                    }
            }
            .padding(.bottom, 30)
            .padding([.leading, .trailing], 20)
            .background(Color.black)
            .frame(maxWidth: .infinity, alignment: .top)
            
            ZStack {
                if showContent {
                    VStack {
                        Text("")
                        
                        Spacer()
                        
                        VStack {
                            VStack {
                                HStack {
                                    Text(viewModel.nameUser ?? "")
                                        .foregroundColor(Color.white)
                                        .font(.system(size: 16, weight: .bold))
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    
                                    if CheckTime().getCurrentTime() == CheckTime().convertTime(time: Int(viewModel.newFeed.addtime ?? "") ?? 0) {
                                        Text("• Vừa xong")
                                            .foregroundColor(Color.gray)
                                            .font(.system(size: 16))
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .truncationMode(.tail)
                                            .frame(height: 30)
                                    } else {
                                        Text("• \(CheckTime().compareTime(timeArr1: CheckTime().convertTime(time: Int(viewModel.newFeed.addtime ?? "") ?? 0), timeArr2: CheckTime().getCurrentTime()))")
                                            .foregroundColor(Color.gray)
                                            .font(.system(size: 16))
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .truncationMode(.tail)
                                            .frame(height: 30)
                                    }
                                }
                                
                                Text(viewModel.title ?? "")
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
                                
                                ShareLink(item: viewModel.newFeed.linkpost ?? "") {
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
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(KFImage(URL(string: "https://suckhoe123.vn\(media[position-1].media_url ?? "")")).resizable().frame(maxWidth: .infinity, maxHeight: .infinity).ignoresSafeArea().onTapGesture {
                showContent.toggle()
            })
            .ignoresSafeArea()
        }
        .background(Color.black)
        .onAppear {
            DispatchQueue.main.async {
                content = ((viewModel.newFeed.hometext == "" ? viewModel.newFeed.content : viewModel.newFeed.hometext) ?? "").htmlToString()
            }
        }
        .gesture(
            DragGesture()
                .onChanged { gesture in
                    self.offset = gesture.translation
                    self.pos = gesture.translation
                }
                .onEnded { gesture in
                    if self.offset.height > 200 {
                        withAnimation {
                            self.pos = CGSize(width: 0, height: UIScreen.main.bounds.height)
                            dismiss()
                        }
                    } else if self.pos.width < 200 {
                        withAnimation {
                            self.offset = .zero
                            self.pos = CGSize(width: UIScreen.main.bounds.width, height: 0)
                            if position < media.count {
                                position = position + 1
                            }
                        }
                    } else if self.pos.width > 200 {
                        withAnimation {
                            self.offset = .zero
                            self.pos = CGSize(width: UIScreen.main.bounds.width, height: 0)
                            if position > 1 {
                                position = position - 1
                            }
                        }
                    } else {
                        self.offset = .zero
                        self.pos = .zero
                    }
                }
        )
        .offset(y: offset.height)
        .animation(.spring())
    }
    
    func loadImage() {
        guard let imageUrl = URL(string: "https://suckhoe123.vn\(media[position-1].media_url ?? "")") else {return}
        
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
