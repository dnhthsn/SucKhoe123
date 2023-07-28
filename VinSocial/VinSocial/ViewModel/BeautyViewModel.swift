//
//  BeautyViewModel.swift
//  VinSocial
//
//  Created by Stealer Of Souls on 4/3/23.
//

import Foundation

//
//  MainTabViewModel.swift
//  Messenger
//
//  Created by Stealer Of Souls on 2/28/23.
//

import Foundation
import FirebaseDatabase
import Alamofire
@MainActor
class BeautyViewModel : ObservableObject{
    @Published var isLoadingPage = false
    @Published var phaseCatalog = DataFetchPhase<[Catalog]>.empty
    @Published var phaseSubCatalogContent = DataFetchPhase<[SubCatalogContent]>.empty
    @Published var topDoctors:[TopDoctor] = []
    @Published var listProvince:[ListProvince] = []
    @Published var listCatalogs: [ListCatalogConcerns] = []
    @Published var detailCatalogs: DetailCatalog?
    @Published var catalogNewsDetail: CatalogNewsDetail?
    @Published var catalogQuestionDetail: CatalogQuestionDetail?
    private(set) var currentPage = 0
    private(set) var hasReachedEnd = false
    private(set) var act = ""
    let itemsPerPage: Int = 3
    var nextPage: Int { currentPage + 1 }
    @Published var error: Error?
    @Published var showLoading: Bool = false
    
    var catalog :String = ""
    
    func initUserInfo(topDoctor: TopDoctor)->UserInfoRes{
        let userInfo = UserInfoRes(fullname: topDoctor.fullname ?? "", avatar: topDoctor.avatar ?? "")
        userInfo.fullname = topDoctor.fullname ?? ""
        userInfo.avatar = topDoctor.avatar ?? ""
        return userInfo
    }
    
    func initUserInfo2(item: CatalogSearch)->UserInfoRes{
        var userInfo = UserInfoRes(fullname: item.title ?? "", avatar: item.image ?? "")
        userInfo.fullname = item.title ?? ""
        userInfo.avatar = item.image ?? ""
        return userInfo
    }
    
    func initUserInfo1(catalogDoctor: CatalogDoctor)->UserInfoRes{
        var userInfo = UserInfoRes(fullname: catalogDoctor.fullname ?? "", avatar: catalogDoctor.avatar ?? "")
        userInfo.fullname = catalogDoctor.fullname ?? ""
        userInfo.avatar = catalogDoctor.avatar ?? ""
        return userInfo
    }
    
    func initSubCatalog(listCatalogs: ListCatalogConcerns)->SubCatalog{
        let subCatalog = SubCatalog(catalogid: listCatalogs.id ?? "", title: listCatalogs.title ?? "")
        subCatalog.catalogid = listCatalogs.id ?? ""
        subCatalog.title = listCatalogs.title ?? ""
        return subCatalog
    }
    
    func initSubCatalog1(item: CatalogConcernItem)->SubCatalog{
        let subCatalog = SubCatalog(catalogid: item.id ?? "", title: item.title ?? "")
        subCatalog.catalogid = item.id ?? ""
        subCatalog.title = item.title ?? ""
        return subCatalog
    }
    
    func initSubCatalog2(item: CatalogSearch)->SubCatalog{
        let subCatalog = SubCatalog(catalogid: item.id ?? "", title: item.title ?? "")
        subCatalog.catalogid = item.id ?? ""
        subCatalog.title = item.title ?? ""
        return subCatalog
    }
    
    func initCatalogVideo(item: CatalogSearch)->CatalogVideo{
        let catalogVideo = CatalogVideo(postid: item.id ?? "", image: item.image ?? "")
        catalogVideo.postid = item.id ?? ""
        catalogVideo.image = item.image ?? ""
        return catalogVideo
    }
    
    //***** Begin get catalog *****//
    
    //Catalog Doctor
    @Published var isLoadingPage1 = false
    @Published var phaseCatalogDoctor = DataFetchPhase<[CatalogDoctor]>.empty
    private(set) var currentPage1 = 0
    private(set) var hasReachedEnd1 = false
    let itemsPerPage1: Int = 3
    
    var nextPage1: Int { currentPage1 + 1 }
    
    var shouldLoadNextPage1: Bool {
        !hasReachedEnd1
    }
    
    func reset1() {
        currentPage1 = 0
        hasReachedEnd1 = false
    }
    
    var catalogDoctors: [CatalogDoctor] {
        phaseCatalogDoctor.value ?? []
    }
    
    var isFetchingNextPage1: Bool {
        if case .fetchingNextPage = phaseCatalogDoctor {
            return true
        }
        return false
    }
    
    func loadData1(category: String, catid: String, act: String, sortby: String){
        Task {await loadFirstPageCatalogDoctor(category:category, catid: catid,act: act,sortby: sortby)}
    }
    
    func removeCache1(){
        cacheSave.removeObject(forKey: "catalogDoctor")
        self.currentPage1 = 0
        self.hasReachedEnd1 = false
        self.phaseCatalogDoctor = .empty
        isLoadingPage1 = false
    }
    
    func loadFirstPageCatalogDoctor(category: String, catid: String, act: String, sortby: String) async {
        if Task.isCancelled { return }
        if let cachedData = cacheSave.object(forKey: "catalogDoctor"),
           let myDictionary = NSKeyedUnarchiver.unarchiveObject(with: cachedData as Data) as? [String:Any] {

            if let catalogDoctorResponse = ListResponseCatalogDoctor<CatalogDoctor>(JSON: myDictionary){
                guard let listCatalogDoctor = catalogDoctorResponse.data else{return}
                DispatchQueue.main.async {
                    self.phaseCatalogDoctor = .success(listCatalogDoctor)
                    self.currentPage1 = catalogDoctorResponse.currentPage
                    self.hasReachedEnd1 = catalogDoctorResponse.hasReachedEnd
                }
                return
            }
            
        }
        
        DispatchQueue.main.async {
            self.phaseCatalogDoctor = .empty
        }
        
        do {
            reset1()
            let page = nextPage1;
            _ = APIService.sharedInstance.httpRequestAPI(ApiRouter.catalogDoctor(categorty: category, catid: catid, act: act, page: page, sortby: sortby)){ response in
               if let catalogDoctorResponse = ListResponseCatalogDoctor<CatalogDoctor>(JSON: response){
                 if catalogDoctorResponse.status == 1 {
                       guard let listCatalogDoctor = catalogDoctorResponse.data else{return}

                       Task{

                           catalogDoctorResponse.currentPage = page
                           catalogDoctorResponse.hasReachedEnd = self.hasReachedEnd1
                           let json = catalogDoctorResponse.toJSON()
                           let data = try! NSKeyedArchiver.archivedData(withRootObject: json,requiringSecureCoding: false)
                           cacheSave.setObject(data as NSData, forKey: "catalogDoctor")
//                           }
                       }
                       if Task.isCancelled { return }
                     DispatchQueue.main.async {
                         self.phaseCatalogDoctor = .success(listCatalogDoctor)
                     }
                       
                   }else{
                       if Task.isCancelled { return }
                   }
                }
                self.currentPage1 = page
           } failure: { error in
               if Task.isCancelled { return }
               print(error.localizedDescription)
               self.phaseCatalogDoctor = .failure(error)
           }

        }
    }
    
    func loadNextPageCatalogDoctor(category: String, catid: String, act: String, sortby: String) async {
        if Task.isCancelled { return }
        DispatchQueue.main.async {
            let catalogDoctors = self.phaseCatalogDoctor.value ?? []
            self.phaseCatalogDoctor = .fetchingNextPage(catalogDoctors)
        }
        do {
            guard shouldLoadNextPage1 else {
                return
            }
            
            let pageNext = nextPage1
            
            _ = APIService.sharedInstance.httpRequestAPI(ApiRouter.catalogDoctor(categorty: category, catid: catid, act: act, page: pageNext, sortby: sortby)){ response in
               if let catalogDoctorResponse = ListResponseCatalogDoctor<CatalogDoctor>(JSON: response){
                   if catalogDoctorResponse.status == 1 {
                       guard let listCatalogDoctor = catalogDoctorResponse.data else{return}

                       if Task.isCancelled { return }
                      
                       DispatchQueue.main.async {
                           var catalogDoctors = self.phaseCatalogDoctor.value ?? []
                           catalogDoctors += listCatalogDoctor
                           self.phaseCatalogDoctor = .success(catalogDoctors)
                           self.currentPage1 = pageNext
                           self.hasReachedEnd1 = listCatalogDoctor.count < self.itemsPerPage1
                           
                           Task{
                               catalogDoctorResponse.data = catalogDoctors
                               catalogDoctorResponse.currentPage = self.currentPage1
                               catalogDoctorResponse.hasReachedEnd = self.hasReachedEnd1
                               let json = catalogDoctorResponse.toJSON()
                               let data = try! NSKeyedArchiver.archivedData(withRootObject: json,requiringSecureCoding: false)
                               cacheSave.setObject(data as NSData, forKey: "catalogDoctor")
                           }

                       }
                   }else{
                       if Task.isCancelled { return }
                   }
                }
           } failure: { error in
               if Task.isCancelled { return }
               print(error.localizedDescription)
               self.phaseCatalogDoctor = .failure(error)
           }

        }
       
    }
    
    //End catalog doctor
    
    //Catalog News
    @Published var isLoadingPageNews = false
    @Published var phaseCatalogNews = DataFetchPhase<[CatalogNews]>.empty
    private(set) var currentPageNews = 0
    private(set) var hasReachedEndNews = false
    let itemsPerPageNews: Int = 3
    
    var nextPageNews: Int { currentPageNews + 1 }
    
    var shouldLoadNextPageNews: Bool {
        !hasReachedEndNews
    }
    
    func resetNews() {
        currentPageNews = 0
        hasReachedEndNews = false
    }
    
    var catalogNews: [CatalogNews] {
        phaseCatalogNews.value ?? []
    }
    
    var isFetchingNextPageNews: Bool {
        if case .fetchingNextPage = phaseCatalogNews {
            return true
        }
        return false
    }
    
    func loadDataNews(category: String, catid: String, act: String){
        Task {await loadFirstPageCatalogNews(category:category, catid: catid,act: act)}
    }
    
    func removeCacheNews(){
        cacheSave.removeObject(forKey: "catalogNews")
        self.currentPageNews = 0
        self.hasReachedEndNews = false
        self.phaseCatalogNews = .empty
        isLoadingPageNews = false
    }
    
    func loadFirstPageCatalogNews(category: String, catid: String, act: String) async {
        if Task.isCancelled { return }
        if let cachedData = cacheSave.object(forKey: "catalogNews"),
           let myDictionary = NSKeyedUnarchiver.unarchiveObject(with: cachedData as Data) as? [String:Any] {

            if let catalogNewsResponse = ListResponseCatalogDoctor<CatalogNews>(JSON: myDictionary){
                guard let listCatalogNews = catalogNewsResponse.data else{return}
                DispatchQueue.main.async {
                    self.phaseCatalogNews = .success(listCatalogNews)
                    self.currentPageNews = catalogNewsResponse.currentPage
                    self.hasReachedEndNews = catalogNewsResponse.hasReachedEnd
                }
                return
            }
            
        }
        
        DispatchQueue.main.async {
            self.phaseCatalogNews = .empty
        }
        
        do {
            resetNews()
            let page = nextPageNews;
            _ = APIService.sharedInstance.httpRequestAPI(ApiRouter.catalogDoctor(categorty: category, catid: catid, act: act, page: page, sortby: "")){ response in
               if let catalogNewsResponse = ListResponseCatalogDoctor<CatalogNews>(JSON: response){
                 if catalogNewsResponse.status == 1 {
                       guard let listCatalogNews = catalogNewsResponse.data else{return}

                       Task{

                           catalogNewsResponse.currentPage = page
                           catalogNewsResponse.hasReachedEnd = self.hasReachedEndNews
                           let json = catalogNewsResponse.toJSON()
                           let data = try! NSKeyedArchiver.archivedData(withRootObject: json,requiringSecureCoding: false)
                           cacheSave.setObject(data as NSData, forKey: "catalogNews")
//                           }
                       }
                       if Task.isCancelled { return }
                     DispatchQueue.main.async {
                         self.phaseCatalogNews = .success(listCatalogNews)
                     }
                       
                   }else{
                       if Task.isCancelled { return }
                   }
                }
                self.currentPageNews = page
           } failure: { error in
               if Task.isCancelled { return }
               print(error.localizedDescription)
               self.phaseCatalogNews = .failure(error)
           }

        }
    }
    
    func loadNextPageCatalogNews(category: String, catid: String, act: String) async {
        if Task.isCancelled { return }
        DispatchQueue.main.async {
            let catalogNews = self.phaseCatalogNews.value ?? []
            self.phaseCatalogNews = .fetchingNextPage(catalogNews)
        }
        do {
            guard shouldLoadNextPageNews else {
                return
            }
            
            let pageNext = nextPageNews
            
            _ = APIService.sharedInstance.httpRequestAPI(ApiRouter.catalogDoctor(categorty: category, catid: catid, act: act, page: pageNext, sortby: "")){ response in
               if let catalogNewsResponse = ListResponseCatalogDoctor<CatalogNews>(JSON: response){
                   if catalogNewsResponse.status == 1 {
                       guard let listCatalogNews = catalogNewsResponse.data else{return}

                       if Task.isCancelled { return }
                      
                       DispatchQueue.main.async {
                           var catalogNews = self.phaseCatalogNews.value ?? []
                           catalogNews += listCatalogNews
                           self.phaseCatalogNews = .success(catalogNews)
                           self.currentPageNews = pageNext
                           self.hasReachedEndNews = listCatalogNews.count < self.itemsPerPageNews
                           
                           Task{
                               catalogNewsResponse.data = catalogNews
                               catalogNewsResponse.currentPage = self.currentPageNews
                               catalogNewsResponse.hasReachedEnd = self.hasReachedEndNews
                               let json = catalogNewsResponse.toJSON()
                               let data = try! NSKeyedArchiver.archivedData(withRootObject: json,requiringSecureCoding: false)
                               cacheSave.setObject(data as NSData, forKey: "catalogNews")
                           }

                       }
                   }else{
                       if Task.isCancelled { return }
                   }
                }
           } failure: { error in
               if Task.isCancelled { return }
               print(error.localizedDescription)
               self.phaseCatalogNews = .failure(error)
           }

        }
       
    }
    //End Catalog News
    
    
    //Catalog Question
    @Published var isLoadingPageQuestion = false
    @Published var phaseCatalogQuestion = DataFetchPhase<[CatalogQuestion]>.empty
    private(set) var currentPageQuestion = 0
    private(set) var hasReachedEndQuestion = false
    let itemsPerPageQuestion: Int = 3
    
    var nextPageQuestion: Int { currentPageQuestion + 1 }
    
    var shouldLoadNextPageQuestion: Bool {
        !hasReachedEndQuestion
    }
    
    func resetQuestion() {
        currentPageQuestion = 0
        hasReachedEndQuestion = false
    }
    
    var catalogQuestion: [CatalogQuestion] {
        phaseCatalogQuestion.value ?? []
    }
    
    var isFetchingNextPageQuestion: Bool {
        if case .fetchingNextPage = phaseCatalogQuestion {
            return true
        }
        return false
    }
    
    func loadDataQuestion(category: String, catid: String, act: String, sortby: String){
        Task {await loadFirstPageCatalogQuestion(category:category, catid: catid,act: act, sortby: sortby)}
    }
    
    func removeCacheQuestion(){
        cacheSave.removeObject(forKey: "catalogQuestion")
        self.currentPageQuestion = 0
        self.hasReachedEndQuestion = false
        self.phaseCatalogQuestion = .empty
        isLoadingPageQuestion = false
    }
    
    func loadFirstPageCatalogQuestion(category: String, catid: String, act: String, sortby: String) async {
        if Task.isCancelled { return }
        if let cachedData = cacheSave.object(forKey: "catalogQuestion"),
           let myDictionary = NSKeyedUnarchiver.unarchiveObject(with: cachedData as Data) as? [String:Any] {

            if let catalogQuestionResponse = ListResponseCatalogDoctor<CatalogQuestion>(JSON: myDictionary){
                guard let listCatalogQuestion = catalogQuestionResponse.data else{return}
                DispatchQueue.main.async {
                    self.phaseCatalogQuestion = .success(listCatalogQuestion)
                    self.currentPageQuestion = catalogQuestionResponse.currentPage
                    self.hasReachedEndQuestion = catalogQuestionResponse.hasReachedEnd
                }
                return
            }
            
        }
        
        DispatchQueue.main.async {
            self.phaseCatalogQuestion = .empty
        }
        
        do {
            resetQuestion()
            let page = nextPageQuestion;
            _ = APIService.sharedInstance.httpRequestAPI(ApiRouter.catalogDoctor(categorty: category, catid: catid, act: act, page: page, sortby: sortby)){ response in
               if let catalogQuestionResponse = ListResponseCatalogDoctor<CatalogQuestion>(JSON: response){
                 if catalogQuestionResponse.status == 1 {
                       guard let listCatalogQuestion = catalogQuestionResponse.data else{return}

                       Task{

                           catalogQuestionResponse.currentPage = page
                           catalogQuestionResponse.hasReachedEnd = self.hasReachedEndQuestion
                           let json = catalogQuestionResponse.toJSON()
                           let data = try! NSKeyedArchiver.archivedData(withRootObject: json,requiringSecureCoding: false)
                           cacheSave.setObject(data as NSData, forKey: "catalogQuestion")
//                           }
                       }
                       if Task.isCancelled { return }
                     DispatchQueue.main.async {
                         self.phaseCatalogQuestion = .success(listCatalogQuestion)
                     }
                       
                   }else{
                       if Task.isCancelled { return }
                   }
                }
                self.currentPageQuestion = page
           } failure: { error in
               if Task.isCancelled { return }
               print(error.localizedDescription)
               self.phaseCatalogQuestion = .failure(error)
           }

        }
    }
    
    func loadNextPageCatalogQuestion(category: String, catid: String, act: String, sortby: String) async {
        if Task.isCancelled { return }
        DispatchQueue.main.async {
            let catalogQuestion = self.phaseCatalogQuestion.value ?? []
            self.phaseCatalogQuestion = .fetchingNextPage(catalogQuestion)
        }
        do {
            guard shouldLoadNextPageQuestion else {
                return
            }
            
            let pageNext = nextPageQuestion
            
            _ = APIService.sharedInstance.httpRequestAPI(ApiRouter.catalogDoctor(categorty: category, catid: catid, act: act, page: pageNext, sortby: sortby)){ response in
               if let catalogQuestionResponse = ListResponseCatalogDoctor<CatalogQuestion>(JSON: response){
                   if catalogQuestionResponse.status == 1 {
                       guard let listCatalogQuestion = catalogQuestionResponse.data else{return}

                       if Task.isCancelled { return }
                      
                       DispatchQueue.main.async {
                           var catalogQuestion = self.phaseCatalogQuestion.value ?? []
                           catalogQuestion += listCatalogQuestion
                           self.phaseCatalogQuestion = .success(catalogQuestion)
                           self.currentPageQuestion = pageNext
                           self.hasReachedEndQuestion = listCatalogQuestion.count < self.itemsPerPageQuestion
                           
                           Task{
                               catalogQuestionResponse.data = catalogQuestion
                               catalogQuestionResponse.currentPage = self.currentPageQuestion
                               catalogQuestionResponse.hasReachedEnd = self.hasReachedEndQuestion
                               let json = catalogQuestionResponse.toJSON()
                               let data = try! NSKeyedArchiver.archivedData(withRootObject: json,requiringSecureCoding: false)
                               cacheSave.setObject(data as NSData, forKey: "catalogQuestion")
                           }

                       }
                   }else{
                       if Task.isCancelled { return }
                   }
                }
           } failure: { error in
               if Task.isCancelled { return }
               print(error.localizedDescription)
               self.phaseCatalogQuestion = .failure(error)
           }

        }
       
    }
    //End Catalog Question
    
    //Catalog Image
    @Published var isLoadingPageImage = false
    @Published var phaseCatalogImage = DataFetchPhase<[CatalogImage]>.empty
    private(set) var currentPageImage = 0
    private(set) var hasReachedEndImage = false
    let itemsPerPageImage: Int = 3
    
    var nextPageImage: Int { currentPageImage + 1 }
    
    var shouldLoadNextPageImage: Bool {
        !hasReachedEndImage
    }
    
    func resetImage() {
        currentPageImage = 0
        hasReachedEndImage = false
    }
    
    var catalogImage: [CatalogImage] {
        phaseCatalogImage.value ?? []
    }
    
    var isFetchingNextPageImage: Bool {
        if case .fetchingNextPage = phaseCatalogImage {
            return true
        }
        return false
    }
    
    func loadDataImage(category: String, catid: String, act: String, sortby: String){
        Task {await loadFirstPageCatalogImage(category:category, catid: catid,act: act, sortby: sortby)}
    }
    
    func removeCacheImage(){
        cacheSave.removeObject(forKey: "catalogImage")
        self.currentPageImage = 0
        self.hasReachedEndImage = false
        self.phaseCatalogImage = .empty
        isLoadingPageImage = false
    }
    
    func loadFirstPageCatalogImage(category: String, catid: String, act: String, sortby: String) async {
        if Task.isCancelled { return }
        if let cachedData = cacheSave.object(forKey: "catalogImage"),
           let myDictionary = NSKeyedUnarchiver.unarchiveObject(with: cachedData as Data) as? [String:Any] {

            if let catalogImageResponse = ListResponseCatalogDoctor<CatalogImage>(JSON: myDictionary){
                guard let listCatalogImage = catalogImageResponse.data else{return}
                DispatchQueue.main.async {
                    self.phaseCatalogImage = .success(listCatalogImage)
                    self.currentPageImage = catalogImageResponse.currentPage
                    self.hasReachedEndImage = catalogImageResponse.hasReachedEnd
                }
                return
            }
            
        }
        
        DispatchQueue.main.async {
            self.phaseCatalogImage = .empty
        }
        
        do {
            resetImage()
            let page = nextPageImage;
            _ = APIService.sharedInstance.httpRequestAPI(ApiRouter.catalogDoctor(categorty: category, catid: catid, act: act, page: page, sortby: sortby)){ response in
               if let catalogImageResponse = ListResponseCatalogDoctor<CatalogImage>(JSON: response){
                 if catalogImageResponse.status == 1 {
                       guard let listCatalogImage = catalogImageResponse.data else{return}
                        let filtered = listCatalogImage.filter { ($0.image != "") }
                       Task{

                           catalogImageResponse.currentPage = page
                           catalogImageResponse.hasReachedEnd = self.hasReachedEndImage
                           let json = catalogImageResponse.toJSON()
                           let data = try! NSKeyedArchiver.archivedData(withRootObject: json,requiringSecureCoding: false)
                           cacheSave.setObject(data as NSData, forKey: "catalogImage")
//                           }
                       }
                       if Task.isCancelled { return }
                     DispatchQueue.main.async {
                         self.phaseCatalogImage = .success(filtered)
                     }
                       
                   }else{
                       if Task.isCancelled { return }
                   }
                }
                self.currentPageImage = page
           } failure: { error in
               if Task.isCancelled { return }
               print(error.localizedDescription)
               self.phaseCatalogImage = .failure(error)
           }

        }
    }
    
    func loadNextPageCatalogImage(category: String, catid: String, act: String, sortby: String) async {
        if Task.isCancelled { return }
        DispatchQueue.main.async {
            let catalogImage = self.phaseCatalogImage.value ?? []
            self.phaseCatalogImage = .fetchingNextPage(catalogImage)
        }
        do {
            guard shouldLoadNextPageImage else {
                return
            }
            
            let pageNext = nextPageImage
            
            _ = APIService.sharedInstance.httpRequestAPI(ApiRouter.catalogDoctor(categorty: category, catid: catid, act: act, page: pageNext, sortby: sortby)){ response in
               if let catalogImageResponse = ListResponseCatalogDoctor<CatalogImage>(JSON: response){
                   if catalogImageResponse.status == 1 {
                       guard let listCatalogImage = catalogImageResponse.data else{return}
                       let filtered = listCatalogImage.filter { ($0.image != "") }
                       if Task.isCancelled { return }
                      
                       DispatchQueue.main.async {
                           var catalogImage = self.phaseCatalogImage.value ?? []
                           catalogImage += filtered
                           self.phaseCatalogImage = .success(catalogImage)
                           self.currentPageImage = pageNext
                           self.hasReachedEndImage = listCatalogImage.count < self.itemsPerPageImage
                           
                           Task{
                               catalogImageResponse.data = catalogImage
                               catalogImageResponse.currentPage = self.currentPageImage
                               catalogImageResponse.hasReachedEnd = self.hasReachedEndImage
                               let json = catalogImageResponse.toJSON()
                               let data = try! NSKeyedArchiver.archivedData(withRootObject: json,requiringSecureCoding: false)
                               cacheSave.setObject(data as NSData, forKey: "catalogImage")
                           }

                       }
                   }else{
                       if Task.isCancelled { return }
                   }
                }
           } failure: { error in
               if Task.isCancelled { return }
               print(error.localizedDescription)
               self.phaseCatalogImage = .failure(error)
           }

        }
       
    }
    //End Catalog Image
    
    //Catalog Video
    @Published var isLoadingPageVideo = false
    @Published var phaseCatalogVideo = DataFetchPhase<[CatalogVideo]>.empty
    private(set) var currentPageVideo = 0
    private(set) var hasReachedEndVideo = false
    let itemsPerPageVideo: Int = 3
    
    var nextPageVideo: Int { currentPageVideo + 1 }
    
    var shouldLoadNextPageVideo: Bool {
        !hasReachedEndVideo
    }
    
    func resetVideo() {
        currentPageVideo = 0
        hasReachedEndVideo = false
    }
    
    var catalogVideo: [CatalogVideo] {
        phaseCatalogVideo.value ?? []
    }
    
    var isFetchingNextPageVideo: Bool {
        if case .fetchingNextPage = phaseCatalogVideo {
            return true
        }
        return false
    }
    
    func loadDataVideo(category: String, catid: String, act: String, sortby: String){
        Task {await loadFirstPageCatalogVideo(category:category, catid: catid,act: act, sortby: sortby)}
    }
    
    func removeCacheVideo(){
        cacheSave.removeObject(forKey: "catalogVideo")
        self.currentPageVideo = 0
        self.hasReachedEndVideo = false
        self.phaseCatalogVideo = .empty
        isLoadingPageVideo = false
    }
    
    func loadFirstPageCatalogVideo(category: String, catid: String, act: String, sortby: String) async {
        if Task.isCancelled { return }
        if let cachedData = cacheSave.object(forKey: "catalogVideo"),
           let myDictionary = NSKeyedUnarchiver.unarchiveObject(with: cachedData as Data) as? [String:Any] {

            if let catalogVideoResponse = ListResponseCatalogDoctor<CatalogVideo>(JSON: myDictionary){
                guard let listCatalogVideo = catalogVideoResponse.data else{return}
                DispatchQueue.main.async {
                    self.phaseCatalogVideo = .success(listCatalogVideo)
                    self.currentPageVideo = catalogVideoResponse.currentPage
                    self.hasReachedEndVideo = catalogVideoResponse.hasReachedEnd
                }
                return
            }
            
        }
        
        DispatchQueue.main.async {
            self.phaseCatalogVideo = .empty
        }
        
        do {
            resetVideo()
            let page = nextPageVideo;
            _ = APIService.sharedInstance.httpRequestAPI(ApiRouter.catalogDoctor(categorty: category, catid: catid, act: act, page: page, sortby: sortby)){ response in
               if let catalogVideoResponse = ListResponseCatalogDoctor<CatalogVideo>(JSON: response){
                 if catalogVideoResponse.status == 1 {
                       guard let listCatalogVideo = catalogVideoResponse.data else{return}
                     let filtered = listCatalogVideo.filter { ($0.urlvideo != "") }
                       Task{

                           catalogVideoResponse.currentPage = page
                           catalogVideoResponse.hasReachedEnd = self.hasReachedEndVideo
                           let json = catalogVideoResponse.toJSON()
                           let data = try! NSKeyedArchiver.archivedData(withRootObject: json,requiringSecureCoding: false)
                           cacheSave.setObject(data as NSData, forKey: "catalogVideo")
//                           }
                       }
                       if Task.isCancelled { return }
                       self.phaseCatalogVideo = .success(filtered)
                   }else{
                       if Task.isCancelled { return }
                   }
                }
                self.currentPageVideo = page
           } failure: { error in
               if Task.isCancelled { return }
               print(error.localizedDescription)
               self.phaseCatalogVideo = .failure(error)
           }

        }
    }
    
    func loadNextPageCatalogVideo(category: String, catid: String, act: String, sortby: String) async {
        if Task.isCancelled { return }
        DispatchQueue.main.async {
            let catalogVideo = self.phaseCatalogVideo.value ?? []
            self.phaseCatalogVideo = .fetchingNextPage(catalogVideo)
        }
        do {
            guard shouldLoadNextPageVideo else {
                return
            }
            
            let pageNext = nextPageVideo
            
            _ = APIService.sharedInstance.httpRequestAPI(ApiRouter.catalogDoctor(categorty: category, catid: catid, act: act, page: pageNext, sortby: sortby)){ response in
               if let catalogVideoResponse = ListResponseCatalogDoctor<CatalogVideo>(JSON: response){
                   if catalogVideoResponse.status == 1 {
                       guard let listCatalogVideo = catalogVideoResponse.data else{return}
                       let filtered = listCatalogVideo.filter { ($0.urlvideo != "") }
                       if Task.isCancelled { return }
                      
                       DispatchQueue.main.async {
                           var catalogVideo = self.phaseCatalogVideo.value ?? []
                           catalogVideo += filtered
                           self.phaseCatalogVideo = .success(catalogVideo)
                           self.currentPageVideo = pageNext
                           self.hasReachedEndVideo = listCatalogVideo.count < self.itemsPerPageVideo
                           
                           Task{
                               catalogVideoResponse.data = catalogVideo
                               catalogVideoResponse.currentPage = self.currentPageVideo
                               catalogVideoResponse.hasReachedEnd = self.hasReachedEndVideo
                               let json = catalogVideoResponse.toJSON()
                               let data = try! NSKeyedArchiver.archivedData(withRootObject: json,requiringSecureCoding: false)
                               cacheSave.setObject(data as NSData, forKey: "catalogVideo")
                           }

                       }
                   }else{
                       if Task.isCancelled { return }
                   }
                }
           } failure: { error in
               if Task.isCancelled { return }
               print(error.localizedDescription)
               self.phaseCatalogVideo = .failure(error)
           }

        }
       
    }
    //End catalog video
    
    //***** End get catalog *****//
    
    init(catalog:String) {
        self.catalog = catalog
        Task {await loadCatalog()}
    }
    
    var shouldLoadNextPage: Bool {
//        !hasReachedEnd && nextPage <= maxPageLimit
        !hasReachedEnd
    }

    func reset() {
        print("PAGING: RESET")
        currentPage = 0
        hasReachedEnd = false
    }

    
    var catalogs: [Catalog] {
        phaseCatalog.value ?? []
    }
    
    var subCatalogContent: [SubCatalogContent] {
        phaseSubCatalogContent.value ?? []
    }
    
    //Load catalog này phải dùng cache -> đã load rồi thì không load lại nữa. trừ khi user gọi refresh
    func loadCatalog() async {
        if Task.isCancelled { return }
        //Load từ cache ra trước nếu có rồi thì thôi không call api nữa.
        
        if let cachedData = cacheSave.object(forKey: NSString(string: self.catalog)),
           let myDictionary = NSKeyedUnarchiver.unarchiveObject(with: cachedData as Data) as? [String:Any] {
//           let myDictionary = try? NSKeyedUnarchiver.unarchivedObject(ofClass: NSDictionary.self, from: cachedData as Data) as? [String: Any] {
            if let catalogResponse = ListResponseCatalogDoctor<Catalog>(JSON: myDictionary){
                guard let listCatalog = catalogResponse.data else{return}
                DispatchQueue.main.async {
                    self.phaseCatalog = .success(listCatalog)
                }
                print("HOINX loadCatalog from cache")
                return
            }
        }
        do {
            reset()
            _ = APIService.sharedInstance.httpRequestAPI(ApiRouter.getCatalog(act: catalog, catalogid: "")){ response in
               if let catalogResponse = ListResponseCatalogDoctor<Catalog>(JSON: response){
                   if catalogResponse.status == 1 {
                       guard let listCatalog = catalogResponse.data else{return}
                       
                       if Task.isCancelled { return }
                       DispatchQueue.main.async {
                           self.phaseCatalog = .success(listCatalog)
                       }
                       Task{
                           let json = catalogResponse.toJSON()
                           let data = try! NSKeyedArchiver.archivedData(withRootObject: json,requiringSecureCoding: false)
                           cacheSave.setObject(data as NSData, forKey: NSString(string: self.catalog))
                       }
                     
                   }else{
                       print("Error get catalog")
                       if Task.isCancelled { return }
                   }
                }
           } failure: { error in
               if Task.isCancelled { return }
               print("Error get catalog: \(error.localizedDescription)")
               self.phaseCatalog = .failure(error)
           }

        }
    }
    
    func loadSubCatalogContent(catalogid: String) async {
        if Task.isCancelled { return }
        do {
            reset()
            let _ = APIService.sharedInstance.httpRequestAPI(ApiRouter.getCatalog(act: "lam-dep", catalogid: catalogid)){ response in
               if let catalogResponse = BaseListResponse<SubCatalogContent>(JSON: response){
                   if catalogResponse.status == 1 {
                       guard let listCatalog = catalogResponse.data else{return}
                       
                       if Task.isCancelled { return }
                       self.phaseSubCatalogContent = .success(listCatalog)
                   }else{
                       print("Error loggin==== 4 ")
                       if Task.isCancelled { return }
                   }
                }
           } failure: { error in
               if Task.isCancelled { return }
               print(error.localizedDescription)
               self.phaseSubCatalogContent = .failure(error)
           }

        }
    }
    
    func topDoctor(act: String) {
        if let cachedData = cacheSave.object(forKey: NSString(string: "top-doctor-"+act)),
           let myDictionary = NSKeyedUnarchiver.unarchiveObject(with: cachedData as Data) as? [String:Any] {
//           let myDictionary = try? NSKeyedUnarchiver.unarchivedObject(ofClass: NSDictionary.self, from: cachedData as Data) as? [String: Any] {
            if let topDoctorResponse = ListResponseCatalogDoctor<TopDoctor>(JSON: myDictionary){
                guard let listTopDoctor = topDoctorResponse.data else{return}
                DispatchQueue.main.async {
                    self.topDoctors.append(contentsOf: listTopDoctor)
                }
                print("HOINX topDoctor from cache")
                return
            }
        }
        self.topDoctors.removeAll()
        _ = APIService.sharedInstance.httpRequestAPI(ApiRouter.topDoctor(act: act)) { response in
            if let topDoctorResponse = ListResponseCatalogDoctor<TopDoctor>(JSON: response){
                if topDoctorResponse.status == 1 {
                    guard let listTopDoctor = topDoctorResponse.data else{return}
                    DispatchQueue.main.async {
                        self.topDoctors.append(contentsOf: listTopDoctor)
                    }
                    Task{
                        let json = topDoctorResponse.toJSON()
                        let data = try! NSKeyedArchiver.archivedData(withRootObject: json,requiringSecureCoding: false)
                        cacheSave.setObject(data as NSData, forKey: NSString(string: "top-doctor-"+act))
                    }
                }else{
                   
                }
             }
        } failure: { error in
            self.error = self.generateError(description: error.localizedDescription,"topdoctor")
        }
    }
    
    func listCatalog(act: String) {
        if let cachedData = cacheSave.object(forKey: NSString(string: "listCatalog-"+act)),
           let myDictionary = NSKeyedUnarchiver.unarchiveObject(with: cachedData as Data) as? [String:Any] {
            if let listCatalogsResponse = ListResponseCatalogDoctor<ListCatalogConcerns>(JSON: myDictionary){
                guard let listCatalogs = listCatalogsResponse.data else{return}
                DispatchQueue.main.async {
                    self.listCatalogs = listCatalogs
                }
                print("HOINX listCatalog from cache")
                return
            }
        }
        _ = APIService.sharedInstance.httpRequestAPI(ApiRouter.listCatalog(act: act)) { response in
            if let listCatalogsResponse = ListResponseCatalogDoctor<ListCatalogConcerns>(JSON: response) {
                if listCatalogsResponse.status == 1 {
                    guard let listCatalogs = listCatalogsResponse.data else{return}
                    self.listCatalogs = listCatalogs
                    Task{
                        let json = listCatalogsResponse.toJSON()
                        let data = try! NSKeyedArchiver.archivedData(withRootObject: json,requiringSecureCoding: false)
                        cacheSave.setObject(data as NSData, forKey: NSString(string: "listCatalog-"+act))
                    }
                } else {
                    
                }
            }
        } failure: { error in
            self.error = self.generateError(description: error.localizedDescription,"listcatalog")
        }
    }
    
    func alphabetSections() -> [String] {
        let alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        return alphabet.map { String($0) }
    }

    func filteredData(for section: String,listCatalogs:[ListCatalogConcerns]) -> [ListCatalogConcerns] {
        return listCatalogs.filter { ($0.title != nil && $0.title!.hasPrefix(section)) }
    }
    
    func detailCatalog(category: String, catid: String) {
        _ = APIService.sharedInstance.httpRequestAPI(ApiRouter.detailCatalog(categorty: category, catid: catid)) { response in
            if let detailCatalogsResponse = BaseResponse<DetailCatalog>(JSON: response) {
                if detailCatalogsResponse.status == 1 {
                    guard let detailCatalogs = detailCatalogsResponse.data else{return}
                    self.detailCatalogs = detailCatalogs
                } else {
                    
                }
            }
        } failure: { error in
            self.error = self.generateError(description: error.localizedDescription,"detailCatalog")
        }
    }
    
    func catalogNewsDetail(category: String, postid: String, act: String) {
        self.showLoading = true
        _ = APIService.sharedInstance.httpRequestAPI(ApiRouter.catalogNewsDetail(category: category, postid: postid, act: act)) { response in
            if let catalogNewsDetailResponse = BaseResponse<CatalogNewsDetail>(JSON: response) {
                if catalogNewsDetailResponse.status == 1 {
                    guard let catalogNewsDetail = catalogNewsDetailResponse.data else{return}
                    self.catalogNewsDetail = catalogNewsDetail
                    self.showLoading = false
                } else {
                    self.showLoading = false
                }
            }
        } failure: { error in
            self.error = self.generateError(description: error.localizedDescription,"detailCatalog")
            self.showLoading = false
        }
    }
    
    func catalogQuestionDetail(category: String, postid: String, act: String) {
        self.showLoading = true
        _ = APIService.sharedInstance.httpRequestAPI(ApiRouter.catalogNewsDetail(category: category, postid: postid, act: act)) { response in
            if let catalogQuestionDetailResponse = BaseResponse<CatalogQuestionDetail>(JSON: response) {
                if catalogQuestionDetailResponse.status == 1 {
                    guard let catalogQuestionDetail = catalogQuestionDetailResponse.data else{return}
                    self.catalogQuestionDetail = catalogQuestionDetail
                    self.showLoading = false
                } else {
                    self.showLoading = false
                }
            }
        } failure: { error in
            self.error = self.generateError(description: error.localizedDescription,"detailCatalog")
            self.showLoading = false
        }
    }

    func listProvine() {
        _ = APIService.sharedInstance.httpRequestAPI(ApiRouter.listProvince) { response in
            if let listProvinceResponse = ListResponseCatalogDoctor<ListProvince>(JSON: response){
                if listProvinceResponse.status == 1 {
                    guard let listProvince = listProvinceResponse.data else{return}
                    self.listProvince = listProvince
//                    for province in listProvince {
//                        DispatchQueue.main.async {
//                            self.listProvince.append(province)
//                        }
//
//                    }
                }else{
                   
                }
             }
        } failure: { error in
            self.error = self.generateError(description: error.localizedDescription,"listprovince")
        }
    }
    
    func loadCatalogConcernDetail(act: String, catalogid: String, completion: @escaping ([CatalogConcernItem]) ->Void) {
        _ = APIService.sharedInstance.httpRequestAPI(ApiRouter.getCatalog(act: act, catalogid: catalogid)) { response in
            if let concernItemResponse = BaseListResponse<CatalogConcernItem>(JSON: response) {
                if concernItemResponse.status == 1 {
                    let concernItem = concernItemResponse.data
                    completion(concernItem!)
                }
            }
        } failure: { error in
            self.error = self.generateError(description: error.localizedDescription,"concern_item")
        }
    }
    
    @Published var isAsked = false
    @Published var messageAsk = ""
    @Published var askLoading = false
    func catalogAsk(act: String, title: String, content: String, catid: String, province: String ,data:[MediaUploadFile]) {
        guard let userID = AuthenViewModel.shared.currentUser?.userid else{return}
        guard let checknum = AuthenViewModel.shared.currentUser?.checknum else{return}
        self.askLoading = true
        APIService.sharedInstance.httpUploadFile(ApiRouter.catalogAsk(userid: userID, checknum: checknum, act: act, title: title, content: content, catid: catid, province: province), medias: data, fileType: "", fileName: "") { response in
            if let responseUploadFile = BaseResponse<UserCatalogQuestion>(JSON: response){
                if responseUploadFile.status == 1{
                    // sucess
                    if let userCatalogQuestion = responseUploadFile.data{
                        print("Ask Success")
                        self.isAsked = true
                        self.askLoading = false
                    }
                }else {
                    //error
                    self.generateError(description: "Error catalogAsk with status \(String(describing: responseUploadFile.status))", "catalogAsk")
                    self.isAsked = false
                    self.messageAsk = responseUploadFile.message ?? ""
                    self.askLoading = false
                }
                
            }
        } failure: { error in
            self.isAsked = false
            self.error = self.generateError(description: error.localizedDescription,"catalogAsk")
            print("error catalogAsk")
            self.messageAsk = "error catalogAsk"
            self.askLoading = false
        }
    }
    
    @Published var catalogSearch:[CatalogSearch] = []
    @Published var isCancelSearch = false
    private var currentPageSearch = 1
    @Published var isLoadingSearchPage = false
    @Published var dataTotalSearch = ""
    private var request: DataRequest?
    func searchCatalog(mod: String, showsuggest: String, keyword:String){
        isLoadingSearchPage = true
        request = APIService.sharedInstance.httpRequestAPI(ApiRouter.searchMod(mod: mod, showsuggest: showsuggest, keyword: keyword, page: currentPageSearch)) { response in
            if let catalogSearchResponse = ResponseSearchCatalog<CatalogSearch>(JSON: response){
                if catalogSearchResponse.status == 1 {
                    guard let listCatalogSearch = catalogSearchResponse.data else{return}
                    self.dataTotalSearch = catalogSearchResponse.datatotal ?? ""
                    if self.isCancelSearch {
                        self.isCancelSearch = false
                    }else{
                        for catalogSearch in listCatalogSearch {
                            if let index = self.catalogSearch.firstIndex(where: { ($0.id ?? "") ==
                                (catalogSearch.id ?? "")}) {
                                self.catalogSearch[index] = catalogSearch
                            }else{
                                self.catalogSearch.append(catalogSearch)
                            }
                        }
                        self.isLoadingSearchPage = false

                    }
                }else{
                   
                }
             }
        } failure: { error in
            self.error = self.generateError(description: error.localizedDescription,"SearchFeed")
        }
    }

    func clearSearch(){
        catalogSearch.removeAll(keepingCapacity: false)
        isLoadingSearchPage = false
        isCancelSearch = true
        if request != nil{
            request?.cancel()
            request = nil
        }
//        newFeedSearchs.removeAll()
    }
    
    private func generateError(code: Int = 0, description: String,_ domain:String) -> Error {
        NSError(domain: domain, code: code, userInfo: [NSLocalizedDescriptionKey: description])
    }
}
