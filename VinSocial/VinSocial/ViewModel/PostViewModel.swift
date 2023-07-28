//
//  PostViewModel.swift
//  VinSocial
//
//  Created by Đinh Thái Sơn on 15/03/2023.
//

import SwiftUI

class PostViewModel: ObservableObject {
    static let shared: PostViewModel = .init()
   
    @Published var showImageViewer = false
    
    @Published var selectedImageID: String = ""
    
    @Published var imageViewerOffset: CGSize = .zero
    
    @Published var bgOpacity: Double = 1
    
    @Published var imageScale: CGFloat = 1
    
    func onChanged(value: CGSize) {
        DispatchQueue.main.async {
            self.imageViewerOffset = value
            
            let halgHeight = UIScreen.main.bounds.height / 2
            
            let progress = self.imageViewerOffset.height / halgHeight
            
            withAnimation(.default) {
                self.bgOpacity = Double(1 - (progress < 0 ? -progress:progress))
            }
        }
    }
    
    func onEnd(value: DragGesture.Value) {
        withAnimation(.easeInOut) {
            var translation = value.translation.height
            
            if translation < 0 {
                translation = -translation
            }
            
            if translation < 250 {
                imageViewerOffset = .zero
                bgOpacity = 1
            } else {
                showImageViewer.toggle()
                imageViewerOffset = .zero
                bgOpacity = 1
            }
        }
    }
}
