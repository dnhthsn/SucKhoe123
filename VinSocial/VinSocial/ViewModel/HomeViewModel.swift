//
//  MainTabViewModel.swift
//  Messenger
//
//  Created by Stealer Of Souls on 2/28/23.
//

import Foundation
import FirebaseDatabase
import ObjectMapper
import Alamofire

class HomeViewModel : ObservableObject{
    @Published var isLoadingPage = false
    @Published var isLogin = false
    @Published var isCancelSearch = false
    @Published var error: Error?
    @Published var phase = DataFetchPhase<[NewFeed]>.empty
    @Published var phaseNotification = DataFetchPhase<[Notifications]>.empty
    @Published var newFeedSearchs:[NewFeed] = []
    private(set) var currentPageNoti = 0
    private(set) var hasReachedEndNoti = false
    let itemsPerPageNoti: Int = 5
    
    private(set) var currentPage = 0
    private(set) var hasReachedEnd = false
    private(set) var act = ""
    let itemsPerPage: Int = 3
    
    var nextPage: Int { currentPage + 1 }
    var nextPageNoti: Int { currentPageNoti + 1 }
    
    var shouldLoadNextPage: Bool {
//        !hasReachedEnd && nextPage <= maxPageLimit
        !hasReachedEnd
    }
    
    var shouldLoadNextPageNoti: Bool {
        !hasReachedEndNoti
    }
    
    func reset() {
        currentPage = 0
        hasReachedEnd = false
    }
    
    func resetNotifcation(){
        currentPageNoti = 0
        hasReachedEndNoti = false
    }
    
    var newFeeds: [NewFeed] {
        phase.value ?? []
    }
    
    var notifications: [Notifications] {
        phaseNotification.value ?? []
    }
    
    var isFetchingNextPage: Bool {
        if case .fetchingNextPage = phase {
            return true
        }
        return false
    }
    
    var isFetchingNextPageNoti: Bool {
        if case .fetchingNextPage = phaseNotification {
            return true
        }
        return false
    }
    
    func loadData(){
        Task {await loadFirstPage()}
        if AuthenViewModel.shared.currentUser != nil {
          Task {await loadFirstPageNoti()}
        }
    }
    
    //remove cache when logout and login lại
    func removeCache(){
        cacheSave.removeObject(forKey: "newfeedHome")
        self.currentPage = 0
        self.currentPageNoti = 0
        self.hasReachedEndNoti = false
        self.hasReachedEnd = false
        self.phase = .empty
        self.phaseNotification = .empty
        self.phaseListCatalogVideo = .empty
        self.phaseListCatalogPhoto = .empty
        isLoadingPage = false
    }
    
    func loadNextPage() async {
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
            _ = APIService.sharedInstance.httpRequestAPI(ApiRouter.getNewFeed(page: pageNext, userid: currentUid, checknum: checkNum)){ response in
               if let newFeedResponse = BaseListResponse<NewFeed>(JSON: response){
                   if newFeedResponse.status == 1 {
                       guard let listNewFeed = newFeedResponse.data else{return}
                       if Task.isCancelled { return }
                      
                       DispatchQueue.main.async {
                           var newFeeds = self.phase.value ?? []
                           newFeeds += listNewFeed
                           self.phase = .success(newFeeds)
                           self.currentPage = pageNext
                           self.hasReachedEnd = listNewFeed.count < self.itemsPerPage
                           
                           Task{
                               newFeedResponse.data = newFeeds
                               newFeedResponse.currentPage = self.currentPage
                               newFeedResponse.hasReachedEnd = self.hasReachedEnd
                               let json = newFeedResponse.toJSON()
                               let data = try! NSKeyedArchiver.archivedData(withRootObject: json,requiringSecureCoding: false)
                               cacheSave.setObject(data as NSData, forKey: "newfeedHome")
                           }

                       }
                   }else{
                       if Task.isCancelled { return }
                   }
                }
           } failure: { error in
               if Task.isCancelled { return }
               print(error.localizedDescription)
               self.phase = .failure(error)
           }

        }
       
    }
    
    func loadFirstPage() async {
        if Task.isCancelled { return }
        if let cachedData = cacheSave.object(forKey: "newfeedHome"),
           let myDictionary = NSKeyedUnarchiver.unarchiveObject(with: cachedData as Data) as? [String:Any] {
//           let myDictionary = try? NSKeyedUnarchiver.unarchivedObject(ofClass: NSDictionary.self, from: cachedData as Data) as? [String: Any] {
            if let newFeedResponse = BaseListResponse<NewFeed>(JSON: myDictionary){
                guard let listNewFeed = newFeedResponse.data else{return}
                DispatchQueue.main.async {
                    self.phase = .success(listNewFeed)
                    self.currentPage = newFeedResponse.currentPage
                    self.hasReachedEnd = newFeedResponse.hasReachedEnd
                }
                print("MrSkee Load from cache")
                return
            }
            
        }
        
        DispatchQueue.main.async {
            self.phase = .empty
        }
        
        do {
            reset()
            var currentUid = ""
            var checkNum = ""
            if AuthenViewModel.shared.currentUser != nil {
                currentUid = (AuthenViewModel.shared.currentUser?.userid) ?? ""
            }else{
                currentUid = ""
            }
            if AuthenViewModel.shared.currentUser != nil {
                checkNum = (AuthenViewModel.shared.currentUser?.checknum) ?? ""
            }else{
                checkNum = ""
            }
            let page = nextPage;
            _ = APIService.sharedInstance.httpRequestAPI(ApiRouter.getNewFeed(page: page, userid: currentUid, checknum: checkNum)){ response in
                print("Load loadFirstPage \(currentUid) with check \(checkNum)")
               if let newFeedResponse = BaseListResponse<NewFeed>(JSON: response){
                 if newFeedResponse.status == 1 {
                       guard let listNewFeed = newFeedResponse.data else{return}
                       Task{
//                           if let jsonString = newFeedResponse.toJSONString(){
//                               await self.cache.setValue(jsonString, forKey: "newfeedHome")
                           newFeedResponse.currentPage = page
                           newFeedResponse.hasReachedEnd = self.hasReachedEnd
                           let json = newFeedResponse.toJSON()
                           let data = try! NSKeyedArchiver.archivedData(withRootObject: json,requiringSecureCoding: false)
                           cacheSave.setObject(data as NSData, forKey: "newfeedHome")
//                           }
                       }
                       if Task.isCancelled { return }
                     DispatchQueue.main.async {
                         self.phase = .success(listNewFeed)                     }
                       
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
    
    func loadFirstPageNoti() async {
        if Task.isCancelled { return }
//        if let notifications = await cacheNoti.value(forKey: "notifications") {
//            phaseNotification = .success(notifications)
//            return
//        }
        
        DispatchQueue.main.async {
            self.phaseNotification = .empty
        }
        do {
            resetNotifcation()
            guard let currentUid = AuthenViewModel.shared.currentUser?.userid else{return}
            guard let checkNum = AuthenViewModel.shared.currentUser?.checknum else{return}
            let page = nextPageNoti;
            
            _ = APIService.sharedInstance.httpRequestAPI(ApiRouter.getNotification(userid: currentUid, checknum: checkNum, page: page)){ response in
               if let notiResponse = BaseListResponse<Notifications>(JSON: response){
                   if notiResponse.status == 1 {
                       guard let listNoti = notiResponse.data else{return}
                       if Task.isCancelled { return }
                        self.phaseNotification = .success(listNoti)
                    
                   }else{
                       print("Error loggin==== 5")
                       if Task.isCancelled { return }
                   }
                }
                self.currentPageNoti = page
           } failure: { error in
               if Task.isCancelled { return }
               print(error.localizedDescription)
               self.phaseNotification = .failure(error)
           }
        }
    }
    
    func loadNextPageNoti() async {
        if Task.isCancelled { return }
        DispatchQueue.main.async {
            let notifications = self.phaseNotification.value ?? []
            self.phaseNotification = .fetchingNextPage(notifications)
        }
        do {
            guard shouldLoadNextPageNoti else {
                return
            }
            guard let currentUid = AuthenViewModel.shared.currentUser?.userid else{return}
            guard let checkNum = AuthenViewModel.shared.currentUser?.checknum else{return}
            let pageNext = nextPageNoti
           _ = APIService.sharedInstance.httpRequestAPI(ApiRouter.getNotification(userid: currentUid, checknum: checkNum, page: pageNext)){ response in
               if let notiResponse = BaseListResponse<Notifications>(JSON: response){
                   if notiResponse.status == 1 {
                       guard let listNoti = notiResponse.data else{return}
                       if Task.isCancelled { return }
                      
                       DispatchQueue.main.async {
                           var notifications = self.phaseNotification.value ?? []
                           notifications += listNoti
                           self.phaseNotification = .success(notifications)
                           self.currentPageNoti = pageNext
                           self.hasReachedEndNoti = listNoti.count < self.itemsPerPageNoti
                       }
                   }else{
                       if Task.isCancelled { return }
                   }
                }
           } failure: { error in
               if Task.isCancelled { return }
               print(error.localizedDescription)
               self.error = self.generateError(description: error.localizedDescription,"loadNextPageNoti")
               self.phaseNotification = .failure(error)
           }

        }
    }
    
    @Published var isCreatePost = false
    func createPost(title: String, image:String, urlshare:String,content:String,layoutid:String,display:String,data:[MediaUploadFile]) {
        guard let userID = AuthenViewModel.shared.currentUser?.userid else{return}
        guard let checknum = AuthenViewModel.shared.currentUser?.checknum else{return}
        
        APIService.sharedInstance.httpUploadFile(ApiRouter.createPost(userid: userID, checknum: checknum, title: title, image: image, urlshare: urlshare, content: content, layoutid: layoutid, display: display), medias: data, fileType: "", fileName: "") { response in
            if let responseUploadFile = BaseResponse<NewFeed>(JSON: response){
                if responseUploadFile.status == 1{
                    // sucess
                    self.isCreatePost = true
                    NotificationCenter.default.post(name: Notification.Name("CreatPostState"), object: self.isCreatePost)
                    if let newFeed = responseUploadFile.data{
                        var newFeeds = self.phase.value ?? []
                        newFeeds.insert(newFeed, at: 0)
                        DispatchQueue.main.async {
                            self.phase = .success(newFeeds)
                            NotificationCenter.default.post(name: Notification.Name("CreatPost"), object: newFeed)

                        }

                        
                    }
                }else {
                    //error
                    self.generateError(description: "Error creare post with status \(String(describing: responseUploadFile.status) ?? "")", "createPost")
                    self.isCreatePost = false
                    NotificationCenter.default.post(name: Notification.Name("CreatPostState"), object: self.isCreatePost)
                }
                
            }
        } failure: { error in
            self.isCreatePost = false
            NotificationCenter.default.post(name: Notification.Name("CreatPostState"), object: self.isCreatePost)
            self.error = self.generateError(description: error.localizedDescription,"createPost")
            print("create post error create post")
            
        }
    }
    
    private func generateError(code: Int = 0, description: String,_ domain:String) -> Error {
        NSError(domain: domain, code: code, userInfo: [NSLocalizedDescriptionKey: description])
    }
    //=================================================================
    
    @Published var phaseListCatalogVideo = DataFetchPhase<[ListCatalog]>.empty
    @Published var phaseListCatalogPhoto = DataFetchPhase<[ListCatalog]>.empty
    @Published var phaseNewFeedForCatalogVideo = [NewFeedsForCatalog]()
    @Published var phaseNewFeedForCatalogPhoto = [NewFeedsForCatalog]()
    @Published var newFeedForCatalogPhoto = [NewFeed]()
    @Published var newFeedForCatalogVideo = [NewFeed]()
    @Published var isLoadingFeedForCatalogVideo:Bool = false
    @Published var isLoadingFeedForCatalogPhoto:Bool = false
    
    func listCatalogs(showType:TypeShowScreen)-> [ListCatalog] {
        if showType == TypeShowScreen.VIDEO{
            return phaseListCatalogVideo.value ?? []
        }
        return phaseListCatalogPhoto.value ?? []
        
    }
    
    func getListFeedForCatalog(catid:String,showType:TypeShowScreen) ->[NewFeed]{
        if showType == TypeShowScreen.VIDEO{
            let newFeedForCatalog = phaseNewFeedForCatalogVideo.first(where: { $0.catid == catid})
            if newFeedForCatalog != nil {
                return newFeedForCatalog?.newFeed ?? []
            }
        }else{
            let newFeedForCatalog = phaseNewFeedForCatalogPhoto.first(where: { $0.catid == catid})
            if newFeedForCatalog != nil {
                return newFeedForCatalog?.newFeed ?? []
            }
        }
        return []
    }
    
    
    func loadCatalog(act:String,catid:String,checkVideoOrPhoto:TypeShowScreen) async {
        if Task.isCancelled { return }
            if checkVideoOrPhoto == TypeShowScreen.VIDEO{
                let newFeedForCatalog = self.phaseNewFeedForCatalogVideo.first(where: { $0.catid == catid})
                if newFeedForCatalog != nil {
                    DispatchQueue.main.async {
                        self.newFeedForCatalogVideo = newFeedForCatalog?.newFeed ?? []
                    }
                    return
                }
            }else{
                let newFeedForCatalog = self.phaseNewFeedForCatalogPhoto.first(where: { $0.catid == catid})
                if newFeedForCatalog != nil {
                    DispatchQueue.main.async {
                        self.newFeedForCatalogPhoto = newFeedForCatalog?.newFeed ?? []
                    }
                    return
                }
        }
        
        do {
            DispatchQueue.main.async {
                if checkVideoOrPhoto == TypeShowScreen.VIDEO{
                    self.isLoadingFeedForCatalogVideo = true
                }else{
                    self.isLoadingFeedForCatalogPhoto = true

                }
            }
            var apiRouter:ApiRouter
            if checkVideoOrPhoto == TypeShowScreen.VIDEO {
                apiRouter = ApiRouter.listVideo(act: act, catid: catid, sortby: "new", page: 1)
            }else{
                apiRouter = ApiRouter.listPhoto(act: act, catid: catid, sortby: "new", page: 1)
            }
            
          _ =  APIService.sharedInstance.httpRequestAPI(apiRouter){ response in
              if let videoFeedResponse = VideoFeedModel(JSON: response){
                  if checkVideoOrPhoto == TypeShowScreen.VIDEO{
                      self.isLoadingFeedForCatalogVideo = false
                  }else{
                      self.isLoadingFeedForCatalogPhoto = false

                  }
                  if videoFeedResponse.status == 1 {
                      if checkVideoOrPhoto == TypeShowScreen.VIDEO{
                          if self.phaseListCatalogVideo.value == nil {
                              if (videoFeedResponse.listcatalog != nil && videoFeedResponse.listcatalog!.count>0) {
                                  let cataLogAll = ListCatalog(catid: "", title: "Tất cả", total: "9999")
                                  videoFeedResponse.listcatalog?.insert(cataLogAll, at: 0)
                                  self.phaseListCatalogVideo = .success(videoFeedResponse.listcatalog?.filter{ Int($0.total) ?? 0 > 0 } ?? [])
                              }else{
                                  self.phaseListCatalogVideo = .empty
                              }
                          }
                          
                      }else{
                          if self.phaseListCatalogPhoto.value == nil {
                              if (videoFeedResponse.listcatalog != nil && videoFeedResponse.listcatalog!.count>0) {
                                  let cataLogAll = ListCatalog(catid: "", title: "Tất cả", total: "9999")
                                  videoFeedResponse.listcatalog?.insert(cataLogAll, at: 0)
                                  self.phaseListCatalogPhoto = .success(videoFeedResponse.listcatalog?.filter{ Int($0.total) ?? 0 > 0 } ?? [])
                              }else{
                                  self.phaseListCatalogPhoto = .empty
                              }
                          }
                      }
                      
                      
                       if Task.isCancelled { return }
                       guard let listNewFeed = videoFeedResponse.data else{return}
                       //Nếu catid == rỗng thì là nó tab tất cả?
                       let newFeedForCatalog = NewFeedsForCatalog(catid:catid,currentPage: 1,newFeed: listNewFeed)
                      DispatchQueue.main.async {
                          if checkVideoOrPhoto == TypeShowScreen.VIDEO{
                              self.phaseNewFeedForCatalogVideo.append(newFeedForCatalog)
                              self.newFeedForCatalogVideo = newFeedForCatalog.newFeed ?? []
                          }else{
                              self.phaseNewFeedForCatalogPhoto.append(newFeedForCatalog)
                              self.newFeedForCatalogPhoto = newFeedForCatalog.newFeed ?? []
                          }
                      }
                     
                   }else{
//                       self.phaseListCatalog = .failure(self.generateError(code: -1, description: "videoFeedResponse error", "listVideo"))
                       if Task.isCancelled { return }
                   }
                }
           } failure: { error in
               if Task.isCancelled { return }
               print(error.localizedDescription)
               if checkVideoOrPhoto == TypeShowScreen.VIDEO{
                   self.isLoadingFeedForCatalogVideo = false

               }else{
                   self.isLoadingFeedForCatalogPhoto = false

               }
           }
        }
    }
    
    
    
    func loadNextPageFeedPhotoAndVideoForCatalog(act:String,catid:String,checkVideoOrPhoto:TypeShowScreen) async {
        if Task.isCancelled { return }
        
        var currentPage:Int = 1
        var showLoadNextPage:Bool = false
        var newFeedForCatalog:NewFeedsForCatalog?
        if checkVideoOrPhoto == TypeShowScreen.VIDEO{
            newFeedForCatalog = phaseNewFeedForCatalogVideo.first(where: { $0.catid == catid}) ?? nil
        }else{
            newFeedForCatalog = phaseNewFeedForCatalogPhoto.first(where: { $0.catid == catid}) ?? nil
        }
        
        if newFeedForCatalog == nil {
            return
        }
        if newFeedForCatalog?.newFeed == nil {
            return
        }
        if newFeedForCatalog != nil {
            currentPage = newFeedForCatalog?.currentPage ?? 1
            showLoadNextPage = ((newFeedForCatalog?.shouldLoadNextPage) != nil)
        }
        
        do {
            guard showLoadNextPage else {
                return
            }
            let pageNext = currentPage + 1
            var apiRouter:ApiRouter
            if checkVideoOrPhoto == TypeShowScreen.VIDEO {
                apiRouter = ApiRouter.listVideo(act: act, catid: catid, sortby: "new", page: pageNext)
            }else{
                apiRouter = ApiRouter.listPhoto(act: act, catid: catid, sortby: "new", page: pageNext)
            }
            _ =  APIService.sharedInstance.httpRequestAPI(apiRouter){ [self] response in
              if let videoFeedResponse = VideoFeedModel(JSON: response){
                  if videoFeedResponse.status == 1 {
                       if Task.isCancelled { return }
                       guard let listNewFeed = videoFeedResponse.data else{return}
                      DispatchQueue.main.async {
                          if checkVideoOrPhoto == TypeShowScreen.VIDEO{
                              if let item = self.phaseNewFeedForCatalogVideo.firstIndex(where: { $0.catid == catid}){
                                  let  newFeedForCatalog  = self.phaseNewFeedForCatalogVideo[item]
                                  newFeedForCatalog.currentPage = pageNext
                                  newFeedForCatalog.shouldLoadNextPage = listNewFeed.count == 0
                                  newFeedForCatalog.newFeed?.append(contentsOf: listNewFeed)
                                  self.phaseNewFeedForCatalogVideo[item] = newFeedForCatalog
                                  self.newFeedForCatalogVideo = newFeedForCatalog.newFeed ?? []

                              }
                          }else{
                              if let item = self.phaseNewFeedForCatalogPhoto.firstIndex(where: { $0.catid == catid}){
                                  let newFeedForCatalog  = self.phaseNewFeedForCatalogPhoto[item]
                                   newFeedForCatalog.currentPage = pageNext
                                   newFeedForCatalog.shouldLoadNextPage = listNewFeed.count == 0
                                   newFeedForCatalog.newFeed?.append(contentsOf: listNewFeed)
                                   self.phaseNewFeedForCatalogPhoto[item] = newFeedForCatalog
                                   self.newFeedForCatalogPhoto = newFeedForCatalog.newFeed ?? []
                              }
                          }
                      }
                     
                   }else{
                       if Task.isCancelled { return }
                   }
                }
           } failure: { error in
               if Task.isCancelled { return }
               print(error.localizedDescription)
           }

        }
       
    }
    
    
    
    //Search feed
    private var currentPageSearch = 1
    @Published var isLoadingSearchPage = false
    private var request: DataRequest?
    func searchFeed(keyword:String,mod:String){
        isLoadingSearchPage = true
        print("Search Feed \(currentPage)")
        request = APIService.sharedInstance.httpRequestAPI(ApiRouter.searchFeed(mode: mod, act: "", keyword: keyword, page: currentPageSearch)) { response in
            if let newFeedResponse = BaseListResponse<NewFeed>(JSON: response){
                if newFeedResponse.status == 1 {
                    guard let listNewFeed = newFeedResponse.data else{return}
                    if self.isCancelSearch {
                        self.isCancelSearch = false
                    }else{
                        for newFeed in listNewFeed {
                            if let index = self.newFeedSearchs.firstIndex(where: { ($0.postid ?? "") ==
                                (newFeed.postid ?? "")}) {
                                self.newFeedSearchs[index] = newFeed
                            }else{
                                self.newFeedSearchs.append(newFeed)
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
        newFeedSearchs.removeAll(keepingCapacity: false)
        isLoadingSearchPage = false
        isCancelSearch = true
        if request != nil{
            request?.cancel()
            request = nil
        }
//        newFeedSearchs.removeAll()
    }
    
    func getContentEdit(getpost: String, postid: String, completion: @escaping (NewFeed) ->Void) {
        guard let userID = AuthenViewModel.shared.currentUser?.userid else{return}
        guard let checknum = AuthenViewModel.shared.currentUser?.checknum else{return}
        
        _ = APIService.sharedInstance.httpRequestAPI(ApiRouter.getContentEdit(userid: userID, checknum: checknum, getpost: getpost, postid: postid)) { response in
            if let contentEditResponse = ResponseEditInfo<NewFeed>(JSON: response) {
                if contentEditResponse.status == 1 {
                    let newFeed = contentEditResponse.data
                    completion(newFeed!)
                }
            }
        } failure: { error in
            self.error = self.generateError(description: error.localizedDescription,"content_edit")
        }
    }
    
    func editContent(postid: String, title: String, image: String, urlshare: String, content: String, layoutid: Int, display: Int, filephoto: [MediaUploadFile], media: [String]) {
        guard let userID = AuthenViewModel.shared.currentUser?.userid else{return}
        guard let checknum = AuthenViewModel.shared.currentUser?.checknum else{return}
        
        APIService.sharedInstance.httpUploadFile(ApiRouter.editContent(userid: userID, checknum: checknum, postid: postid, title: title, image: image, urlshare: urlshare, content: content, layoutid: layoutid, display: display, media: media), medias: filephoto, fileType: "", fileName: "") { response in
            if let responseUploadFile = BaseResponse<NewFeed>(JSON: response){
                if responseUploadFile.status == 1{
                    // sucess update lại cái feed.
                    if responseUploadFile.data != nil{
                        NotificationCenter.default.post(name: Notification.Name("updatePost"), object: responseUploadFile.data)
                    }
                }else {
                    //error
                    self.generateError(description: "Error edit post with status \(String(describing: responseUploadFile.status) )", "edit_content")
                }
                
            }
        } failure: { error in
            self.isCreatePost = false
            self.error = self.generateError(description: error.localizedDescription,"edit_content")
            print(self.error)
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
    
    func deletePost(postid: String) {
        guard let userID = AuthenViewModel.shared.currentUser?.userid else{return}
        guard let checknum = AuthenViewModel.shared.currentUser?.checknum else{return}
        
        _ = APIService.sharedInstance.httpRequestAPI(ApiRouter.deletePost(userid: userID, checknum: checknum, postid: postid)) { response in
            if let deleteResponse = BaseListResponse<NewFeed>(JSON: response) {
                if deleteResponse.status == 1 {
                    var newFeed = self.phase.value ?? []
                    newFeed.removeAll(where: { $0.postid == postid})
                    self.phase = .success(newFeed)
                    print("delete post success")
                    NotificationCenter.default.post(name: Notification.Name("deletePost"), object: postid)
                }
            }
        } failure: { error in
            self.error = self.generateError(description: error.localizedDescription,"delete_post")
        }
    }
    
    @Published var numLikes: String = ""
    func likePost(id: String) {
        guard let userID = AuthenViewModel.shared.currentUser?.userid else{return}
        guard let checknum = AuthenViewModel.shared.currentUser?.checknum else{return}
        
        _ = APIService.sharedInstance.httpRequestAPI(ApiRouter.likePost(userid: userID, checknum: checknum, id: id)) { response in
            if let likePostResponse = ResponseLikePost<NewFeed>(JSON: response) {
                var newFeeds = self.phase.value ?? []
                if likePostResponse.status == 1 {
                    var newFeed = newFeeds.first(where: {$0.postid == id})
                    newFeed?.like = "1"
                    newFeed?.numLikes = likePostResponse.totallike ?? ""
                    if let index = newFeeds.firstIndex(where: { $0.postid == newFeed?.postid}) {
                        newFeeds[index] = newFeed!
                        self.phase = .success(newFeeds)
                    }
                    NotificationCenter.default.post(name: Notification.Name("likePost"), object: id)
                    
                    print("like post success")
                    self.numLikes = likePostResponse.totallike ?? ""
                    NotificationCenter.default.post(name: Notification.Name("numLikes"), object: self.numLikes)
                } else if likePostResponse.status == 2 {
                    var newFeed = newFeeds.first(where: {$0.postid == id})
                    newFeed?.like = "0"
                    newFeed?.numLikes = likePostResponse.totallike ?? ""
                    if let index = newFeeds.firstIndex(where: { $0.postid == newFeed?.postid}) {
                        newFeeds[index] = newFeed!
                        self.phase = .success(newFeeds)
                    }
                    NotificationCenter.default.post(name: Notification.Name("disLikePost"), object: id)
                    print("dislike post success")
                    self.numLikes = likePostResponse.totallike ?? ""
                    NotificationCenter.default.post(name: Notification.Name("numLikes"), object: self.numLikes)
                }
            }
        } failure: { error in
            self.error = self.generateError(description: error.localizedDescription,"delete_post")
        }
    }
    
    @Published var phaseLayoutContent = DataFetchPhase<[LayoutContent]>.empty
    var layoutContent: [LayoutContent] {
        phaseLayoutContent.value ?? []
    }
    
    @Published var layoutContentImage: [String] = []
    
    func getLayoutContent() {
        APIService.sharedInstance.httpRequestAPI(ApiRouter.getLayoutContent) { response in
            if let getLayoutResponse = BaseListResponse<LayoutContent>(JSON: response) {
                if getLayoutResponse.status == 1 {
                    let layoutContent = getLayoutResponse.data ?? []
                    self.phaseLayoutContent = .success(layoutContent)
                    for layout in layoutContent {
                        self.layoutContentImage.append(layout.image ?? "")
                    }
                    print("Get layout content success: \(getLayoutResponse.message ?? "")")
                } else {
                    print("Get layout content error: \(getLayoutResponse.message ?? "")")
                }
            }
        } failure: { error in
            print("Get layout content error: \(error.localizedDescription)")
        }
    }
    
    func updateFollowStatus(friendid: String, act: String) {
        var newFeeds = self.newFeeds.map {
            var item = $0
            if item.user_info?.userid == friendid {
                if act == "follow" {
                    item.user_info?.friend_info?.follow = "1"
                } else if act == "nofollow" {
                    item.user_info?.friend_info?.follow = "0"
                } else if act == "accept_friend" {
                    item.user_info?.friend_info?.isfriend = "1"
                }
            }
            
            return item
        }
        
        self.phase = .success(newFeeds)
    }
}
