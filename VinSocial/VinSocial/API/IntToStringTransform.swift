//
//  IntToStringTransform.swift
//  Suckhoe123
//
//  Created by Mrskee on 16/07/2023.
//

import ObjectMapper

class IntToStringTransform: TransformType {
    typealias Object = String
    typealias JSON = Int

    func transformFromJSON(_ value: Any?) -> String? {
        if let intValue = value as? Int {
            return String(intValue)
        }
        if let intValue = value as? String {
            return intValue
        }
        return nil
    }

    func transformToJSON(_ value: String?) -> Int? {
        if let stringValue = value {
            return Int(stringValue)
        }
        return nil
    }
}

