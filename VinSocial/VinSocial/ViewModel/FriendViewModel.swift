//
//  FriendViewModel.swift
//  Suckhoe123
//
//  Created by Đinh Thái Sơn on 18/05/2023.
//

import Foundation

class FriendViewModel: ObservableObject {
    @Published var messageMakeFriend: String = ""
    @Published var error: Error?
    @Published var showLoading: Bool = false
    
    func makeFriend(friendid: String, act: String, verifykey: String) {
        self.showLoading = true
        guard let userID = AuthenViewModel.shared.currentUser?.userid else{return}
        guard let checknum = AuthenViewModel.shared.currentUser?.checknum else{return}
        
        _ = APIService.sharedInstance.httpRequestAPI(ApiRouter.makeFriend(userid: userID, checknum: checknum, friendid: friendid, act: act, verifykey: verifykey)) { response in
            
            if let responseMakeFriend = BaseResponseMakeFriend(JSON: response){
                if responseMakeFriend.status == 1{
                    // sucess
                    self.messageMakeFriend = responseMakeFriend.mess ?? ""
                    self.showLoading = false
                    
                    if act == "follow" {
                        NotificationCenter.default.post(name: Notification.Name("follow"), object: friendid)
                        
                        NotificationCenter.default.post(name: Notification.Name("act_follow"), object: act)
                        
                    } else if act == "accept_friend" {
                        NotificationCenter.default.post(name: Notification.Name("accept_friend"), object: friendid)
                        
                        NotificationCenter.default.post(name: Notification.Name("act_accept_friend"), object: act)
                    } else if act == "nofollow" {
                        NotificationCenter.default.post(name: Notification.Name("nofollow"), object: friendid)
                        
                        NotificationCenter.default.post(name: Notification.Name("act_nofollow"), object: act)
                    }

                }else {
                    //error
                    self.generateError(description: "Error creare post with status \(String(describing: responseMakeFriend.status) )", "createPost")
                    self.showLoading = false
                }
                
            }
        } failure: { error in
            self.error = self.generateError(description: error.localizedDescription,"createPost")
            print("create post error create post")
            self.showLoading = false
        }
    }
    
    @Published var isLoadingPageFriend = false
    @Published var phaseFriend = DataFetchPhase<[ListFriend]>.empty
    private(set) var currentPageFriend = 0
    private(set) var hasReachedEndFriend = false
    let itemsPerPageFriend: Int = 12
    @Published var numFriend: String = ""
    
    var nextPageFriend: Int { currentPageFriend + 1 }
    
    var shouldLoadNextPageFriend: Bool {
        !hasReachedEndFriend
    }
    
    func resetFriend() {
        currentPageFriend = 0
        hasReachedEndFriend = false
    }
    
    var listFriend: [ListFriend] {
        phaseFriend.value ?? []
    }
    
    var isFetchingNextPageFriend: Bool {
        if case .fetchingNextPage = phaseFriend {
            return true
        }
        return false
    }
    
//    func loadDataGroup(act: String, groupby: Int){
//        Task {await loadFirstPageGroup(act: act, groupby: groupby)}
//    }
//
    func removeCacheFriend(){
        cacheSave.removeObject(forKey: "listFriend")
        self.currentPageFriend = 0
        self.hasReachedEndFriend = false
        self.phaseFriend = .empty
        isLoadingPageFriend = false
    }
    
    func removeFriendList(userid: String){
        var friend = self.phaseFriend.value ?? []
        friend.removeAll(where: { $0.userid == userid})
        self.phaseFriend = .success(friend)
    }
    
    func loadFirstPageFriend(friendid: String, sort: Int, completion: @escaping ([ListFriend]) ->Void) async {
        if Task.isCancelled { return }
        if let cachedData = cacheSave.object(forKey: "listFriend"),
           let myDictionary = NSKeyedUnarchiver.unarchiveObject(with: cachedData as Data) as? [String:Any] {
//           let myDictionary = try? NSKeyedUnarchiver.unarchivedObject(ofClass: NSDictionary.self, from: cachedData as Data) as? [String: Any] {
            if let listFriendResponse = ListResponseFriend(JSON: myDictionary){
                guard let listFriend = listFriendResponse.data else{return}
                DispatchQueue.main.async {
                    self.phaseFriend = .success(listFriend)
                    self.currentPageFriend = listFriendResponse.currentPage
                    self.hasReachedEndFriend = listFriendResponse.hasReachedEnd
                }
                print("load from cache")
                return
            }
            
        }
        
        DispatchQueue.main.async {
            self.phaseFriend = .empty
        }
        
        do {
            resetFriend()
            
            guard let userID = AuthenViewModel.shared.currentUser?.userid else{return}
            guard let checknum = AuthenViewModel.shared.currentUser?.checknum else{return}
            
            let page = nextPageFriend;
            _ = APIService.sharedInstance.httpRequestAPI(ApiRouter.listFriend(userid: userID, checknum: checknum, friendid: friendid, sort: sort, page: page)){ response in
               if let listFriendResponse = ListResponseFriend(JSON: response){
                   if listFriendResponse.status == 1 {
                     self.numFriend = listFriendResponse.numfriend ?? ""
                       guard let listFriend = listFriendResponse.data else{return}
                       Task{

                           listFriendResponse.currentPage = page
                           listFriendResponse.hasReachedEnd = self.hasReachedEndFriend
                           let json = listFriendResponse.toJSON()
                           let data = try! NSKeyedArchiver.archivedData(withRootObject: json,requiringSecureCoding: false)
                           cacheSave.setObject(data as NSData, forKey: "listFriend")
//                           }
                       }
                       if Task.isCancelled { return }
                       self.phaseFriend = .success(listFriend)
                     completion(listFriend)
                   }else{
                       if Task.isCancelled { return }
                   }
                }
                self.currentPageFriend = page
           } failure: { error in
               if Task.isCancelled { return }
               print(error.localizedDescription)
               self.phaseFriend = .failure(error)
           }

        }
    }
    
    
    
    func loadNextPageFriend(friendid: String, sort: Int, completion: @escaping ([ListFriend]) ->Void) async {
        if Task.isCancelled { return }
        DispatchQueue.main.async {
            let listFriend = self.phaseFriend.value ?? []
            self.phaseFriend = .fetchingNextPage(listFriend)
        }
        do {
            guard shouldLoadNextPageFriend else {
                return
            }
            
            guard let userID = AuthenViewModel.shared.currentUser?.userid else{return}
            guard let checknum = AuthenViewModel.shared.currentUser?.checknum else{return}
            
            let pageNext = nextPageFriend
            
            _ = APIService.sharedInstance.httpRequestAPI(ApiRouter.listFriend(userid: userID, checknum: checknum, friendid: friendid, sort: sort, page: pageNext)){ response in
                if let listFriendResponse = ListResponseFriend(JSON: response){
                   if listFriendResponse.status == 1 {
                       guard let listFriends = listFriendResponse.data else{return}
                       if Task.isCancelled { return }
                      
                       DispatchQueue.main.async {
                           var listFriend = self.phaseFriend.value ?? []
                           listFriend += listFriends
                           self.phaseFriend = .success(listFriend)
                           self.currentPageFriend = pageNext
                           self.hasReachedEndFriend = listFriends.count < self.itemsPerPageFriend
                           
                           Task{
                               listFriendResponse.data = listFriend
                               listFriendResponse.currentPage = self.currentPageFriend
                               listFriendResponse.hasReachedEnd = self.hasReachedEndFriend
                               let json = listFriendResponse.toJSON()
                               let data = try! NSKeyedArchiver.archivedData(withRootObject: json,requiringSecureCoding: false)
                               cacheSave.setObject(data as NSData, forKey: "listFriend")
                               completion(listFriend)
                           }

                       }
                       
                   }else{
                       if Task.isCancelled { return }
                   }
                }
           } failure: { error in
               if Task.isCancelled { return }
               print(error.localizedDescription)
               self.phaseFriend = .failure(error)
           }

        }
       
    }
    
    private func generateError(code: Int = 0, description: String,_ domain:String) -> Error {
        NSError(domain: domain, code: code, userInfo: [NSLocalizedDescriptionKey: description])
    }
}
