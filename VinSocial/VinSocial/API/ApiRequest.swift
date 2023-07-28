////
////  ApiRequest.swift
////  Messenger
////
////  Created by Stealer Of Souls on 2/10/23.
////
//
//import Foundation
//import Alamofire
//import ObjectMapper
//
//class ApiRequest {
//    
//    static func isConnectedToInternet() ->Bool {
//        return NetworkReachabilityManager()!.isReachable
//    }
//    
//    //Nếu có header or parameter thì xài thằng này
////    let headers: HTTPHeaders = [
////                .authorization(username: "test@email.com", password: "testpassword"),
////                .accept("application/json")
////            ]
////
////    let parameters = ["category": "Movies", "genre": "Action"]
////
////    AF.request("https://httpbin.org/headers", headers: headers, parameters: parameters).responseJSON { response in
////                debugPrint(response)
////            }
//    
////    AF.request("https://httpbin.org/basic-auth/\(user)/\(password)")
////                .authenticate(username: user, password: password)
////                .responseJSON { response in
////                    debugPrint(response)
////                }
////
////        // Authentication using URLCredential
////
////    let credential = URLCredential(user: user, password: password, persistence: .forSession)
////
////            AF.request("https://httpbin.org/basic-auth/\(user)/\(password)")
////                .authenticate(with: credential)
////                .responseJSON { response in
////                debugPrint(response)
////                }
//    static func request<T: Mappable>(_ apiRouter: ApiRouter,_ returnType: T.Type, completion: @escaping (_ result: T?, _ error: BaseResponseError?) -> Void) {
//        if !isConnectedToInternet() {
//            // Xử lý khi lỗi kết nối internet
//            return
//        }
//        
//        
//        AF.request(apiRouter).response {(response: DataResponse<BaseResponse<T>>) in
//            switch response.result {
//            case .success:
//                if response.response?.statusCode == 200 {
//                    if (response.result.value?.isSuccessCode())! {
//                        completion((response.result.value?.data)!, nil)
//                    } else {
//                        let err: BaseResponseError = BaseResponseError.init(NetworkErrorType.API_ERROR, (response.result.value?.code)!, (response.result.value?.message)!)
//                        completion(nil, err)
//                    }
//                } else {
//                    let err: BaseResponseError = BaseResponseError.init(NetworkErrorType.HTTP_ERROR, (response.response?.statusCode)!, "Request is error!")
//                    completion(nil, err)
//                }
//                break
//
//            case .failure(let error):
//                if error is AFError {
//                    let err: BaseResponseError = BaseResponseError.init(NetworkErrorType.HTTP_ERROR, error._code, "Request is error!")
//                    completion(nil, err)
//                }
//
//                break
//            }
//        }
//    }
//}
