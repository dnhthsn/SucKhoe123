//
//  CustomVideoPlayerView.swift
//  Suckhoe123
//
//  Created by Đinh Thái Sơn on 05/05/2023.
//

import SwiftUI
import AVKit

struct CustomVideoPlayerView: View {
        var video: String
        @State private var player = AVPlayer()
    @Environment(\.dismiss) var dismiss

        var body: some View {
            ZStack(alignment: .topLeading) {
                VideoPlayer(player: player)
                    .edgesIgnoringSafeArea(.all)
                    .onAppear {
                        // Unwrapping optional
                        // Setting the URL of the video file
                        player = AVPlayer(url: URL(string: video)!)
                        
                        // Play the video
                        player.play()
                    }
                
//                Image(systemName: "xmark")
//                    .foregroundColor(.white)
//                    .padding()
//                    .clipShape(Circle())
//                    .onTapGesture {
//                        dismiss()
//                    }
                
            }
            .onDisappear{
                player.pause()
            }
            
        }
}

