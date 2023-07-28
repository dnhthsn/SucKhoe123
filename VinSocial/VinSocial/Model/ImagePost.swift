//
//  ImagePost.swift
//  Suckhoe123
//
//  Created by Mrskee on 05/07/2023.
//

import Foundation
import UIKit
class ImagePost {
    var imagePost: UIImage
    var isCreateImage:Bool //true thì là thêm mới, false là ảnh cũ đã up rồi
    var idImage:String // Id đã upload rồi nếu isCreateImage = false thì phải có ID
    
    init(imagePost: UIImage, isCreateImage: Bool,idImage:String) {
        self.imagePost = imagePost
        self.isCreateImage = isCreateImage
        self.idImage = idImage
    }
}
