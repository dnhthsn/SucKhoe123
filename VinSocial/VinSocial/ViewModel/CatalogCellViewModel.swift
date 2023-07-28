//
//  SubCatalogViewModel.swift
//  VinSocial
//
//  Created by Đinh Thái Sơn on 24/03/2023.
//

import Foundation
class CatalogCellViewModel :ObservableObject{
    @Published var catalog: Catalog
    
    init(_ catalog: Catalog) {
        self.catalog = catalog
    }
    
    var grouptitle: String{
        return catalog.grouptitle ?? ""
    }
    
    var image: String{
        return catalog.image ?? ""
    }
    
    var getSubCatalog: [SubCatalog] {
        if catalog.subcatalog == nil {
            return []
        }
        
        guard var catalogs = catalog.subcatalog else {return []}
        return catalogs
    }
    
}

