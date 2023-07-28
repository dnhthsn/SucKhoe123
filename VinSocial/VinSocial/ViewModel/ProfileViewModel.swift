//
//  ProfileViewModel.swift
//  VinSocial
//
//  Created by Stealer Of Souls on 3/27/23.
//

import Foundation

class ProfileViewModel: ObservableObject{
    @Published var isLoadingPage = false
    @Published var phase = DataFetchPhase<[NewFeed]>.empty
    @Published var friends = [UserInfoRes]()
    @Published var userDetailInfo:UserInfoRes?
    @Published var expertDetail: ExpertDetail?
    private(set) var currentPage = 0
    private(set) var hasReachedEnd = false
    let itemsPerPage: Int = 5
    private let cache = InMemoryCache<[NewFeed]>(expirationInterval: 5 * 60)
    
    var currentUserId: String = ""
    
//    func initExpertDetail(userInfo: UserInfo?)->ExpertDetail?{
//        let expertDetail = ExpertDetail(fullname: userInfo?.fullname ?? "", avatar: userInfo?.avatar ?? "")
//        expertDetail.fullname = userInfo?.fullname ?? ""
//        expertDetail.avatar = userInfo?.avatar ?? ""
//        return expertDetail
//    }
    
    init(currentUserId:String,userDetailInfo:UserInfoRes?, _ logingTest:String){
        print("TAGGG Init profileviewmodel from \(logingTest)")
        self.currentUserId = currentUserId
        self.userDetailInfo = userDetailInfo
        if ((currentUserId != "" && currentUserId != AuthenViewModel.shared.currentUser?.userid) || self.userDetailInfo == nil){
            getUinfo(profileid: currentUserId)
        }
            
    }
    
    func getUinfo(profileid: String){
        guard let userID = AuthenViewModel.shared.currentUser?.userid else{return}
        guard let checknum = AuthenViewModel.shared.currentUser?.checknum else{return}
        print("getUinfo \(userID) \(profileid)")
        _ = APIService.sharedInstance.httpRequestAPI(ApiRouter.getUinfo(userid: userID, checknum: checknum, profileid: profileid)) { response in
            if let infoResponse = BaseResponse<UserInfoRes>(JSON: response){
                DispatchQueue.main.async {
                    if infoResponse.status == 1 {
                        self.userDetailInfo = infoResponse.data;
                        AuthenViewModel.shared.userDetailInfo = infoResponse.data
                    }else{
                        print("Error loggin==== 2")
                    }
                }

               
            }else{
                print("Erro")
            }
        } failure: { error in
            
            
        }
    }
    
    
    var nextPage: Int { currentPage + 1 }
    var shouldLoadNextPage: Bool {
        !hasReachedEnd
    }
    
    func reset() {
        print("PAGING: RESET")
        currentPage = 0
        hasReachedEnd = false
    }
    
    var newFeeds: [NewFeed] {
        phase.value ?? []
    }
    
    var isFetchingNextPage: Bool {
        if case .fetchingNextPage = phase {
            return true
        }
        return false
    }
    /*
     pageuserid -> là user mình cần xem profile
     */
    func loadNextPage(pageuserid:String) async {
        if Task.isCancelled { return }
        DispatchQueue.main.async {
            let newFeeds = self.phase.value ?? []
            self.phase = .fetchingNextPage(newFeeds)
        }
        do {
            guard shouldLoadNextPage else {
                return
            }
            guard let currentUid = AuthenViewModel.shared.currentUser?.userid else{return}
            guard let checkNum = AuthenViewModel.shared.currentUser?.checknum else{return}
            let pageNext = nextPage
            _ = APIService.sharedInstance.httpRequestAPI(ApiRouter.timeline(userid: currentUid, checknum: checkNum, pageuserid: String(pageuserid), page: pageNext)){ response in
               if let newFeedResponse = BaseListResponse<NewFeed>(JSON: response){
                   if newFeedResponse.status == 1 {
                       guard let listNewFeed = newFeedResponse.data else{return}
                       if Task.isCancelled { return }
                       let _ = self.syncMain {
                           var newFeeds = self.phase.value ?? []
                           newFeeds += listNewFeed
                           self.phase = .success(newFeeds)
                           self.currentPage = pageNext
                           self.hasReachedEnd = listNewFeed.count < self.itemsPerPage

                       }
                   }else{
                       if Task.isCancelled { return }
                   }
                }
           } failure: { error in
               if Task.isCancelled { return }
               print(error.localizedDescription)
               let _ = self.syncMain {
                   self.phase = .failure(error)
               }
               
           }

        }
       
    }
    
    func syncMain<T>(_ closure: () -> T) -> T {
        if Thread.isMainThread {
            return closure()
        } else {
            return DispatchQueue.main.sync(execute: closure)
        }
    }
    
    func addNewPostToFeed(newFeed:NewFeed){
        var newFeeds = self.phase.value ?? []
        newFeeds.insert(newFeed, at: 0)
        self.phase = .success(newFeeds)
    }
    
    func updatePost(newFeed:NewFeed){
        var newFeeds = self.newFeeds
        if let index = newFeeds.firstIndex(where: { $0.postid == newFeed.postid}) {
            newFeeds[index] = newFeed
            self.phase = .success(newFeeds)
        }
    }
    
    func updateLikePost(id: String, numLikes: String){
        var newFeeds = self.newFeeds
        let newFeed = newFeeds.first(where: {$0.postid == id})
        newFeed?.like = "1"
        newFeed?.numLikes = numLikes
        if let index = newFeeds.firstIndex(where: { $0.postid == newFeed?.postid}) {
            newFeeds[index] = newFeed!
            self.phase = .success(newFeeds)
        }
    }
    
    func updateDisLikePost(id: String, numLikes: String){
        var newFeeds = self.newFeeds
        let newFeed = newFeeds.first(where: {$0.postid == id})
        newFeed?.like = "0"
        newFeed?.numLikes = numLikes
        if let index = newFeeds.firstIndex(where: { $0.postid == newFeed?.postid}) {
            newFeeds[index] = newFeed!
            self.phase = .success(newFeeds)
        }
    }
    
    func updateNumcomment(postId: String, numComment: String) {
        var newFeeds = self.newFeeds
        let newFeed = newFeeds.first(where: {$0.postid == postId})
        newFeed?.numComments = numComment
        if let index = newFeeds.firstIndex(where: { $0.postid == newFeed?.postid}) {
            newFeeds[index] = newFeed!
            self.phase = .success(newFeeds)
        }
    }
    
    @Published var numLikes: String = ""
    func updateNumlikes(numlikes: String) {
        self.numLikes = numlikes
    }
    
    func deletePost(postid: String){
        var newFeed = self.phase.value ?? []
        newFeed.removeAll(where: { $0.postid == postid})
        self.phase = .success(newFeed)
    }
    
    func loadFirstPage(pageuserid:String) async {
        if Task.isCancelled { return }
        print("kk loadFirstPage profile")
//        if let newFeeds = await cache.value(forKey: "newfeedProfile") {
//            DispatchQueue.main.async {
//                self.phase = .success(newFeeds)
//                print("kk loadFirstPage cache profile")
//            }
//            return
//        }
        DispatchQueue.main.async {
            self.phase = .empty
        }
       
        do {
            reset()
            guard let currentUid = AuthenViewModel.shared.currentUser?.userid else{return}
            guard let checkNum = AuthenViewModel.shared.currentUser?.checknum else{return}
            let page = nextPage;
            _ =  APIService.sharedInstance.httpRequestAPI(ApiRouter.timeline(userid: currentUid, checknum: checkNum, pageuserid: String(pageuserid), page: nextPage)){ response in
               if let newFeedResponse = BaseListResponse<NewFeed>(JSON: response){
                   if newFeedResponse.status == 1 {
                       guard let listNewFeed = newFeedResponse.data else{return}
                       self.currentPage = page
                       self.hasReachedEnd = listNewFeed.count < self.itemsPerPage
                       if Task.isCancelled { return }
                       DispatchQueue.main.async {
                           self.phase = .success(listNewFeed)
                           
                       }
//                       Task{
//                           await self.cache.setValue(listNewFeed, forKey: "newfeedProfile")
//                       }
                   }else{
                       if Task.isCancelled { return }
                   }
                }
                self.currentPage = page
           } failure: { error in
               if Task.isCancelled { return }
               print(error.localizedDescription)
               self.phase = .failure(error)
           }

        }
    }
    
    func getExpert(category: String, doctorid: String) {
        APIService.sharedInstance.httpRequestAPI(ApiRouter.getExpert(category: category, doctorid: doctorid)) { response in
            if let expertResponse = BaseResponse<ExpertDetail>(JSON: response) {
                if expertResponse.status == 1 {
                    let expert = expertResponse.data
                    self.expertDetail = expert
                    print("Get expert: \(expertResponse.message ?? "")")
                } else {
                    print("Get expert: \(expertResponse.message ?? "")")
                }
            } else {
                print("Get expert: error")
            }
        } failure: { error in
            print("Get expert: \(error.localizedDescription)")
        }
    }
    
    //Expert Newfeed
    @Published var isLoadingPageExpertNewFeed = false
    @Published var phaseExpertNewFeed = DataFetchPhase<[NewFeed]>.empty
    private(set) var currentPageExpertNewFeed = 0
    private(set) var hasReachedEndExpertNewFeed = false
    let itemsPerPageExpertNewFeed: Int = 3
    
    var nextPageExpertNewFeed: Int { currentPageExpertNewFeed + 1 }
    
    var shouldLoadNextPageExpertNewFeed: Bool {
        !hasReachedEndExpertNewFeed
    }
    
    func resetExpertNewFeed() {
        currentPageExpertNewFeed = 0
        hasReachedEndExpertNewFeed = false
    }
    
    var expertNewFeed: [NewFeed] {
        phaseExpertNewFeed.value ?? []
    }
    
    var isFetchingNextPageExpertNewFeed: Bool {
        if case .fetchingNextPage = phaseExpertNewFeed {
            return true
        }
        return false
    }
    
    func loadDataExpertNewFeed(category: String, doctorid: String, act: String){
        Task {await loadFirstPageExpertNewFeed(category:category, doctorid: doctorid, act: act)}
    }
    
    func removeCacheExpertNewFeed(){
        cacheSave.removeObject(forKey: "ExpertNewFeed")
        self.currentPageExpertNewFeed = 0
        self.hasReachedEndExpertNewFeed = false
        self.phaseExpertNewFeed = .empty
        isLoadingPageExpertNewFeed = false
    }
    
    func loadFirstPageExpertNewFeed(category: String, doctorid: String, act: String) async {
        if Task.isCancelled { return }
        if let cachedData = cacheSave.object(forKey: "ExpertNewFeed"),
           let myDictionary = NSKeyedUnarchiver.unarchiveObject(with: cachedData as Data) as? [String:Any] {

            if let expertNewFeedResponse = ListResponseCatalogDoctor<NewFeed>(JSON: myDictionary){
                guard let listExpertNewFeed = expertNewFeedResponse.data else{return}
                DispatchQueue.main.async {
                    self.phaseExpertNewFeed = .success(listExpertNewFeed)
                    self.currentPageExpertNewFeed = expertNewFeedResponse.currentPage
                    self.hasReachedEndExpertNewFeed = expertNewFeedResponse.hasReachedEnd
                }
                return
            }
            
        }
        
        DispatchQueue.main.async {
            self.phaseExpertNewFeed = .empty
        }
        
        do {
            resetExpertNewFeed()
            let page = nextPageExpertNewFeed;
            _ = APIService.sharedInstance.httpRequestAPI(ApiRouter.getExpertNewFeed(category: category, doctorid: doctorid, act: act, page: page)){ response in
               if let expertNewFeedResponse = ListResponseCatalogDoctor<NewFeed>(JSON: response){
                 if expertNewFeedResponse.status == 1 {
                       guard let listExpertNewFeed = expertNewFeedResponse.data else{return}

                       Task{

                           expertNewFeedResponse.currentPage = page
                           expertNewFeedResponse.hasReachedEnd = self.hasReachedEndExpertNewFeed
                           let json = expertNewFeedResponse.toJSON()
                           let data = try! NSKeyedArchiver.archivedData(withRootObject: json,requiringSecureCoding: false)
                           cacheSave.setObject(data as NSData, forKey: "ExpertNewFeed")
//                           }
                       }
                       if Task.isCancelled { return }
                     DispatchQueue.main.async {
                         self.phaseExpertNewFeed = .success(listExpertNewFeed)
                     }
                       
                   }else{
                       if Task.isCancelled { return }
                   }
                }
                self.currentPageExpertNewFeed = page
           } failure: { error in
               if Task.isCancelled { return }
               print(error.localizedDescription)
               self.phaseExpertNewFeed = .failure(error)
           }

        }
    }
    
    func loadNextPageExpertNewFeed(category: String, doctorid: String, act: String) async {
        if Task.isCancelled { return }
        DispatchQueue.main.async {
            let listExpertNewFeed = self.phaseExpertNewFeed.value ?? []
            self.phaseExpertNewFeed = .fetchingNextPage(listExpertNewFeed)
        }
        do {
            guard shouldLoadNextPageExpertNewFeed else {
                return
            }
            
            let pageNext = nextPageExpertNewFeed
            
            _ = APIService.sharedInstance.httpRequestAPI(ApiRouter.getExpertNewFeed(category: category, doctorid: doctorid, act: act, page: pageNext)){ response in
               if let expertNewFeedResponse = ListResponseCatalogDoctor<NewFeed>(JSON: response){
                   if expertNewFeedResponse.status == 1 {
                       guard let listExpertNewFeed = expertNewFeedResponse.data else{return}

                       if Task.isCancelled { return }
                      
                       DispatchQueue.main.async {
                           var expertNewFeeds = self.phaseExpertNewFeed.value ?? []
                           expertNewFeeds += listExpertNewFeed
                           self.phaseExpertNewFeed = .success(expertNewFeeds)
                           self.currentPageExpertNewFeed = pageNext
                           self.hasReachedEndExpertNewFeed = listExpertNewFeed.count < self.itemsPerPageExpertNewFeed
                           
                           Task{
                               expertNewFeedResponse.data = expertNewFeeds
                               expertNewFeedResponse.currentPage = self.currentPageExpertNewFeed
                               expertNewFeedResponse.hasReachedEnd = self.hasReachedEndExpertNewFeed
                               let json = expertNewFeedResponse.toJSON()
                               let data = try! NSKeyedArchiver.archivedData(withRootObject: json,requiringSecureCoding: false)
                               cacheSave.setObject(data as NSData, forKey: "ExpertNewFeed")
                           }

                       }
                   }else{
                       if Task.isCancelled { return }
                   }
                }
           } failure: { error in
               if Task.isCancelled { return }
               print(error.localizedDescription)
               self.phaseExpertNewFeed = .failure(error)
           }

        }
       
    }
    
    //End Expert Newfeed
    
    //Expert Image
    @Published var isLoadingPageExpertImage = false
    @Published var phaseExpertImage = DataFetchPhase<[CatalogImage]>.empty
    private(set) var currentPageExpertImage = 0
    private(set) var hasReachedEndExpertImage = false
    let itemsPerPageExpertImage: Int = 3
    
    var nextPageExpertImage: Int { currentPageExpertImage + 1 }
    
    var shouldLoadNextPageExpertImage: Bool {
        !hasReachedEndExpertImage
    }
    
    func resetExpertImage() {
        currentPageExpertImage = 0
        hasReachedEndExpertImage = false
    }
    
    var expertImage: [CatalogImage] {
        phaseExpertImage.value ?? []
    }
    
    var isFetchingNextPageExpertImage: Bool {
        if case .fetchingNextPage = phaseExpertImage {
            return true
        }
        return false
    }
    
    func loadDataExpertImage(category: String, doctorid: String, act: String, sortby: String){
        Task {await loadFirstPageExpertImage(category:category, doctorid: doctorid, act: act, sortby: sortby)}
    }
    
    func removeCacheExpertImage(){
        cacheSave.removeObject(forKey: "ExpertImage")
        self.currentPageExpertImage = 0
        self.hasReachedEndExpertImage = false
        self.phaseExpertImage = .empty
        isLoadingPageExpertImage = false
    }
    
    func loadFirstPageExpertImage(category: String, doctorid: String, act: String, sortby: String) async {
        if Task.isCancelled { return }
        if let cachedData = cacheSave.object(forKey: "ExpertImage"),
           let myDictionary = NSKeyedUnarchiver.unarchiveObject(with: cachedData as Data) as? [String:Any] {

            if let expertImageResponse = ListResponseCatalogDoctor<CatalogImage>(JSON: myDictionary){
                guard let listExpertImage = expertImageResponse.data else{return}
                DispatchQueue.main.async {
                    self.phaseExpertImage = .success(listExpertImage)
                    self.currentPageExpertImage = expertImageResponse.currentPage
                    self.hasReachedEndExpertImage = expertImageResponse.hasReachedEnd
                }
                return
            }
            
        }
        
        DispatchQueue.main.async {
            self.phaseExpertImage = .empty
        }
        
        do {
            resetExpertImage()
            let page = nextPageExpertImage;
            _ = APIService.sharedInstance.httpRequestAPI(ApiRouter.getExpertImage(category: category, doctorid: doctorid, act: act, page: page, sortby: sortby)){ response in
               if let expertImageResponse = ListResponseCatalogDoctor<CatalogImage>(JSON: response){
                 if expertImageResponse.status == 1 {
                       guard let listExpertImage = expertImageResponse.data else{return}

                       Task{

                           expertImageResponse.currentPage = page
                           expertImageResponse.hasReachedEnd = self.hasReachedEndExpertImage
                           let json = expertImageResponse.toJSON()
                           let data = try! NSKeyedArchiver.archivedData(withRootObject: json,requiringSecureCoding: false)
                           cacheSave.setObject(data as NSData, forKey: "ExpertImage")
//                           }
                       }
                       if Task.isCancelled { return }
                     DispatchQueue.main.async {
                         self.phaseExpertImage = .success(listExpertImage)
                     }
                       
                   }else{
                       if Task.isCancelled { return }
                   }
                }
                self.currentPageExpertImage = page
           } failure: { error in
               if Task.isCancelled { return }
               print(error.localizedDescription)
               self.phaseExpertImage = .failure(error)
           }

        }
    }
    
    func loadNextPageExpertImage(category: String, doctorid: String, act: String, sortby: String) async {
        if Task.isCancelled { return }
        DispatchQueue.main.async {
            let listExpertImage = self.phaseExpertImage.value ?? []
            self.phaseExpertImage = .fetchingNextPage(listExpertImage)
        }
        do {
            guard shouldLoadNextPageExpertImage else {
                return
            }
            
            let pageNext = nextPageExpertImage
            
            _ = APIService.sharedInstance.httpRequestAPI(ApiRouter.getExpertImage(category: category, doctorid: doctorid, act: act, page: pageNext, sortby: sortby)){ response in
               if let expertImageResponse = ListResponseCatalogDoctor<CatalogImage>(JSON: response){
                   if expertImageResponse.status == 1 {
                       guard let listExpertImage = expertImageResponse.data else{return}

                       if Task.isCancelled { return }
                      
                       DispatchQueue.main.async {
                           var expertImages = self.phaseExpertImage.value ?? []
                           expertImages += listExpertImage
                           self.phaseExpertImage = .success(expertImages)
                           self.currentPageExpertImage = pageNext
                           self.hasReachedEndExpertImage = listExpertImage.count < self.itemsPerPageExpertImage
                           
                           Task{
                               expertImageResponse.data = expertImages
                               expertImageResponse.currentPage = self.currentPageExpertImage
                               expertImageResponse.hasReachedEnd = self.hasReachedEndExpertImage
                               let json = expertImageResponse.toJSON()
                               let data = try! NSKeyedArchiver.archivedData(withRootObject: json,requiringSecureCoding: false)
                               cacheSave.setObject(data as NSData, forKey: "ExpertImage")
                           }

                       }
                   }else{
                       if Task.isCancelled { return }
                   }
                }
           } failure: { error in
               if Task.isCancelled { return }
               print(error.localizedDescription)
               self.phaseExpertImage = .failure(error)
           }

        }
       
    }
    
    //End Expert Image
    
    //Expert Video
    @Published var isLoadingPageExpertVideo = false
    @Published var phaseExpertVideo = DataFetchPhase<[CatalogVideo]>.empty
    private(set) var currentPageExpertVideo = 0
    private(set) var hasReachedEndExpertVideo = false
    let itemsPerPageExpertVideo: Int = 10
    
    var nextPageExpertVideo: Int { currentPageExpertVideo + 1 }
    
    var shouldLoadNextPageExpertVideo: Bool {
        !hasReachedEndExpertVideo
    }
    
    func resetExpertVideo() {
        currentPageExpertVideo = 0
        hasReachedEndExpertVideo = false
    }
    
    var expertVideo: [CatalogVideo] {
        phaseExpertVideo.value ?? []
    }
    
    var isFetchingNextPageExpertVideo: Bool {
        if case .fetchingNextPage = phaseExpertVideo {
            return true
        }
        return false
    }
    
    func loadDataExpertVideo(category: String, doctorid: String, act: String, sortby: String){
        Task {await loadFirstPageExpertVideo(category:category, doctorid: doctorid, act: act, sortby: sortby)}
    }
    
    func removeCacheExpertVideo(){
        cacheSave.removeObject(forKey: "ExpertVideo")
        self.currentPageExpertVideo = 0
        self.hasReachedEndExpertVideo = false
        self.phaseExpertVideo = .empty
        isLoadingPageExpertVideo = false
    }
    
    func loadFirstPageExpertVideo(category: String, doctorid: String, act: String, sortby: String) async {
        if Task.isCancelled { return }
        if let cachedData = cacheSave.object(forKey: "ExpertVideo"),
           let myDictionary = NSKeyedUnarchiver.unarchiveObject(with: cachedData as Data) as? [String:Any] {

            if let expertVideoResponse = ListResponseCatalogDoctor<CatalogVideo>(JSON: myDictionary){
                guard let listExpertVideo = expertVideoResponse.data else{return}
                DispatchQueue.main.async {
                    self.phaseExpertVideo = .success(listExpertVideo)
                    self.currentPageExpertVideo = expertVideoResponse.currentPage
                    self.hasReachedEndExpertVideo = expertVideoResponse.hasReachedEnd
                }
                return
            }
            
        }
        
        DispatchQueue.main.async {
            self.phaseExpertVideo = .empty
        }
        
        do {
            resetExpertVideo()
            let page = nextPageExpertVideo;
            _ = APIService.sharedInstance.httpRequestAPI(ApiRouter.getExpertImage(category: category, doctorid: doctorid, act: act, page: page, sortby: sortby)){ response in
               if let expertVideoResponse = ListResponseCatalogDoctor<CatalogVideo>(JSON: response){
                 if expertVideoResponse.status == 1 {
                       guard let listExpertVideo = expertVideoResponse.data else{return}
                        let filtered = listExpertVideo.filter { ($0.urlvideo != "") }
                       Task{

                           expertVideoResponse.currentPage = page
                           expertVideoResponse.hasReachedEnd = self.hasReachedEndExpertImage
                           let json = expertVideoResponse.toJSON()
                           let data = try! NSKeyedArchiver.archivedData(withRootObject: json,requiringSecureCoding: false)
                           cacheSave.setObject(data as NSData, forKey: "ExpertVideo")
//                           }
                       }
                       if Task.isCancelled { return }
                     DispatchQueue.main.async {
                         self.phaseExpertVideo = .success(filtered)
                     }
                       
                   }else{
                       if Task.isCancelled { return }
                   }
                }
                self.currentPageExpertVideo = page
           } failure: { error in
               if Task.isCancelled { return }
               print(error.localizedDescription)
               self.phaseExpertVideo = .failure(error)
           }

        }
    }
    
    func loadNextPageExpertVideo(category: String, doctorid: String, act: String, sortby: String) async {
        if Task.isCancelled { return }
        DispatchQueue.main.async {
            let listExpertVideo = self.phaseExpertVideo.value ?? []
            self.phaseExpertVideo = .fetchingNextPage(listExpertVideo)
        }
        do {
            guard shouldLoadNextPageExpertVideo else {
                return
            }
            
            let pageNext = nextPageExpertVideo
            
            _ = APIService.sharedInstance.httpRequestAPI(ApiRouter.getExpertImage(category: category, doctorid: doctorid, act: act, page: pageNext, sortby: sortby)){ response in
               if let expertVideoResponse = ListResponseCatalogDoctor<CatalogVideo>(JSON: response){
                   if expertVideoResponse.status == 1 {
                       guard let listExpertVideo = expertVideoResponse.data else{return}
                       let filtered = listExpertVideo.filter { ($0.urlvideo != "") }
                       if Task.isCancelled { return }
                      
                       DispatchQueue.main.async {
                           var expertVideos = self.phaseExpertVideo.value ?? []
                           expertVideos += filtered
                           self.phaseExpertVideo = .success(expertVideos)
                           self.currentPageExpertVideo = pageNext
                           self.hasReachedEndExpertVideo = listExpertVideo.count < self.itemsPerPageExpertVideo
                           
                           Task{
                               expertVideoResponse.data = expertVideos
                               expertVideoResponse.currentPage = self.currentPageExpertVideo
                               expertVideoResponse.hasReachedEnd = self.hasReachedEndExpertVideo
                               let json = expertVideoResponse.toJSON()
                               let data = try! NSKeyedArchiver.archivedData(withRootObject: json,requiringSecureCoding: false)
                               cacheSave.setObject(data as NSData, forKey: "ExpertVideo")
                           }

                       }
                   }else{
                       if Task.isCancelled { return }
                   }
                }
           } failure: { error in
               if Task.isCancelled { return }
               print(error.localizedDescription)
               self.phaseExpertVideo = .failure(error)
           }

        }
       
    }
    
    //End Expert Video
    
    //Expert Question
    @Published var isLoadingPageExpertQuestion = false
    @Published var phaseExpertQuestion = DataFetchPhase<[CatalogQuestion]>.empty
    private(set) var currentPageExpertQuestion = 0
    private(set) var hasReachedEndExpertQuestion = false
    let itemsPerPageExpertQuestion: Int = 10
    
    var nextPageExpertQuestion: Int { currentPageExpertQuestion + 1 }
    
    var shouldLoadNextPageExpertQuestion: Bool {
        !hasReachedEndExpertQuestion
    }
    
    func resetExpertQuestion() {
        currentPageExpertQuestion = 0
        hasReachedEndExpertQuestion = false
    }
    
    var expertQuestion: [CatalogQuestion] {
        phaseExpertQuestion.value ?? []
    }
    
    var isFetchingNextPageExpertQuestion: Bool {
        if case .fetchingNextPage = phaseExpertQuestion {
            return true
        }
        return false
    }
    
    func loadDataExpertQuestion(category: String, doctorid: String, act: String, sortby: String){
        Task {await loadFirstPageExpertQuestion(category:category, doctorid: doctorid, act: act, sortby: sortby)}
    }
    
    func removeCacheExpertQuestion(){
        cacheSave.removeObject(forKey: "ExpertQuestion")
        self.currentPageExpertQuestion = 0
        self.hasReachedEndExpertQuestion = false
        self.phaseExpertQuestion = .empty
        isLoadingPageExpertQuestion = false
    }
    
    func loadFirstPageExpertQuestion(category: String, doctorid: String, act: String, sortby: String) async {
        if Task.isCancelled { return }
        if let cachedData = cacheSave.object(forKey: "ExpertQuestion"),
           let myDictionary = NSKeyedUnarchiver.unarchiveObject(with: cachedData as Data) as? [String:Any] {

            if let expertQuestionResponse = ListResponseCatalogDoctor<CatalogQuestion>(JSON: myDictionary){
                guard let listExpertQuestion = expertQuestionResponse.data else{return}
                DispatchQueue.main.async {
                    self.phaseExpertQuestion = .success(listExpertQuestion)
                    self.currentPageExpertQuestion = expertQuestionResponse.currentPage
                    self.hasReachedEndExpertQuestion = expertQuestionResponse.hasReachedEnd
                }
                return
            }
            
        }
        
        DispatchQueue.main.async {
            self.phaseExpertQuestion = .empty
        }
        
        do {
            resetExpertQuestion()
            let page = nextPageExpertQuestion;
            _ = APIService.sharedInstance.httpRequestAPI(ApiRouter.getExpertImage(category: category, doctorid: doctorid, act: act, page: page, sortby: sortby)){ response in
               if let expertQuestionResponse = ListResponseCatalogDoctor<CatalogQuestion>(JSON: response){
                 if expertQuestionResponse.status == 1 {
                       guard let listExpertQuestion = expertQuestionResponse.data else{return}
                        
                       Task{

                           expertQuestionResponse.currentPage = page
                           expertQuestionResponse.hasReachedEnd = self.hasReachedEndExpertQuestion
                           let json = expertQuestionResponse.toJSON()
                           let data = try! NSKeyedArchiver.archivedData(withRootObject: json,requiringSecureCoding: false)
                           cacheSave.setObject(data as NSData, forKey: "ExpertQuestion")
//                           }
                       }
                       if Task.isCancelled { return }
                     DispatchQueue.main.async {
                         self.phaseExpertQuestion = .success(listExpertQuestion)
                     }
                       
                   }else{
                       if Task.isCancelled { return }
                   }
                }
                self.currentPageExpertQuestion = page
           } failure: { error in
               if Task.isCancelled { return }
               print(error.localizedDescription)
               self.phaseExpertQuestion = .failure(error)
           }

        }
    }
    
    func loadNextPageExpertQuestion(category: String, doctorid: String, act: String, sortby: String) async {
        if Task.isCancelled { return }
        DispatchQueue.main.async {
            let listExpertQuestion = self.phaseExpertQuestion.value ?? []
            self.phaseExpertQuestion = .fetchingNextPage(listExpertQuestion)
        }
        do {
            guard shouldLoadNextPageExpertQuestion else {
                return
            }
            
            let pageNext = nextPageExpertQuestion
            
            _ = APIService.sharedInstance.httpRequestAPI(ApiRouter.getExpertImage(category: category, doctorid: doctorid, act: act, page: pageNext, sortby: sortby)){ response in
               if let expertQuestionResponse = ListResponseCatalogDoctor<CatalogQuestion>(JSON: response){
                   if expertQuestionResponse.status == 1 {
                       guard let listExpertQuestion = expertQuestionResponse.data else{return}
                       
                       if Task.isCancelled { return }
                      
                       DispatchQueue.main.async {
                           var expertQuestions = self.phaseExpertQuestion.value ?? []
                           expertQuestions += listExpertQuestion
                           self.phaseExpertQuestion = .success(expertQuestions)
                           self.currentPageExpertQuestion = pageNext
                           self.hasReachedEndExpertQuestion = listExpertQuestion.count < self.itemsPerPageExpertQuestion
                           
                           Task{
                               expertQuestionResponse.data = expertQuestions
                               expertQuestionResponse.currentPage = self.currentPageExpertQuestion
                               expertQuestionResponse.hasReachedEnd = self.hasReachedEndExpertQuestion
                               let json = expertQuestionResponse.toJSON()
                               let data = try! NSKeyedArchiver.archivedData(withRootObject: json,requiringSecureCoding: false)
                               cacheSave.setObject(data as NSData, forKey: "ExpertQuestion")
                           }

                       }
                   }else{
                       if Task.isCancelled { return }
                   }
                }
           } failure: { error in
               if Task.isCancelled { return }
               print(error.localizedDescription)
               self.phaseExpertQuestion = .failure(error)
           }

        }
       
    }
    
    //End Expert Question
    
    func getExpertDetailNewFeed(category: String, postid: String, act: String, completion: @escaping (NewFeed?) -> Void) {
        APIService.sharedInstance.httpRequestAPI(ApiRouter.getExpertDetailNewFeed(category: category, postid: postid, act: act)) { response in
            if let expertDetailNewFeedResponse = BaseResponse<NewFeed>(JSON: response) {
                if expertDetailNewFeedResponse.status == 1 {
                    completion(expertDetailNewFeedResponse.data)
                } else {
                    print("get Detail expert newfeed error: \(expertDetailNewFeedResponse.message ?? "")")
                }
            } else {
                print("get Detail expert newfeed error")
            }
        } failure: { error in
            print("get Detail expert newfeed error: \(error.localizedDescription)")
        }
    }
}
