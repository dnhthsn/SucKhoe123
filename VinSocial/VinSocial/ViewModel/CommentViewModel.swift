//
//  CommentViewModel.swift
//  VinSocial
//
//  Created by Đinh Thái Sơn on 18/04/2023.
//

import Foundation
class CommentViewModel: ObservableObject {
    @Published var isLoadingPage = false
    @Published var phase = DataFetchPhase<[CommentResponse]>.empty
    @Published var phasePostComment = DataFetchPhase<[PostCommentResponse]>.empty
    
    private(set) var currentPage = 0
    private(set) var hasReachedEnd = false
    private(set) var act = ""
    let itemsPerPage: Int = 5
    
    var nextPage: Int { currentPage + 1 }
    
    var shouldLoadNextPage: Bool {
        !hasReachedEnd
    }
    
    func reset() {
        currentPage = 0
        hasReachedEnd = false
    }
    
    var comments: [CommentResponse] {
        phase.value ?? []
    }
    
    var isFetchingNextPage: Bool {
        if case .fetchingNextPage = phase {
            return true
        }
        return false
    }
    
    var id: String = ""
    var test: String = ""
    
    init(id: String,test:String) {
        self.id = id
        print("HOIX nx init commentview model \(test)")
    }

    func removeCacheComment(){
        cacheSave.removeObject(forKey: "comments")
        self.currentPage = 0
        self.hasReachedEnd = false
        self.phase = .empty
        isLoadingPage = false
    }
    
    @Published var numComments: String = ""
    
    func loadNextPage(cid: String, pid: String, sortcomm: Int) async {
        if Task.isCancelled { return }
        DispatchQueue.main.async {
            let comments = self.phase.value ?? []
            self.phase = .fetchingNextPage(comments)
        }
        do {
            guard shouldLoadNextPage else {
                return
            }
            guard let currentUid = AuthenViewModel.shared.currentUser?.userid else{return}
            guard let checkNum = AuthenViewModel.shared.currentUser?.checknum else{return}
            let pageNext = nextPage
            print("HOIX nx init load next page \(pageNext)")
           _ = APIService.sharedInstance.httpRequestAPI(ApiRouter.getComment(userid: currentUid, checknum: checkNum, cid: cid, id: id, pid: pid, sortcomm: String(sortcomm), page: pageNext)){ response in
               if let commentResponse = CommentsModel<CommentResponse>(JSON: response){
                   guard let listComment = commentResponse.comment else{return}
                   self.numComments = String(commentResponse.num_items ?? "")
                   if Task.isCancelled { return }
                  
                   DispatchQueue.main.async {
                       var comments = self.phase.value ?? []
                       comments += listComment
                      
                       self.phase = .success(comments)
                       self.currentPage = pageNext
                       print("Comment current page comment: \(self.currentPage)")

                       print("HOIX NX test fsss \(self.comments.count)")
                       self.hasReachedEnd = listComment.count < self.itemsPerPage
                       
                       Task{
                           commentResponse.comment = comments
                           commentResponse.currentPage = self.currentPage
                           commentResponse.hasReachedEnd = self.hasReachedEnd
                           let json = commentResponse.toJSON()
                           let data = try! NSKeyedArchiver.archivedData(withRootObject: json,requiringSecureCoding: false)
                           cacheSave.setObject(data as NSData, forKey: "comments")
                       }

                   }
                }
           } failure: { error in
               if Task.isCancelled { return }
               print(error.localizedDescription)
               self.phase = .failure(error)
           }

        }
       
    }
    
    func loadFirstPage(cid: String, pid: String, sortcomm: Int) async {
//        if Task.isCancelled { return }
        if let cachedData = cacheSave.object(forKey: "comments"),
           let myDictionary = NSKeyedUnarchiver.unarchiveObject(with: cachedData as Data) as? [String:Any] {
            if let commentResponse = CommentsModel<CommentResponse>(JSON: myDictionary){
                guard let listComment = commentResponse.comment else{return}
                DispatchQueue.main.async {
                    self.phase = .success(listComment)
                    self.currentPage = commentResponse.currentPage
                    self.hasReachedEnd = commentResponse.hasReachedEnd
                }
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
            print("HOIX nx init load frist  page \(page)")
            _ = APIService.sharedInstance.httpRequestAPI(ApiRouter.getComment(userid: currentUid, checknum: checkNum, cid: cid, id: id, pid: pid, sortcomm: String(sortcomm), page: page)){ response in
               if let commentResponse = CommentsModel<CommentResponse>(JSON: response){
                   guard let listComment = commentResponse.comment else{return}
                   self.numComments = String(commentResponse.num_items ?? "")
                   Task{
                       commentResponse.currentPage = page
                       commentResponse.hasReachedEnd = self.hasReachedEnd
                       let json = commentResponse.toJSON()
                       let data = try! NSKeyedArchiver.archivedData(withRootObject: json,requiringSecureCoding: false)
                       cacheSave.setObject(data as NSData, forKey: "comments")
                   }
                   if Task.isCancelled { return }
                   self.phase = .success(listComment)
                   var comments = self.comments
                   print("HOIX NX test fsss \(comments.count)")
                }
                self.currentPage = page
                
           } failure: { error in
               if Task.isCancelled { return }
               print(error.localizedDescription)
               self.phase = .failure(error)
           }

        }
    }

    @Published var isPostComment: Bool = false
    func postComment(id: String, cid: String, pid: String, reptouserid: String, content: String, photo_comment: Data) {
        guard let userID = AuthenViewModel.shared.currentUser?.userid else{return}
        guard let checknum = AuthenViewModel.shared.currentUser?.checknum else{return}
        APIService.sharedInstance.httpUploadFile(ApiRouter.postComment(userid: userID, checknum: checknum, id: id, cid: cid, pid: pid, reptouserid: reptouserid, content: content), file: photo_comment, fileType: "", fileName:"" , withName: "photo_comment") { response in
            if let responseUploadFile = BaseListResponse<CommentResponse>(JSON: response){
                var comments = self.phase.value ?? []
                print("HOIX NX test \(comments.count)")
                if responseUploadFile.status == 1 {
                    self.isPostComment = true
                    if let comment = responseUploadFile.data{
                        for item in comment {
                            comments.insert(item, at: 0)
                            DispatchQueue.main.async {
                                self.phase = .success(comments)
                            }
                        }
        
                        NotificationCenter.default.post(name: Notification.Name("CommentPost"), object: id)
                        
                        NotificationCenter.default.post(name: Notification.Name("NumComment"), object: String((Int(self.numComments) ?? 0) + comment.count))
                    }
                }else {
                    //error
                    self.generateError(description: "Error creare post with status \(responseUploadFile.status)", "createPost")
                    self.isPostComment = false
                }
                
            }
        } failure: { error in
            self.generateError(description: error.localizedDescription,"createPost")
            print("create post error create post")
            self.isPostComment = false
        }
    }

    @Published var isLoadingPageReply = false
    @Published var phaseReply = DataFetchPhase<[CommentResponse]>.empty
    
    private(set) var currentPageReply = 0
    private(set) var hasReachedEndReply = false

    let itemsPerPageReply: Int = 3
    
    var nextPageReply: Int { currentPageReply + 1 }
    
    var shouldLoadNextPageReply: Bool {
        !hasReachedEndReply
    }
    
    func resetReply() {
        currentPageReply = 0
        hasReachedEndReply = false
    }
    
    var replyComments: [CommentResponse] {
        phaseReply.value ?? []
    }
    
    var isFetchingNextPageReply: Bool {
        if case .fetchingNextPage = phaseReply {
            return true
        }
        return false
    }

    func removeCacheReply(){
        cacheSave.removeObject(forKey: "replies")
        self.currentPageReply = 0
        self.hasReachedEndReply = false
        self.phaseReply = .empty
        isLoadingPageReply = false
    }
    
    func loadNextPageReply(cid: String, pid: String, sortcomm: Int) async {
        if Task.isCancelled { return }
        DispatchQueue.main.async {
            let replies = self.phaseReply.value ?? []
            self.phaseReply = .fetchingNextPage(replies)
        }
        do {
            guard shouldLoadNextPageReply else {
                return
            }
            guard let currentUid = AuthenViewModel.shared.currentUser?.userid else{return}
            guard let checkNum = AuthenViewModel.shared.currentUser?.checknum else{return}
            let pageNext = nextPageReply
           _ = APIService.sharedInstance.httpRequestAPI(ApiRouter.getComment(userid: currentUid, checknum: checkNum, cid: cid, id: id, pid: pid, sortcomm: String(sortcomm), page: pageNext)){ response in
               if let replyResponse = CommentsModel<CommentResponse>(JSON: response){
                   guard let listReply = replyResponse.comment else{return}
                   if Task.isCancelled { return }
                  
                   DispatchQueue.main.async {
                       var replies = self.phaseReply.value ?? []
                       replies += listReply
                      
                       self.phaseReply = .success(replies)
                       self.currentPageReply = pageNext
                       self.hasReachedEndReply = listReply.count < self.itemsPerPageReply
                       
                       Task{
                           replyResponse.comment = replies
                           replyResponse.currentPage = self.currentPageReply
                           replyResponse.hasReachedEnd = self.hasReachedEndReply
                           let json = replyResponse.toJSON()
                           let data = try! NSKeyedArchiver.archivedData(withRootObject: json,requiringSecureCoding: false)
                           cacheSave.setObject(data as NSData, forKey: "replies")
                       }

                   }
                }
           } failure: { error in
               if Task.isCancelled { return }
               print(error.localizedDescription)
               self.phaseReply = .failure(error)
           }

        }
       
    }
    
    func loadFirstPageReply(cid: String, pid: String, sortcomm: Int) async {
//        if Task.isCancelled { return }
        if let cachedData = cacheSave.object(forKey: "replies"),
           let myDictionary = NSKeyedUnarchiver.unarchiveObject(with: cachedData as Data) as? [String:Any] {
            if let replyResponse = CommentsModel<CommentResponse>(JSON: myDictionary){
                guard let listReply = replyResponse.comment else{return}
                DispatchQueue.main.async {
                    self.phaseReply = .success(listReply)
                    self.currentPageReply = replyResponse.currentPage
                    self.hasReachedEndReply = replyResponse.hasReachedEnd
                }
                return
            }
        }
        
        DispatchQueue.main.async {
            self.phaseReply = .empty
        }
        
        do {
            resetReply()
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
            let page = nextPageReply;
            _ = APIService.sharedInstance.httpRequestAPI(ApiRouter.getComment(userid: currentUid, checknum: checkNum, cid: cid, id: id, pid: pid, sortcomm: String(sortcomm), page: page)){ response in
               if let replyResponse = CommentsModel<CommentResponse>(JSON: response){
                   guard let listReply = replyResponse.comment else{return}
                   Task{
                       replyResponse.currentPage = page
                       replyResponse.hasReachedEnd = self.hasReachedEndReply
                       let json = replyResponse.toJSON()
                       let data = try! NSKeyedArchiver.archivedData(withRootObject: json,requiringSecureCoding: false)
                       cacheSave.setObject(data as NSData, forKey: "replies")
                   }
                   if Task.isCancelled { return }
                   self.phaseReply = .success(listReply)
                }
                self.currentPageReply = page
           } failure: { error in
               if Task.isCancelled { return }
               print(error.localizedDescription)
               self.phaseReply = .failure(error)
           }

        }
    }
    
    func responseComment(id: String, cid: String, pid: String, reptouserid: String, content: String, photo_comment: Data) {
        guard let userID = AuthenViewModel.shared.currentUser?.userid else{return}
        guard let checknum = AuthenViewModel.shared.currentUser?.checknum else{return}
        APIService.sharedInstance.httpUploadFile(ApiRouter.postComment(userid: userID, checknum: checknum, id: id, cid: cid, pid: pid, reptouserid: reptouserid, content: content), file: photo_comment, fileType: "", fileName:"" , withName: "photo_comment") { response in
            if let responseUploadFile = BaseListResponse<CommentResponse>(JSON: response){
                if responseUploadFile.status == 1{
                    if let reply = responseUploadFile.data{
                        var replies = self.phaseReply.value ?? []
                        replies.insert(contentsOf: reply, at: 0)
                        self.phaseReply = .success(replies)
                    }
                }else {
                    //error
                    self.generateError(description: "Error creare post with status \(responseUploadFile.status)", "createPost")
                }
                
            }
        } failure: { error in
            self.generateError(description: error.localizedDescription,"createPost")
            print("create post error create post")
        }
    }
    
    private func generateError(code: Int = 0, description: String,_ domain:String) -> Error {
        NSError(domain: domain, code: code, userInfo: [NSLocalizedDescriptionKey: description])
    }
}
