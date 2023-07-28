//
//  APIService.swift
//  ShareExtention
//
//  Created by Dinh Dai on 12/11/19.
//  Copyright © 2019 VivaVietNam. All rights reserved.abc
//

import Foundation
import Alamofire
import UIKit

enum MethodApiExtension
{
    case PostApi
    case GetApi
    case PutApi
    case DeleteApi
    case OptionsApi
}

open class APIService {
    static let sharedInstance = APIService()
    typealias CompletionHandler = (_ response: [String: Any]) -> Void
    typealias CompletionHandlerArray = (_ response: [[String: Any]]) -> Void
    typealias ErrorHandler = (_ response: Error) -> Void
    
    func httpRequestAPI(_ apiRouter: ApiRouter,isHeader:Bool? = false, headerXtra: [String:String]? = nil,completionHandler: @escaping CompletionHandler,failure:@escaping ErrorHandler)->DataRequest? {
        var headers = HTTPHeaders()
        if !isHeader! {
            headers["Accept"] = "application/json"
            headers["Content-Type"] = "application/x-www-form-urlencoded"
            
        }
//
        if let head = headerXtra {
            for (key,value) in head {
                headers[key] = value
            }
        }
        if var parameterForRequest = apiRouter.parameters {
            for (key,value) in parameterForRequest {
                if let realValue = value as? String {
                    if realValue == ""{
                        parameterForRequest.removeValue(forKey: key)
                    }
                }
                
            }
            print("MRSKEE \(apiRouter.path)")
            let request = AF.request(apiRouter.path, method: apiRouter.method, parameters: parameterForRequest, encoding: apiRouter.encoding, headers: headers).responseJSON { (response:AFDataResponse<Any>) in
                    switch(response.result) {
                    case .success(let JSON):
                    
                        if let jsonArray = JSON as? [[String: Any]] {
                                
                        }else{
                            if let json = JSON as? [String: Any]{
                                completionHandler (json)
                            }
                        }
                       
                        break
                        
                    case .failure(let error):
                        failure(error)
                        break
                    }
                }
            return request
        }
        return nil
      
      
    }
    
    func httpRequestAPI2(_ apiRouter: ApiRouter,isHeader:Bool? = false, headerXtra: [String:String]? = nil,completionHandler: @escaping CompletionHandlerArray,failure:@escaping ErrorHandler)->DataRequest? {
        var headers = HTTPHeaders()
        if !isHeader! {
            headers["Accept"] = "application/json"
            headers["Content-Type"] = "application/x-www-form-urlencoded"
            
        }
//
        if let head = headerXtra {
            for (key,value) in head {
                headers[key] = value
            }
        }
        if var parameterForRequest = apiRouter.parameters {
            for (key,value) in parameterForRequest {
                if let realValue = value as? String {
                    if realValue == ""{
                        parameterForRequest.removeValue(forKey: key)
                    }
                }
            }
            print("MRSKEE \(apiRouter.path)")
            let request = AF.request(apiRouter.path, method: apiRouter.method, parameters: parameterForRequest, encoding: apiRouter.encoding, headers: headers).responseJSON { (response:AFDataResponse<Any>) in
                    switch(response.result) {
                    case .success(let JSON):
                        if let jsonArray = JSON as? [[String: Any]] {
                            completionHandler(jsonArray)
                        }
                        break
                        
                    case .failure(let error):
                        failure(error)
                        break
                    }
                }
            return request
        }
        return nil
      
      
    }
    
    func httpUploadFile(_ apiRouter: ApiRouter,isHeader:Bool? = false, headerXtra: [String:String]? = nil, medias: [MediaUploadFile], fileType: String, fileName: String, completionHandler: @escaping CompletionHandler,failure:@escaping ErrorHandler) {
        var headers = HTTPHeaders()
        if !isHeader! {
            headers["Accept"] = "application/json"
            headers["Content-Type"] = "multipart/form-data"
        }
        let url = URL(string: apiRouter.path)
        AF.upload(multipartFormData: { multiPart in
            if var head = apiRouter.parameters {
                for (key,value) in head {
                    if let realValue = value as? String {
                        if realValue == ""{
                            head.removeValue(forKey: key)
                        }else{
                            if let data = "\(realValue)".data(using: .utf8) {
                                multiPart.append(data, withName: key)
                            }
                        }
                    }else if let array = value as? [String] {
//                        let jsonData = try! JSONSerialization.data(withJSONObject: array)
//                        multiPart.append(jsonData, withName: key)
                        let count : Int  = array.count
                        for i in 0 ..< count{
                            let value = array[i]
                            let valueObj = String(value)
                            let keyObj = key + "[" + String(i) + "]"
                            multiPart.append(valueObj.data(using: String.Encoding.utf8)!, withName: keyObj)
                        }

                                           

                    }else if let arrayInt = value as? [Int]{
                        let jsonData = try! JSONSerialization.data(withJSONObject: arrayInt)
                        multiPart.append(jsonData, withName: key)
                    }
                }
            }
            print("File name size \(medias.count)")
            for media in medias {
                let fileName = NSUUID().uuidString
                print("File name \(fileName)")
                multiPart.append(media.data, withName: "filephoto[]", fileName: "filephoto\(fileName).png", mimeType: "image/png")
            }
//
        }, to: url!, method: apiRouter.method, headers: headers)
        .uploadProgress(closure: { progress in
            print("upload file progress \(progress)")
        })
        .responseJSON { response in
            switch response.result {
            case .success(let responseData):
                if let json = responseData as? [String: Any]{
                    completionHandler (json)
                }
            case .failure(let networkErr):
                failure(networkErr)
                break
            }
        }
    }
    
    func httpUploadFile(_ apiRouter: ApiRouter,isHeader:Bool? = false, headerXtra: [String:String]? = nil, file: Data, fileType: String, fileName: String,withName:String, completionHandler: @escaping CompletionHandler,failure:@escaping ErrorHandler) {
        var headers = HTTPHeaders()
        if !isHeader! {
            headers["Accept"] = "application/json"
            headers["Content-Type"] = "multipart/form-data"
        }
        var message = String()
        let url = URL(string: apiRouter.path)

        AF.upload(multipartFormData: { multiPart in
            if let head = apiRouter.parameters {
                for (key,value) in head {
                    if let array = value as? [String] {
                        let jsonData = try! JSONSerialization.data(withJSONObject: array)
                        multiPart.append(jsonData, withName: key)
                    }else if let arrayInt = value as? [Int]{
                        let jsonData = try! JSONSerialization.data(withJSONObject: arrayInt)
                        multiPart.append(jsonData, withName: key)
                    } else if let data = "\(value)".data(using: .utf8) {
                        multiPart.append(data, withName: key)
                    }
                }
            }
            let fileName = NSUUID().uuidString
            multiPart.append(file, withName: withName, fileName: "banner\(fileName).png", mimeType: "image/png")
        }, to: url!, method: apiRouter.method, headers: headers)
        .uploadProgress(closure: { progress in
            print("upload file progress \(progress)")
        })
        .responseJSON { response in
            switch response.result {
            case .success(let responseData):
                if let json = responseData as? [String: Any]{
                    completionHandler (json)
                }
            case .failure(let networkErr):
                failure(networkErr)
                break
            }
        }
    }
}
