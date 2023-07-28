//
//  MediaUserViewModel.swift
//  Suckhoe123
//
//  Created by Đinh Thái Sơn on 22/05/2023.
//

import Foundation

class MediaUserViewModel : ObservableObject {
    @Published var isLoadingPage = false
    @Published var error: Error?
    @Published var phase = DataFetchPhase<[MediaUser]>.empty
    private(set) var currentPage = 0
    private(set) var hasReachedEnd = false
    let itemsPerPage: Int = 3
    
    var nextPage: Int { currentPage + 1 }
    
    var shouldLoadNextPage: Bool {
        !hasReachedEnd
    }
    
    func reset() {
        currentPage = 0
        hasReachedEnd = false
    }
    
    var mediaUsers: [MediaUser] {
        phase.value ?? []
    }
    
    var isFetchingNextPage: Bool {
        if case .fetchingNextPage = phase {
            return true
        }
        return false
    }
    
    func loadData(mediatype: Int, friendid: String, sort: Int, page: Int){
        if AuthenViewModel.shared.currentUser != nil {
            Task {await loadFirstPage(mediatype: mediatype, friendid: friendid, sort: sort)}
        }
    }
    
    func removeCache(){
        cacheSave.removeObject(forKey: "mediaUser")
        self.currentPage = 0
        self.hasReachedEnd = false
        self.phase = .empty
        isLoadingPage = false
    }
    
    func loadNextPage(mediatype: Int, friendid: String, sort: Int) async {
        if Task.isCancelled { return }
        DispatchQueue.main.async {
            let mediaUsers = self.phase.value ?? []
            self.phase = .fetchingNextPage(mediaUsers)
        }
        do {
            guard shouldLoadNextPage else {
                return
            }
            guard let currentUid = AuthenViewModel.shared.currentUser?.userid else{return}
            guard let checkNum = AuthenViewModel.shared.currentUser?.checknum else{return}
            let pageNext = nextPage
            _ = APIService.sharedInstance.httpRequestAPI(ApiRouter.getMediaUser(userid: currentUid, checknum: checkNum, mediatype: mediatype, friendid: friendid, sort: sort, page: pageNext)){ response in
               if let mediaUserResponse = ResponseMediaUser<MediaUser>(JSON: response){
                   if mediaUserResponse.status == 1 {
                       guard let listMediaUser = mediaUserResponse.data else{return}
                       
                       let filtered = listMediaUser.filter { ($0.filename != nil && $0.filename != "") }

                       if Task.isCancelled { return }
                      
                       DispatchQueue.main.async {
                           var mediaUsers = self.phase.value ?? []
                           mediaUsers += filtered
                           self.phase = .success(mediaUsers)
                           self.currentPage = pageNext
                           self.hasReachedEnd = listMediaUser.count < self.itemsPerPage
                           
                           Task{
                               mediaUserResponse.data = mediaUsers
                               mediaUserResponse.currentPage = self.currentPage
                               mediaUserResponse.hasReachedEnd = self.hasReachedEnd
                               let json = mediaUserResponse.toJSON()
                               let data = try! NSKeyedArchiver.archivedData(withRootObject: json,requiringSecureCoding: false)
                               cacheSave.setObject(data as NSData, forKey: "mediaUser")
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
    
    func loadFirstPage(mediatype: Int, friendid: String, sort: Int) async {
        if Task.isCancelled { return }
        if let cachedData = cacheSave.object(forKey: "mediaUser"),
           let myDictionary = NSKeyedUnarchiver.unarchiveObject(with: cachedData as Data) as? [String:Any] {

            if let mediaUserResponse = ResponseMediaUser<MediaUser>(JSON: myDictionary){
                guard let listMediaUser = mediaUserResponse.data else{return}
                DispatchQueue.main.async {
                    self.phase = .success(listMediaUser)
                    self.currentPage = mediaUserResponse.currentPage
                    self.hasReachedEnd = mediaUserResponse.hasReachedEnd
                }
                return
            }
            
        }
        
        DispatchQueue.main.async {
            self.phase = .empty
        }
        
        do {
            reset()
            guard let currentUid = AuthenViewModel.shared.currentUser?.userid else{return}
            guard let checkNum = AuthenViewModel.shared.currentUser?.checknum else{return}
            let page = nextPage;
            _ = APIService.sharedInstance.httpRequestAPI(ApiRouter.getMediaUser(userid: currentUid, checknum: checkNum, mediatype: mediatype, friendid: friendid, sort: sort, page: page)){ response in
               if let mediaUserResponse = ResponseMediaUser<MediaUser>(JSON: response){
                 if mediaUserResponse.status == 1 {
                       guard let listMediaUser = mediaUserResponse.data else{return}
                       let filtered = listMediaUser.filter { ($0.filename != "") }
                     for user in filtered {
                         print("url image from loading \(user.id)")
                     }

                       Task{

                           mediaUserResponse.currentPage = page
                           mediaUserResponse.hasReachedEnd = self.hasReachedEnd
                           let json = mediaUserResponse.toJSON()
                           let data = try! NSKeyedArchiver.archivedData(withRootObject: json,requiringSecureCoding: false)
                           cacheSave.setObject(data as NSData, forKey: "mediaUser")
//                           }
                       }
                       if Task.isCancelled { return }
                       self.phase = .success(filtered)
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
}
