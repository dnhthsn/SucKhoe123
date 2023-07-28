//
//  MediaUploadFile.swift
//  VinSocial
//
//  Created by Stealer Of Souls on 3/28/23.
//

import Foundation

class MediaUploadFile {
    var mediaType: String
    var data: Data
    
    init(mediaType: String, data: Data) {
        self.mediaType = mediaType
        self.data = data
    }
}
