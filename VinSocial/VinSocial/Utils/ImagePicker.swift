//
//  ImagePicker.swift
//  Messenger
//
//  Created by Stealer Of Souls on 2/7/23.
//

import SwiftUI

//
//  ImagePicker.swift
//  Messenger
//
//  Created by Stealer Of Souls on 2/7/23.
//

import SwiftUI

struct ImagePicker : UIViewControllerRepresentable {

    class Coordinator : NSObject , UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent : ImagePicker

        init(_ parent : ImagePicker){
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//            if let uiimage = info[.editedImage] as? UIImage{
//                parent.image = uiimage
//            }
            if let uiimage = info[.originalImage] as? UIImage{
                          parent.image = uiimage
                      }
            if let urlImage = info[.imageURL] as? String{
                          parent.imageURL = urlImage
                      }


            parent.presentationMode.wrappedValue.dismiss()
        }
    }

    @Environment(\.presentationMode) var presentationMode
    @Binding var image : UIImage?
    @Binding var imageURL : String?
    @State var source : UIImagePickerController.SourceType


    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = source
//        picker.allowsEditing = true
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {

    }

}

//




