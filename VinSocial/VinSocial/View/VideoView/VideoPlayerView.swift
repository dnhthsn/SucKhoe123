//
//  VideoPlayerView.swift
//  VinSocial
//
//  Created by Stealer Of Souls on 4/5/23.
//

import Foundation
import SwiftUI
import AVKit
import UIKit
import Kingfisher

struct VideoPlayerView: UIViewControllerRepresentable {
    var videoURL: URL
//    var thumbURL: String
    
    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let player = AVPlayer(url: videoURL)
        let controller = AVPlayerViewController()
        controller.player = player
        
//        let asset = AVAsset(url: videoURL)
//        let generator = AVAssetImageGenerator(asset: asset)
//        generator.appliesPreferredTrackTransform = true
//        let time = CMTimeMakeWithSeconds(0.5, preferredTimescale: 1000)
//        var image: UIImage?
//        do {
//            let cgImage = try generator.copyCGImage(at: time, actualTime: nil)
//            image = UIImage(cgImage: cgImage)
//        } catch {
//            print(error.localizedDescription)
//        }
        controller.videoGravity = .resizeAspectFill
        controller.showsPlaybackControls = true
//        let imageView = KFImage(URL(string: thumbURL))
////        let imageView = UIImageView(image: image)
//        imageView.contentMode = .scaleAspectFill
//        controller.contentOverlayView?.addSubview(imageView)
//        imageView.frame = controller.contentOverlayView?.bounds ?? CGRect.zero
//
        return controller
    }
    
    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
        uiViewController.player?.replaceCurrentItem(with: AVPlayerItem(url: videoURL))
    }
    
    typealias UIViewControllerType = AVPlayerViewController
    
    
}

