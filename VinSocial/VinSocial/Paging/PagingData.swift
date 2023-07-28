//
//  PagingData.swift
//  VinSocial
//
//  Created by Stealer Of Souls on 3/21/23.
//

import SwiftUI
import Foundation

actor PagingData {
    
    private(set) var currentPage = 0
    private(set) var hasReachedEnd = false
    
    let itemsPerPage: Int
//    let maxPageLimit: Int
    
    init(itemsPerPage: Int) {
//        assert(itemsPerPage > 0 && maxPageLimit > 0, "Items per page and max page limit must be greater than zero")
        assert(itemsPerPage > 0, "Items per page and max page limit must be greater than zero")
        
        self.itemsPerPage = itemsPerPage
//        self.maxPageLimit = maxPageLimit
    }
    
    var nextPage: Int { currentPage + 1 }
    var shouldLoadNextPage: Bool {
//        !hasReachedEnd && nextPage <= maxPageLimit
        !hasReachedEnd
    }
    
    func loadNextPage<T>(dataFetchProvider: @escaping (Int) async throws -> [T]) async throws -> [T] {
        if Task.isCancelled { return [] }
        print("PAGING: Current Page \(currentPage), next page: \(nextPage)")
        guard shouldLoadNextPage else {
            print("PAGING: Stop loading next page. Has Reached end: \(hasReachedEnd), next page: \(nextPage)")
            return []
        }
        
        let nextPage = self.nextPage
        let items = try await dataFetchProvider(nextPage)
        
        if Task.isCancelled || nextPage != self.nextPage { return [] }
        
        currentPage = nextPage
        hasReachedEnd = items.count < itemsPerPage
        
        print("PAGING: fetch \(items.count) items(s) successfully. Current Page: \(currentPage)")
        
        return items
    }
    
    func reset() {
        print("PAGING: RESET")
        currentPage = 0
        hasReachedEnd = false
    }
    
}
