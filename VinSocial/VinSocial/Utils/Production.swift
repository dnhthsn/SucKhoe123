//
//  Production.swift
//  Messenger
//
//  Created by Stealer Of Souls on 2/10/23.
//

import Foundation

struct Production {
    static let BASE_URL: String = "https://ws.suckhoe123.vn/index.php?nv=ws&op=" // Thay thế bằng Base url mà bạn sử dụng ở đây
    static let BASE_URL_SOCIAL: String = "https://ws.suckhoe123.vn/index.php?nv=wa&op=" // Thay thế bằng Base url mà bạn sử dụng ở đây
}

enum NetworkErrorType {
    case API_ERROR
    case HTTP_ERROR
}
