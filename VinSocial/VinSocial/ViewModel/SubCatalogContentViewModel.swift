//
//  CatalogContentViewModel.swift
//  VinSocial
//
//  Created by Đinh Thái Sơn on 24/03/2023.
//

import Foundation
class SubCatalogContentViewModel :ObservableObject{
    @Published var subCatalogContent: SubCatalogContent
    
    init(_ subCatalogContent: SubCatalogContent) {
        self.subCatalogContent = subCatalogContent
    }
    
    var title: String{
        return subCatalogContent.title ?? ""
    }
    
    var image: String{
        return subCatalogContent.image ?? ""
    }
    
    var hometext: String {
        return subCatalogContent.hometext ?? ""
    }
    
    var infoText: String {
        return subCatalogContent.info_text ?? ""
    }
}
