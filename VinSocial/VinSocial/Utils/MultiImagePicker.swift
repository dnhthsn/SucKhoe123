//
//  MultiImagePicker.swift
//  VinSocial
//
//  Created by Stealer Of Souls on 3/23/23.
//

import Foundation
import SwiftUI
import PhotosUI

struct MultiImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImages: [ImagePost]
    @Environment(\.presentationMode) var presentationMode

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = 0 // Set to 0 for multiple selection
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: PHPickerViewControllerDelegate {
        let parent: MultiImagePicker

        init(_ parent: MultiImagePicker) {
            self.parent = parent
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            for result in results {
                if result.itemProvider.canLoadObject(ofClass: UIImage.self) {
                    result.itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                        if let image = image as? UIImage {
                            DispatchQueue.main.async {
                                let imagePost = ImagePost(imagePost: image, isCreateImage: true,idImage: "0")
                                self.parent.selectedImages.append(imagePost)
                            }
                        }
                    }
                }
            }
            parent.presentationMode.wrappedValue.dismiss()

//            self.parent.presentationMode.wrappedValue.dismiss()
        }
    }

    typealias UIViewControllerType = PHPickerViewController
}
