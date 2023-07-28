//
//  DataFetchPhase.swift
//  VinSocial
//
//  Created by Stealer Of Souls on 3/21/23.
//

import Foundation

enum DataFetchPhase<T> {    
    case empty
    case success(T)
    case fetchingNextPage(T)
    case failure(Error)
    
    var value: T? {
        if case .success(let value) = self {
            return value
        } else if case .fetchingNextPage(let value) = self {
            return value
        }
        return nil
    }
    
}
