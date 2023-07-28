//
//  VideoCard.swift
//  Suckhoe123
//
//  Created by Đinh Thái Sơn on 05/05/2023.
//

import SwiftUI
import AVKit

struct VideoCard: View {
    var video: String
    var videoLink: String
    @Binding var playVideo: Bool
    @State private var player = AVPlayer()
    @State var showFullVideo: Bool = false
    
    var body: some View {
        ZStack {
            ZStack(alignment: .bottomLeading) {
                if playVideo {
                    ZStack(alignment: .topLeading) {
                        
                        
                        VideoPlayer(player: player)
                            .frame(width: 125, height: 70)
                            .cornerRadius(15)
                            .onAppear {
                                // Unwrapping optional
                                // Setting the URL of the video file
                                player = AVPlayer(url: URL(string: videoLink)!)
                                
                                // Play the video
                                player.play()
                            }
                        
                        Button {
                            showFullVideo = true
                            player.pause()
                        } label: {
                            Image("ic_full_screen")
                                .foregroundColor(.white)
                                .padding()
                                .clipShape(Circle())
                        }
                        .fullScreenCover(isPresented: $showFullVideo, content: {
                            ZStack(alignment: .topLeading) {
                                CustomVideoPlayerView(video: videoLink)

                                Button {
                                    showFullVideo = false
                                } label: {
                                    Image("ic_small_screen")
                                        .foregroundColor(.white)
                                        .padding()
                                        .clipShape(Circle())
                                }

                            }
                        })
                        
//                        NavigationLink(destination: {
//                            CustomVideoPlayerView(video: videoLink)
//                        }, label: {
//                            Image(systemName: "xmark")
//                                .foregroundColor(.white)
//                                .padding()
//                                .clipShape(Circle())
//                        })
                    }
                    
                } else {
                    
                    AsyncImage(url: URL(string: video)) { image in
                        image.resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 125, height: 70)
                            .cornerRadius(15)
                    } placeholder: {
                        Rectangle()
                            .foregroundColor(.gray.opacity(0.3))
                            .frame(width: 125, height: 70)
                            .cornerRadius(15)
                    }
                }
                
            }
            
            if !playVideo {
                Image(systemName: "play.fill")
                    .resizable()
                    .frame(width: 32, height: 32)
                    .foregroundColor(.white)
                    .font(.title)
                    .padding()
                    .cornerRadius(30)
                    .onTapGesture {
                        playVideo.toggle()
                    }
            }
            
        }
        
    }
}

struct VideoCard1: View {
    var video: String
    var videoLink: String
    @Binding var playVideo: Bool
    @State private var player = AVPlayer()
    @State var showFullVideo: Bool = false
    
    var body: some View {
        ZStack {
            ZStack(alignment: .bottomLeading) {
                if playVideo {
                    ZStack(alignment: .topLeading) {
                        
                        
                        VideoPlayer(player: player)
                            .frame(width: UIScreen.main.bounds.width, height: 400)
                            .cornerRadius(15)
                            .onAppear {
                                // Unwrapping optional
                                // Setting the URL of the video file
                                player = AVPlayer(url: URL(string: videoLink)!)
                                
                                // Play the video
                                player.play()
                            }
                        
                        Button {
                            showFullVideo = true
                            player.pause()
                        } label: {
                            Image("ic_full_screen")
                                .foregroundColor(.white)
                                .padding()
                                .clipShape(Circle())
                        }
                        .fullScreenCover(isPresented: $showFullVideo, content: {
                            ZStack(alignment: .topLeading) {
                                CustomVideoPlayerView(video: videoLink)

                                Button {
                                    showFullVideo = false
                                } label: {
                                    Image("ic_small_screen")
                                        .foregroundColor(.white)
                                        .padding()
                                        .clipShape(Circle())
                                }

                            }
                        })
                        
//                        NavigationLink(destination: {
//                            CustomVideoPlayerView(video: videoLink)
//                        }, label: {
//                            Image(systemName: "xmark")
//                                .foregroundColor(.white)
//                                .padding()
//                                .clipShape(Circle())
//                        })
                    }
                    
                } else {
                    
                    AsyncImage(url: URL(string: video)) { image in
                        image.resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: UIScreen.main.bounds.width, height: 400)
                            .cornerRadius(15)
                    } placeholder: {
                        Rectangle()
                            .foregroundColor(.gray.opacity(0.3))
                            .frame(width: UIScreen.main.bounds.width, height: 400)
                            .cornerRadius(15)
                    }
                }
                
            }
            
            if !playVideo {
                Image(systemName: "play.fill")
                    .resizable()
                    .frame(width: 32, height: 32)
                    .foregroundColor(.white)
                    .font(.title)
                    .padding()
                    .cornerRadius(30)
                    .onTapGesture {
                        playVideo.toggle()
                    }
            }
            
        }
        
    }
}
