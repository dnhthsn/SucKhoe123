//
//  NewFeedsForCatalog.swift
//  Suckhoe123
//
//  Created by Stealer Of Souls on 4/27/23.
//

import Foundation

//Dùng để cache data thôi.
//1 catalog -> nhiều feed.
class NewFeedsForCatalog: Identifiable {
    var id:UUID = UUID()
    var catid: String?
    var currentPage:Int = 1
    var shouldLoadNextPage:Bool = false
    var newFeed: [NewFeed]?
    
    init(catid: String? = nil, currentPage: Int, newFeed: [NewFeed]? = nil) {
        self.catid = catid
        self.currentPage = currentPage
        self.newFeed = newFeed
    }
}
