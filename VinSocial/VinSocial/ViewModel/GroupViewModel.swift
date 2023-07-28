//
//  GroupViewModel.swift
//  Suckhoe123
//
//  Created by Đinh Thái Sơn on 16/05/2023.
//

import Foundation
import ObjectMapper

class GroupViewModel: ObservableObject {
    @Published var isCreateGroup = false
    @Published var error: Error?
    @Published var group: GroupModel?
    @Published var groupInfo: GroupInfo?
    @Published var groupCatalog:[GroupCatalog]? = []
    
    func leaveGroup(act: String, groupid: String) {
        guard let userID = AuthenViewModel.shared.currentUser?.userid else{return}
        guard let checknum = AuthenViewModel.shared.currentUser?.checknum else{return}
        
        _ = APIService.sharedInstance.httpRequestAPI(ApiRouter.leaveGroup(act: act, userid: userID, checknum: checknum, groupid: groupid)) { response in
            if let leaveGroupResponse = BaseResponseMakeFriend(JSON: response) {
                if leaveGroupResponse.status == 1 {
                    print("leave success")
                }
            }
        } failure: { error in
            self.error = self.generateError(description: error.localizedDescription,"leave_group")
        }
    }

    func getGroupCatalog(act: String) {
        _ = APIService.sharedInstance.httpRequestAPI(ApiRouter.groupCatalog(act: act)) { response in
            if let groupCatalogResponse = BaseListResponse<GroupCatalog>(JSON: response) {
                if groupCatalogResponse.status == 1 {
                    self.groupCatalog = groupCatalogResponse.data
                }
            }
        } failure: { error in
            self.error = self.generateError(description: error.localizedDescription,"groupCatalog")
        }
    }
    
    func createGroup(act: String, title: String, about: String, grouptype: Int, banner: Data, catid: String, member: Int, completion: @escaping (GroupModel) ->Void) {
        guard let userID = AuthenViewModel.shared.currentUser?.userid else{return}
        guard let checknum = AuthenViewModel.shared.currentUser?.checknum else{return}
        isCreateGroup = true
        APIService.sharedInstance.httpUploadFile(ApiRouter.createGroup(act: act, userid: userID, checknum: checknum, title: title, about: about, grouptype: grouptype, catid: catid, member: member), file: banner, fileType: "", fileName:"" , withName: "banner") { response in
            self.isCreateGroup = false
            if let responseUploadFile = ResponseGroup<GroupModel>(JSON: response){
                if responseUploadFile.status == 1{
                    // sucess
                    self.group?.groupid = responseUploadFile.groupid
                    let groupModel = GroupModel(groupid: responseUploadFile.groupid!)
                    //self.getGroupInfo(groupid: Int(responseUploadFile.groupid ?? "")!)
                    completion(groupModel)
                }else {
                    //error
                    self.generateError(description: "Error creare post with status \(String(describing: responseUploadFile.status) )", "createPost")
                }
                
            }
        } failure: { error in
            self.isCreateGroup = false
            self.error = self.generateError(description: error.localizedDescription,"createPost")
            print("create post error create post")
            
        }
    }
    
    func getGroupInfo(groupid: String, completion: @escaping (GroupInfo) ->Void) {
        guard let userID = AuthenViewModel.shared.currentUser?.userid else{return}
        guard let checknum = AuthenViewModel.shared.currentUser?.checknum else{return}
        
        APIService.sharedInstance.httpRequestAPI(ApiRouter.groupInfo(userid: userID, checknum: checknum, groupid: groupid)) { response in
            if let groupInfoRes = BaseResponse<GroupInfo>(JSON: response){
                if groupInfoRes.status == 1{
                    // sucess
                    self.groupInfo = groupInfoRes.data
                    let id = groupInfoRes.data?.id
                    let catid = groupInfoRes.data?.catid
                    let title = groupInfoRes.data?.title
                    let banner = groupInfoRes.data?.banner
                    let about = groupInfoRes.data?.about
                    let membertotal = groupInfoRes.data?.membertotal
                    let grouptype = groupInfoRes.data?.grouptype
                    let addtime = groupInfoRes.data?.addtime
                    let updatetime = groupInfoRes.data?.updatetime
                    let status = groupInfoRes.data?.status
                    let groupInfo = GroupInfo(id: id ?? "", catid: catid ?? "", title: title ?? "", banner: banner ?? "", about: about ?? "", membertotal: membertotal ?? "", grouptype: grouptype ?? "", addtime: addtime ?? "", updatetime: updatetime ?? "", status: status ?? "", user_info: groupInfoRes.data?.user_info)
                    completion(groupInfo)
                }else {
                    //error
                    self.generateError(description: "Error creare post with status \(String(describing: groupInfoRes.status))", "createPost")
                }
                
            }
        } failure: { error in
            self.error = self.generateError(description: error.localizedDescription,"createPost")
            print("create post error create post")
            
        }
    }
    
    
    //1
    @Published var isLoadingPageGroup = false
    @Published var phaseGroup = DataFetchPhase<[GroupList]>.empty
    private(set) var currentPageGroup = 0
    private(set) var hasReachedEndGroup = false
    let itemsPerPageGroup: Int = 6
    @Published var numGroup: String = ""
    
    var nextPageGroup: Int { currentPageGroup + 1 }
    
    var shouldLoadNextPageGroup: Bool {
        !hasReachedEndGroup
    }
    
    func resetGroup() {
        currentPageGroup = 0
        hasReachedEndGroup = false
    }
    
    var groupList: [GroupList] {
        phaseGroup.value ?? []
    }
    
    var isFetchingNextPageGroup: Bool {
        if case .fetchingNextPage = phaseGroup {
            return true
        }
        return false
    }
    
//    func loadDataGroup(act: String, groupby: Int){
//        Task {await loadFirstPageGroup(act: act, groupby: groupby)}
//    }
//
    func removeCacheGroup(){
        cacheSave.removeObject(forKey: "groupList")
        self.currentPageGroup = 0
        self.hasReachedEndGroup = false
        self.phaseGroup = .empty
        isLoadingPageGroup = false
    }
    
    func loadFirstPageGroup(act: String, groupby: Int, completion: @escaping ([GroupList]) ->Void) async {
        if Task.isCancelled { return }
        if let cachedData = cacheSave.object(forKey: "groupList"),
           let myDictionary = NSKeyedUnarchiver.unarchiveObject(with: cachedData as Data) as? [String:Any] {

            if let groupListResponse = GroupListResponse(JSON: myDictionary){
                guard let listGroup = groupListResponse.data else{return}
                DispatchQueue.main.async {
                    self.phaseGroup = .success(listGroup)
                    self.currentPageGroup = groupListResponse.currentPage
                    self.hasReachedEndGroup = groupListResponse.hasReachedEnd
                }
                print("load from cache")
                return
            }
            
        }
        
        DispatchQueue.main.async {
            self.phaseGroup = .empty
        }
        
        do {
            resetGroup()
            
            guard let userID = AuthenViewModel.shared.currentUser?.userid else{return}
            guard let checknum = AuthenViewModel.shared.currentUser?.checknum else{return}
            
            let page = nextPageGroup;
            _ = APIService.sharedInstance.httpRequestAPI(ApiRouter.groupList(userid: userID, checknum: checknum, act: act, groupby: groupby, page: page)){ response in
               if let groupListResponse = GroupListResponse(JSON: response){
                 if groupListResponse.status == 1 {
                     self.numGroup = groupListResponse.numgroup ?? ""
                       guard let listGroup = groupListResponse.data else{return}
                       Task{

                           groupListResponse.currentPage = page
                           groupListResponse.hasReachedEnd = self.hasReachedEndGroup
                           let json = groupListResponse.toJSON()
                           let data = try! NSKeyedArchiver.archivedData(withRootObject: json,requiringSecureCoding: false)
                           cacheSave.setObject(data as NSData, forKey: "groupList")
//                           }
                       }
                       if Task.isCancelled { return }
                       self.phaseGroup = .success(listGroup)
                     completion(listGroup)
                   }else{
                       if Task.isCancelled { return }
                   }
                }
                self.currentPageGroup = page
           } failure: { error in
               if Task.isCancelled { return }
               print(error.localizedDescription)
               self.phaseGroup = .failure(error)
           }

        }
    }
    
    func loadNextPageGroup(act: String, groupby: Int, completion: @escaping ([GroupList]) ->Void) async {
        if Task.isCancelled { return }
        DispatchQueue.main.async {
            let groupList = self.phaseGroup.value ?? []
            self.phaseGroup = .fetchingNextPage(groupList)
        }
        do {
            guard shouldLoadNextPageGroup else {
                return
            }
            
            guard let userID = AuthenViewModel.shared.currentUser?.userid else{return}
            guard let checknum = AuthenViewModel.shared.currentUser?.checknum else{return}
            
            let pageNext = nextPageGroup
            
            _ = APIService.sharedInstance.httpRequestAPI(ApiRouter.groupList(userid: userID, checknum: checknum, act: act, groupby: groupby, page: pageNext)){ response in
               if let groupListResponse = GroupListResponse(JSON: response){
                   if groupListResponse.status == 1 {
                       guard let listGroup = groupListResponse.data else{return}
                       if Task.isCancelled { return }
                      
                       DispatchQueue.main.async {
                           var groupList = self.phaseGroup.value ?? []
                           groupList += listGroup
                           self.phaseGroup = .success(groupList)
                           self.currentPageGroup = pageNext
                           self.hasReachedEndGroup = listGroup.count < self.itemsPerPageGroup
                           
                           Task{
                               groupListResponse.data = groupList
                               groupListResponse.currentPage = self.currentPageGroup
                               groupListResponse.hasReachedEnd = self.hasReachedEndGroup
                               let json = groupListResponse.toJSON()
                               let data = try! NSKeyedArchiver.archivedData(withRootObject: json,requiringSecureCoding: false)
                               cacheSave.setObject(data as NSData, forKey: "groupList")
                           }
                           completion(groupList)
                       }
                       
                   }else{
                       if Task.isCancelled { return }
                   }
                }
           } failure: { error in
               if Task.isCancelled { return }
               print(error.localizedDescription)
               self.phaseGroup = .failure(error)
           }

        }
       
    }
    
    //Group member
    @Published var isLoadingPageMember = false
    @Published var phaseMember = DataFetchPhase<[GroupMember]>.empty
    private(set) var currentPageMember = 0
    private(set) var hasReachedEndMember = false
    let itemsPerPageMember: Int = 5
    
    var nextPageMember: Int { currentPageMember + 1 }
    
    var shouldLoadNextPageMember: Bool {
        !hasReachedEndMember
    }
    
    func resetMember() {
        currentPageMember = 0
        hasReachedEndMember = false
    }
    
    var groupMembers: [GroupMember] {
        phaseMember.value ?? []
    }
    @Published var groupMemberId: [String] = []
    
    var isFetchingNextPageMember: Bool {
        if case .fetchingNextPage = phaseMember {
            return true
        }
        return false
    }
    
    func removeCacheMember(){
        cacheSave.removeObject(forKey: "groupMember")
        self.currentPageMember = 0
        self.hasReachedEndMember = false
        self.phaseMember = .empty
        isLoadingPageMember = false
    }
    
    func loadFirstPageMember(act: String, groupid: String, usertype: String) async {
        if Task.isCancelled { return }
        if let cachedData = cacheSave.object(forKey: "groupMember"),
           let myDictionary = NSKeyedUnarchiver.unarchiveObject(with: cachedData as Data) as? [String:Any] {
            if let memberResponse = BaseListResponse<GroupMember>(JSON: myDictionary){
                guard let groupMembers = memberResponse.data else{return}
                DispatchQueue.main.async {
                    self.phaseMember = .success(groupMembers)
                    self.currentPageMember = memberResponse.currentPage
                    self.hasReachedEndMember = memberResponse.hasReachedEnd
                }
                print("load from cache")
                return
            }

        }
        
        DispatchQueue.main.async {
            self.phaseMember = .empty
        }
        
        do {
            resetMember()
            
            guard let userID = AuthenViewModel.shared.currentUser?.userid else{return}
            guard let checknum = AuthenViewModel.shared.currentUser?.checknum else{return}
            
            let page = nextPageMember;
            _ = APIService.sharedInstance.httpRequestAPI(ApiRouter.memberGroup(act: act, userid: userID, checknum: checknum, groupid: groupid, usertype: usertype, page: page)){ response in
               if let memberResponse = BaseListResponse<GroupMember>(JSON: response){
                 if memberResponse.status == 1 {
                       guard let groupMembers = memberResponse.data else{return}
                       Task{

                           memberResponse.currentPage = page
                           memberResponse.hasReachedEnd = self.hasReachedEndMember
                           let json = memberResponse.toJSON()
                           let data = try! NSKeyedArchiver.archivedData(withRootObject: json,requiringSecureCoding: false)
                           cacheSave.setObject(data as NSData, forKey: "groupMember")
                       }
                       if Task.isCancelled { return }
                     DispatchQueue.main.async {
                         self.phaseMember = .success(groupMembers)
                     }
                       
                     
                     self.groupMemberId.removeAll()
                     for member in groupMembers {
                         self.groupMemberId.append(member.userid ?? "")
                     }
                     
                   }else{
                       if Task.isCancelled { return }
                   }
                }
                self.currentPageMember = page
           } failure: { error in
               if Task.isCancelled { return }
               print(error.localizedDescription)
               self.phaseMember = .failure(error)
           }

        }
    }
    
    func loadNextPageMember(act: String, groupid: String, usertype: String) async {
        if Task.isCancelled { return }
        DispatchQueue.main.async {
            let groupMembers = self.phaseMember.value ?? []
            self.phaseMember = .fetchingNextPage(groupMembers)
        }
        do {
            guard shouldLoadNextPageMember else {
                return
            }
            
            guard let userID = AuthenViewModel.shared.currentUser?.userid else{return}
            guard let checknum = AuthenViewModel.shared.currentUser?.checknum else{return}
            
            let pageNext = nextPageMember
            
            _ = APIService.sharedInstance.httpRequestAPI(ApiRouter.memberGroup(act: act, userid: userID, checknum: checknum, groupid: groupid, usertype: usertype, page: pageNext)){ response in
               if let memberResponse = BaseListResponse<GroupMember>(JSON: response){
                   if memberResponse.status == 1 {
                       guard let listGroupMembers = memberResponse.data else{return}
                       if Task.isCancelled { return }
                      
                       DispatchQueue.main.async {
                           var groupMember = self.phaseMember.value ?? []
                           groupMember += listGroupMembers
                           self.phaseMember = .success(groupMember)
                           self.currentPageMember = pageNext
                           self.hasReachedEndMember = listGroupMembers.count < self.itemsPerPageMember
                           
                           Task{
                               memberResponse.data = groupMember
                               memberResponse.currentPage = self.currentPageMember
                               memberResponse.hasReachedEnd = self.hasReachedEndMember
                               let json = memberResponse.toJSON()
                               let data = try! NSKeyedArchiver.archivedData(withRootObject: json,requiringSecureCoding: false)
                               cacheSave.setObject(data as NSData, forKey: "groupMember")
                           }
                           
                           self.groupMemberId.removeAll()
                           for member in groupMember {
                               self.groupMemberId.append(member.userid ?? "")
                           }
                       }
                       
                   }else{
                       if Task.isCancelled { return }
                   }
                }
           } failure: { error in
               if Task.isCancelled { return }
               print(error.localizedDescription)
               self.phaseMember = .failure(error)
           }

        }
       
    }
    
    //End Group Member
    
    //Group Admin
    @Published var isLoadingPageAdmin = false
    @Published var phaseAdmin = DataFetchPhase<[GroupMember]>.empty
    private(set) var currentPageAdmin = 0
    private(set) var hasReachedEndAdmin = false
    let itemsPerPageAdmin: Int = 3
    
    var nextPageAdmin: Int { currentPageAdmin + 1 }
    
    var shouldLoadNextPageAdmin: Bool {
        !hasReachedEndAdmin
    }
    
    func resetAdmin() {
        currentPageAdmin = 0
        hasReachedEndAdmin = false
    }
    
    var groupAdmins: [GroupMember] {
        phaseAdmin.value ?? []
    }
    @Published var groupAdminId: [String] = []
    
    var isFetchingNextPageAdmin: Bool {
        if case .fetchingNextPage = phaseAdmin {
            return true
        }
        return false
    }
    
//    func loadDataMember(act: String, groupid: String, usertype: String){
//        Task {await loadFirstPageMember(act: act, groupid: groupid, usertype: usertype)}
//    }
    
    func removeCacheAdmin(){
        cacheSave.removeObject(forKey: "groupAdmin")
        self.currentPageAdmin = 0
        self.hasReachedEndAdmin = false
        self.phaseAdmin = .empty
        isLoadingPageAdmin = false
    }
    
    func loadFirstPageAdmin(act: String, groupid: String, usertype: String) async {
        if Task.isCancelled { return }
        if let cachedData = cacheSave.object(forKey: "groupAdmin"),
           let myDictionary = NSKeyedUnarchiver.unarchiveObject(with: cachedData as Data) as? [String:Any] {
//           let myDictionary = try? NSKeyedUnarchiver.unarchivedObject(ofClass: NSDictionary.self, from: cachedData as Data) as? [String: Any] {
            if let adminResponse = BaseListResponse<GroupMember>(JSON: myDictionary){
                guard let groupAdmins = adminResponse.data else{return}
                DispatchQueue.main.async {
                    self.phaseAdmin = .success(groupAdmins)
                    self.currentPageAdmin = adminResponse.currentPage
                    self.hasReachedEndAdmin = adminResponse.hasReachedEnd
                }
                print("load from cache")
                return
            }
            
        }
        
        DispatchQueue.main.async {
            self.phaseAdmin = .empty
        }
        
        do {
            resetAdmin()
            
            guard let userID = AuthenViewModel.shared.currentUser?.userid else{return}
            guard let checknum = AuthenViewModel.shared.currentUser?.checknum else{return}
            
            let page = nextPageAdmin;
            _ = APIService.sharedInstance.httpRequestAPI(ApiRouter.memberGroup(act: act, userid: userID, checknum: checknum, groupid: groupid, usertype: usertype, page: page)){ response in
               if let adminResponse = BaseListResponse<GroupMember>(JSON: response){
                 if adminResponse.status == 1 {
                       guard let groupAdmins = adminResponse.data else{return}
                       Task{

                           adminResponse.currentPage = page
                           adminResponse.hasReachedEnd = self.hasReachedEndAdmin
                           let json = adminResponse.toJSON()
                           let data = try! NSKeyedArchiver.archivedData(withRootObject: json,requiringSecureCoding: false)
                           cacheSave.setObject(data as NSData, forKey: "groupAdmin")
//                           }
                       }
                       if Task.isCancelled { return }
                       self.phaseAdmin = .success(groupAdmins)
                     //self.groupMemberId.removeAll()
//                     for member in groupAdmins {
//                         self.groupMemberId.append(member.userid ?? "")
//                     }
                     
                   }else{
                       if Task.isCancelled { return }
                   }
                }
                self.currentPageAdmin = page
           } failure: { error in
               if Task.isCancelled { return }
               print(error.localizedDescription)
               self.phaseAdmin = .failure(error)
           }

        }
    }
    
    func loadNextPageAdmin(act: String, groupid: String, usertype: String) async {
        if Task.isCancelled { return }
        DispatchQueue.main.async {
            let groupAdmins = self.phaseAdmin.value ?? []
            self.phaseAdmin = .fetchingNextPage(groupAdmins)
        }
        do {
            guard shouldLoadNextPageAdmin else {
                return
            }
            
            guard let userID = AuthenViewModel.shared.currentUser?.userid else{return}
            guard let checknum = AuthenViewModel.shared.currentUser?.checknum else{return}
            
            let pageNext = nextPageAdmin
            print("current page: \(pageNext)")
            
            _ = APIService.sharedInstance.httpRequestAPI(ApiRouter.memberGroup(act: act, userid: userID, checknum: checknum, groupid: groupid, usertype: usertype, page: pageNext)){ response in
               if let adminResponse = BaseListResponse<GroupMember>(JSON: response){
                   if adminResponse.status == 1 {
                       guard let groupAdmins = adminResponse.data else{return}
                       if Task.isCancelled { return }
                      
                       DispatchQueue.main.async {
                           var groupAdmin = self.phaseAdmin.value ?? []
                           groupAdmin += groupAdmins
                           self.phaseAdmin = .success(groupAdmin)
                           self.currentPageAdmin = pageNext
                           self.hasReachedEndAdmin = groupAdmins.count < self.itemsPerPageAdmin
                           
                           Task{
                               adminResponse.data = groupAdmin
                               adminResponse.currentPage = self.currentPageAdmin
                               adminResponse.hasReachedEnd = self.hasReachedEndAdmin
                               let json = adminResponse.toJSON()
                               let data = try! NSKeyedArchiver.archivedData(withRootObject: json,requiringSecureCoding: false)
                               cacheSave.setObject(data as NSData, forKey: "groupAdmin")
                           }
                           
                           //self.groupMemberId.removeAll()
//                           for member in groupAdmin {
//                               self.groupMemberId.append(member.userid ?? "")
//                           }
                       }
                       
                   }else{
                       if Task.isCancelled { return }
                   }
                }
           } failure: { error in
               if Task.isCancelled { return }
               print(error.localizedDescription)
               self.phaseAdmin = .failure(error)
           }

        }
       
    }
    
    //End Group Admin
    
    @Published var isInvited = false
    @Published var loading = false
    func inviteMember(act: String, groupid: String, usertype: String, memberid: String, completion: @escaping (Bool) -> Void) {
        self.loading = true
        guard let userID = AuthenViewModel.shared.currentUser?.userid else{return}
        guard let checknum = AuthenViewModel.shared.currentUser?.checknum else{return}
        
        _ = APIService.sharedInstance.httpRequestAPI(ApiRouter.inviteMember(act: act, userid: userID, checknum: checknum, groupid: groupid, usertype: usertype, memberid: memberid)) { response in
            if let inviteRespone = BaseResponseMakeFriend(JSON: response) {
                
                if inviteRespone.status == 1 {
                    self.isInvited = true
                    self.loading = false
                    NotificationCenter.default.post(name: Notification.Name("inviteMember"), object: memberid)
                    completion(true)
                } else {
                    self.isInvited = false
                    self.loading = false
                    completion(false)
                }
            } else {
                self.isInvited = false
                self.loading = false
                completion(false)
            }
        } failure: { error in
            print(error.localizedDescription)
            self.isInvited = false
            self.loading = false
            completion(false)
        }
                                                     
    }
    
    @Published var isCreatePost = false
    @Published var phaseNewFeed = DataFetchPhase<[NewFeed]>.empty
    
    @Published var isLoadingPage = false
    @Published var isLogin = false
    @Published var isCancelSearch = false
    @Published var newFeedSearchs:[NewFeed] = []
    
    private(set) var currentPage = 0
    private(set) var hasReachedEnd = false
    private(set) var act = ""
    let itemsPerPage: Int = 6
    
    var nextPage: Int { currentPage + 1 }
    
    var shouldLoadNextPage: Bool {
        !hasReachedEnd
    }
    
    func reset() {
        currentPage = 0
        hasReachedEnd = false
    }

    var newFeeds: [NewFeed] {
        phaseNewFeed.value ?? []
    }

    var isFetchingNextPage: Bool {
        if case .fetchingNextPage = phaseNewFeed {
            return true
        }
        return false
    }

    func loadData(act: String, groupid: String){
        Task {await loadFirstPage(act: act, groupid: groupid)}
    }
    
    //remove cache when logout and login lại
    func removeCache(){
        cacheSave.removeObject(forKey: "newfeedGroup")
        self.currentPage = 0
        self.hasReachedEnd = false
        self.phaseNewFeed = .empty
        isLoadingPage = false
    }
    
    func loadNextPage(act:String, groupid: String) async {
        if Task.isCancelled { return }
        DispatchQueue.main.async {
            let newFeeds = self.phaseNewFeed.value ?? []
            self.phaseNewFeed = .fetchingNextPage(newFeeds)
        }
        do {
            guard shouldLoadNextPage else {
                return
            }
            guard let currentUid = AuthenViewModel.shared.currentUser?.userid else{return}
            guard let checkNum = AuthenViewModel.shared.currentUser?.checknum else{return}
            let pageNext = nextPage
            _ = APIService.sharedInstance.httpRequestAPI(ApiRouter.getGroupNewFeed(act: act, userid: currentUid, checknum: checkNum, groupid: groupid, page: pageNext)){ response in
               if let newFeedResponse = BaseListResponse<NewFeed>(JSON: response){
                   if newFeedResponse.status == 1 {
                       guard let listNewFeed = newFeedResponse.data else{return}
                       if Task.isCancelled { return }
                      
                       DispatchQueue.main.async {
                           var newFeeds = self.phaseNewFeed.value ?? []
                           newFeeds += listNewFeed
                           self.phaseNewFeed = .success(newFeeds)
                           self.currentPage = pageNext
                           self.hasReachedEnd = listNewFeed.count < self.itemsPerPage
                           
                           Task{
                               newFeedResponse.data = newFeeds
                               newFeedResponse.currentPage = self.currentPage
                               newFeedResponse.hasReachedEnd = self.hasReachedEnd
                               let json = newFeedResponse.toJSON()
                               let data = try! NSKeyedArchiver.archivedData(withRootObject: json,requiringSecureCoding: false)
                               cacheSave.setObject(data as NSData, forKey: "newfeedGroup")
                           }

                       }
                   }else{
                       if Task.isCancelled { return }
                   }
                }
           } failure: { error in
               if Task.isCancelled { return }
               print(error.localizedDescription)
               self.phaseNewFeed = .failure(error)
           }

        }
       
    }
    
    func loadFirstPage(act: String, groupid: String) async {
        if Task.isCancelled { return }
        if let cachedData = cacheSave.object(forKey: "newfeedGroup"),
           let myDictionary = NSKeyedUnarchiver.unarchiveObject(with: cachedData as Data) as? [String:Any] {
//           let myDictionary = try? NSKeyedUnarchiver.unarchivedObject(ofClass: NSDictionary.self, from: cachedData as Data) as? [String: Any] {
            if let newFeedResponse = BaseListResponse<NewFeed>(JSON: myDictionary){
                guard let listNewFeed = newFeedResponse.data else{return}
                DispatchQueue.main.async {
                    self.phaseNewFeed = .success(listNewFeed)
                    self.currentPage = newFeedResponse.currentPage
                    self.hasReachedEnd = newFeedResponse.hasReachedEnd
                }
                print("Load from cache")
                return
            }
            
        }
        
        DispatchQueue.main.async {
            self.phaseNewFeed = .empty
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
            _ = APIService.sharedInstance.httpRequestAPI(ApiRouter.getGroupNewFeed(act: act, userid: currentUid, checknum: checkNum, groupid: groupid, page: page)){ response in
                
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
                           cacheSave.setObject(data as NSData, forKey: "newfeedGroup")
//                           }
                       }
                       if Task.isCancelled { return }
                     DispatchQueue.main.async {
                         self.phaseNewFeed = .success(listNewFeed)                     }
                       
                   }else{
                       if Task.isCancelled { return }
                   }
                }
                self.currentPage = page
           } failure: { error in
               if Task.isCancelled { return }
               print(error.localizedDescription)
               self.phaseNewFeed = .failure(error)
           }

        }
    }
    
    func createPost(act:String, title: String, image:String, urlshare:String,content:String,layoutid:String, groupid: String,data:[MediaUploadFile]) {
        guard let userID = AuthenViewModel.shared.currentUser?.userid else{return}
        guard let checknum = AuthenViewModel.shared.currentUser?.checknum else{return}
        isCreatePost = true
        APIService.sharedInstance.httpUploadFile(ApiRouter.groupCreatePost(userid: userID, checknum: checknum, act: act, title: title, image: image, urlshare: urlshare, content: content, layoutid: layoutid, groupid: groupid), medias: data, fileType: "", fileName: "") { response in
            self.isCreatePost = false
            if let responseUploadFile = BaseResponse<NewFeed>(JSON: response){
                if responseUploadFile.status == 1{
                    // sucess
                    if let newFeed = responseUploadFile.data{
                        var newFeeds = self.phaseNewFeed.value ?? []
                        var allNewFeeds = self.phaseAllNewFeed.value ?? []
                        newFeeds.insert(newFeed, at: 0)
                        allNewFeeds.insert(newFeed, at: 0)
                        self.phaseNewFeed = .success(newFeeds)
                        self.phaseAllNewFeed = .success(allNewFeeds)
                    }
                }else {
                    //error
                    self.generateError(description: "Error creare post with status \(String(describing: responseUploadFile.status) ?? "")", "createPost")
                }
                
            }
        } failure: { error in
            self.isCreatePost = false
            self.error = self.generateError(description: error.localizedDescription,"createPost")
            print("create post error create post")
            
        }
    }
    
    //Get Group Comment
    @Published var isLoadingPageComment = false
    @Published var phaseComment = DataFetchPhase<[CommentResponse]>.empty
    private(set) var currentPageComment = 0
    private(set) var hasReachedEndComment = false
    let itemsPerPageComment: Int = 3
    
    var nextPageComment: Int { currentPageComment + 1 }
    
    var shouldLoadNextPageComment: Bool {
        !hasReachedEndComment
    }
    
    func resetComment() {
        currentPageComment = 0
        hasReachedEndComment = false
    }
    
    var commentResponse: [CommentResponse] {
        phaseComment.value ?? []
    }
    
    var isFetchingNextPageComment: Bool {
        if case .fetchingNextPage = phaseComment {
            return true
        }
        return false
    }
    
    func loadDataComment(act: String, cid: String, id: String, pid: String, sortcomm: String){
        Task {await loadFirstPageComment(act: act, cid: cid, id: id, pid: pid, sortcomm: sortcomm)}
    }
    
    func removeCacheComment(){
        cacheSave.removeObject(forKey: "groupComment")
        self.currentPageComment = 0
        self.hasReachedEndComment = false
        self.phaseComment = .empty
        isLoadingPageComment = false
    }
    
    func loadFirstPageComment(act: String, cid: String, id: String, pid: String, sortcomm: String) async {
        if Task.isCancelled { return }
        if let cachedData = cacheSave.object(forKey: "groupComment"),
           let myDictionary = NSKeyedUnarchiver.unarchiveObject(with: cachedData as Data) as? [String:Any] {

            if let groupCommentResponse = CommentsModel<CommentResponse>(JSON: myDictionary){
                guard let listGroupComment = groupCommentResponse.comment else{return}
                DispatchQueue.main.async {
                    self.phaseComment = .success(listGroupComment)
                    self.currentPageComment = groupCommentResponse.currentPage
                    self.hasReachedEndComment = groupCommentResponse.hasReachedEnd
                }
                return
            }
            
        }
        
        DispatchQueue.main.async {
            self.phaseComment = .empty
        }
        
        do {
            resetComment()
            
            guard let currentUid = AuthenViewModel.shared.currentUser?.userid else{return}
            guard let checkNum = AuthenViewModel.shared.currentUser?.checknum else{return}
            
            let page = nextPageComment;
            _ = APIService.sharedInstance.httpRequestAPI(ApiRouter.getGroupComment(act: act, userid: currentUid, checknum: checkNum, cid: cid, id: id, pid: pid, sortcomm: sortcomm, page: page)){ response in
               if let groupCommentResponse = CommentsModel<CommentResponse>(JSON: response){
                   if groupCommentResponse.num_items != "" {
                       guard let listGroupComment = groupCommentResponse.comment else{return}
                     let filtered = listGroupComment.filter { ($0.comment_id != "") }
                       Task{

                           groupCommentResponse.currentPage = page
                           groupCommentResponse.hasReachedEnd = self.hasReachedEndComment
                           let json = groupCommentResponse.toJSON()
                           let data = try! NSKeyedArchiver.archivedData(withRootObject: json,requiringSecureCoding: false)
                           cacheSave.setObject(data as NSData, forKey: "groupComment")
//                           }
                       }
                       if Task.isCancelled { return }
                       self.phaseComment = .success(filtered)
                   }else{
                       if Task.isCancelled { return }
                   }
                }
                self.currentPageComment = page
           } failure: { error in
               if Task.isCancelled { return }
               print(error.localizedDescription)
               self.phaseComment = .failure(error)
           }

        }
    }
    
    func loadNextPageComment(act: String, cid: String, id: String, pid: String, sortcomm: String) async {
        if Task.isCancelled { return }
        DispatchQueue.main.async {
            let groupComment = self.phaseComment.value ?? []
            self.phaseComment = .fetchingNextPage(groupComment)
        }
        do {
            guard shouldLoadNextPageComment else {
                return
            }
            
            let pageNext = nextPageComment
            
            guard let currentUid = AuthenViewModel.shared.currentUser?.userid else{return}
            guard let checkNum = AuthenViewModel.shared.currentUser?.checknum else{return}
            
            _ = APIService.sharedInstance.httpRequestAPI(ApiRouter.getGroupComment(act: act, userid: currentUid, checknum: checkNum, cid: cid, id: id, pid: pid, sortcomm: sortcomm, page: pageNext)){ response in
               if let groupCommentResponse = CommentsModel<CommentResponse>(JSON: response){
                   if groupCommentResponse.num_items != "" {
                       guard let listGroupComment = groupCommentResponse.comment else{return}
                       let filtered = listGroupComment.filter { ($0.comment_id != "") }
                       if Task.isCancelled { return }
                      
                       DispatchQueue.main.async {
                           var groupComment = self.phaseComment.value ?? []
                           groupComment += filtered
                           self.phaseComment = .success(groupComment)
                           self.currentPageComment = pageNext
                           self.hasReachedEndComment = listGroupComment.count < self.itemsPerPageComment
                           
                           Task{
                               groupCommentResponse.comment = groupComment
                               groupCommentResponse.currentPage = self.currentPageComment
                               groupCommentResponse.hasReachedEnd = self.hasReachedEndComment
                               let json = groupCommentResponse.toJSON()
                               let data = try! NSKeyedArchiver.archivedData(withRootObject: json,requiringSecureCoding: false)
                               cacheSave.setObject(data as NSData, forKey: "groupComment")
                           }

                       }
                   }else{
                       if Task.isCancelled { return }
                   }
                }
           } failure: { error in
               if Task.isCancelled { return }
               print(error.localizedDescription)
               self.phaseGroup = .failure(error)
           }

        }
       
    }
    
    func postGroupComment(act: String, id: String, cid: String, pid: String, reptouserid: String, content: String, photo_comment: [MediaUploadFile]) {
        guard let userID = AuthenViewModel.shared.currentUser?.userid else{return}
        guard let checknum = AuthenViewModel.shared.currentUser?.checknum else{return}
        
        APIService.sharedInstance.httpUploadFile(ApiRouter.postGroupComment(userid: userID, checknum: checknum, act: act, id: id, cid: cid, pid: pid, reptouserid: reptouserid, content: content), medias: photo_comment, fileType: "", fileName: "") { response in
            if let responseUploadFile = ResponsePostGroupComment<CommentResponse>(JSON: response){
                if responseUploadFile.status == 1{
                    // sucess
                    if let comment = responseUploadFile.data{
                        var comments = self.phaseComment.value ?? []
                        comments.insert(contentsOf: comment, at: 0)
                        self.phaseComment = .success(comments)
                    }
                    
                }else {
                    //error
                    self.generateError(description: "Error creare post with status \(String(describing: responseUploadFile.status) )", "createPost")
                }
                
            }
        } failure: { error in
            self.isCreateGroup = false
            self.error = self.generateError(description: error.localizedDescription,"createPost")
            print("create post error create post")
            
        }
    }
    
    //Get All New Feed Group
    @Published var phaseAllNewFeed = DataFetchPhase<[NewFeed]>.empty
    
    @Published var isLoadingPageAllNewFeed = false
    @Published var isCancelSearchAllNewFeed = false
    @Published var allNewFeedSearchs:[NewFeed] = []
    
    private(set) var currentPageAllNewFeed = 0
    private(set) var hasReachedEndAllNewFeed = false
    let itemsPerPageAllNewFeed: Int = 6
    
    var nextPageAllNewFeed: Int { currentPageAllNewFeed + 1 }
    
    var shouldLoadNextPageAllNewFeed: Bool {
        !hasReachedEndAllNewFeed
    }
    
    func resetAllNewFeed() {
        currentPageAllNewFeed = 0
        hasReachedEndAllNewFeed = false
    }

    var allNewFeeds: [NewFeed] {
        phaseAllNewFeed.value ?? []
    }

    var isFetchingNextPageAllNewFeed: Bool {
        if case .fetchingNextPage = phaseAllNewFeed{
            return true
        }
        return false
    }

    func loadDataAllNewFeed(act: String){
        Task {await loadFirstPageAllNewFeed(act: act)}
    }
    
    func removeCacheAllNewFeed(){
        cacheSave.removeObject(forKey: "allNewfeedGroup")
        self.currentPageAllNewFeed = 0
        self.hasReachedEndAllNewFeed = false
        self.phaseAllNewFeed = .empty
        isLoadingPageAllNewFeed = false
    }
    
    func loadNextPageAllNewFeed(act:String) async {
        if Task.isCancelled { return }
        DispatchQueue.main.async {
            let newFeeds = self.phaseAllNewFeed.value ?? []
            self.phaseAllNewFeed = .fetchingNextPage(newFeeds)
        }
        do {
            guard shouldLoadNextPageAllNewFeed else {
                return
            }
            guard let currentUid = AuthenViewModel.shared.currentUser?.userid else{return}
            guard let checkNum = AuthenViewModel.shared.currentUser?.checknum else{return}
            let pageNext = nextPageAllNewFeed
            _ = APIService.sharedInstance.httpRequestAPI(ApiRouter.groupAllNewFeed(act: act, userid: currentUid, checknum: checkNum, page: pageNext)){ response in
               if let newFeedResponse = BaseListResponse<NewFeed>(JSON: response){
                   if newFeedResponse.status == 1 {
                       guard let listNewFeed = newFeedResponse.data else{return}
                       if Task.isCancelled { return }
                      
                       DispatchQueue.main.async {
                           var newFeeds = self.phaseAllNewFeed.value ?? []
                           newFeeds += listNewFeed
                           self.phaseAllNewFeed = .success(newFeeds)
                           self.currentPageAllNewFeed = pageNext
                           self.hasReachedEndAllNewFeed = listNewFeed.count < self.itemsPerPageAllNewFeed
                           
                           Task{
                               newFeedResponse.data = newFeeds
                               newFeedResponse.currentPage = self.currentPageAllNewFeed
                               newFeedResponse.hasReachedEnd = self.hasReachedEndAllNewFeed
                               let json = newFeedResponse.toJSON()
                               let data = try! NSKeyedArchiver.archivedData(withRootObject: json,requiringSecureCoding: false)
                               cacheSave.setObject(data as NSData, forKey: "allNewfeedGroup")
                           }

                       }
                   }else{
                       if Task.isCancelled { return }
                   }
                }
           } failure: { error in
               if Task.isCancelled { return }
               print(error.localizedDescription)
               self.phaseAllNewFeed = .failure(error)
           }

        }
       
    }
    
    func loadFirstPageAllNewFeed(act: String) async {
        if Task.isCancelled { return }
        if let cachedData = cacheSave.object(forKey: "allNewfeedGroup"),
           let myDictionary = NSKeyedUnarchiver.unarchiveObject(with: cachedData as Data) as? [String:Any] {
//           let myDictionary = try? NSKeyedUnarchiver.unarchivedObject(ofClass: NSDictionary.self, from: cachedData as Data) as? [String: Any] {
            if let newFeedResponse = BaseListResponse<NewFeed>(JSON: myDictionary){
                guard let listNewFeed = newFeedResponse.data else{return}
                DispatchQueue.main.async {
                    self.phaseAllNewFeed = .success(listNewFeed)
                    self.currentPageAllNewFeed = newFeedResponse.currentPage
                    self.hasReachedEndAllNewFeed = newFeedResponse.hasReachedEnd
                }
                print("Load from cache")
                return
            }
            
        }
        
        DispatchQueue.main.async {
            self.phaseAllNewFeed = .empty
        }
        
        do {
            resetAllNewFeed()
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
            let page = nextPageAllNewFeed;
            _ = APIService.sharedInstance.httpRequestAPI(ApiRouter.groupAllNewFeed(act: act, userid: currentUid, checknum: checkNum, page: page)){ response in
                
               if let newFeedResponse = BaseListResponse<NewFeed>(JSON: response){
                 if newFeedResponse.status == 1 {
                       guard let listNewFeed = newFeedResponse.data else{return}
                       Task{
//                           if let jsonString = newFeedResponse.toJSONString(){
//                               await self.cache.setValue(jsonString, forKey: "newfeedHome")
                           newFeedResponse.currentPage = page
                           newFeedResponse.hasReachedEnd = self.hasReachedEndAllNewFeed
                           let json = newFeedResponse.toJSON()
                           let data = try! NSKeyedArchiver.archivedData(withRootObject: json,requiringSecureCoding: false)
                           cacheSave.setObject(data as NSData, forKey: "allNewfeedGroup")
//                           }
                       }
                       if Task.isCancelled { return }
                     DispatchQueue.main.async {
                         self.phaseAllNewFeed = .success(listNewFeed)                     }
                       
                   }else{
                       if Task.isCancelled { return }
                   }
                }
                self.currentPageAllNewFeed = page
           } failure: { error in
               if Task.isCancelled { return }
               print(error.localizedDescription)
               self.phaseAllNewFeed = .failure(error)
           }

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
        cacheSave.removeObject(forKey: "group_replies")
        self.currentPageReply = 0
        self.hasReachedEndReply = false
        self.phaseReply = .empty
        isLoadingPageReply = false
    }
    
    func loadNextPageReply(act:String, id: String, cid: String, pid: String, sortcomm: Int) async {
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
           _ = APIService.sharedInstance.httpRequestAPI(ApiRouter.getGroupComment(act: act, userid: currentUid, checknum: checkNum, cid: cid, id: id, pid: pid, sortcomm: String(sortcomm), page: pageNext)){ response in
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
                           cacheSave.setObject(data as NSData, forKey: "group_replies")
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
    
    func loadFirstPageReply(act:String, id: String, cid: String, pid: String, sortcomm: Int) async {
//        if Task.isCancelled { return }
        if let cachedData = cacheSave.object(forKey: "group_replies"),
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
            _ = APIService.sharedInstance.httpRequestAPI(ApiRouter.getGroupComment(act: act, userid: currentUid, checknum: checkNum, cid: cid, id: id, pid: pid, sortcomm: String(sortcomm), page: page)){ response in
               if let replyResponse = CommentsModel<CommentResponse>(JSON: response){
                   guard let listReply = replyResponse.comment else{return}
                   Task{
                       replyResponse.currentPage = page
                       replyResponse.hasReachedEnd = self.hasReachedEndReply
                       let json = replyResponse.toJSON()
                       let data = try! NSKeyedArchiver.archivedData(withRootObject: json,requiringSecureCoding: false)
                       cacheSave.setObject(data as NSData, forKey: "group_replies")
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
    
    func responseComment(act: String, id: String, cid: String, pid: String, reptouserid: String, content: String, photo_comment: Data) {
        guard let userID = AuthenViewModel.shared.currentUser?.userid else{return}
        guard let checknum = AuthenViewModel.shared.currentUser?.checknum else{return}
        APIService.sharedInstance.httpUploadFile(ApiRouter.postGroupComment(userid: userID, checknum: checknum, act: act, id: id, cid: cid, pid: pid, reptouserid: reptouserid, content: content), file: photo_comment, fileType: "", fileName:"" , withName: "photo_comment") { response in
            if let responseUploadFile = ResponsePostGroupComment<CommentResponse>(JSON: response){
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
    
    func deleteGroupPost(act: String, postid: String, groupid: String) {
        guard let userID = AuthenViewModel.shared.currentUser?.userid else{return}
        guard let checknum = AuthenViewModel.shared.currentUser?.checknum else{return}
        
        _ = APIService.sharedInstance.httpRequestAPI(ApiRouter.deleteGroupPost(userid: userID, checknum: checknum, act: act, postid: postid, groupid: groupid)) { response in
            if let deleteResponse = BaseListResponse<NewFeed>(JSON: response) {
                var newFeeds = self.phaseNewFeed.value ?? []
                var allNewFeed = self.phaseAllNewFeed.value ?? []
                if deleteResponse.status == 1 {
                    newFeeds.removeAll(where: { $0.postid == postid})
                    allNewFeed.removeAll(where: { $0.postid == postid})
                    self.phaseNewFeed = .success(newFeeds)
                    self.phaseAllNewFeed = .success(allNewFeed)
                    print("delete group post success")
                }
            }
        } failure: { error in
            self.error = self.generateError(description: error.localizedDescription,"delete_group_post")
        }
    }
    
    func getGroupContentEdit(act: String, postid: String, groupid: String, completion: @escaping (NewFeed) ->Void) {
        guard let userID = AuthenViewModel.shared.currentUser?.userid else{return}
        guard let checknum = AuthenViewModel.shared.currentUser?.checknum else{return}
        
        _ = APIService.sharedInstance.httpRequestAPI(ApiRouter.getGroupContentEdit(userid: userID, checknum: checknum, act: act, postid: postid, groupid: groupid)) { response in
            if let contentEditResponse = ResponseEditInfo<NewFeed>(JSON: response) {
                if contentEditResponse.status == 1 {
                    let newFeed = contentEditResponse.data
                    completion(newFeed!)
                }
            }
        } failure: { error in
            self.error = self.generateError(description: error.localizedDescription,"group_content_edit")
        }
    }
    
    func groupEditContent(act: String, postid: String, title: String, image: String, urlshare: String, content: String, layoutid: String, filephoto: [MediaUploadFile], media: [String], groupid: String) {
        guard let userID = AuthenViewModel.shared.currentUser?.userid else{return}
        guard let checknum = AuthenViewModel.shared.currentUser?.checknum else{return}
        
        APIService.sharedInstance.httpUploadFile(ApiRouter.groupEditContent(userid: userID, checknum: checknum, act: act, postid: postid, title: title, image: image, urlshare: urlshare, content: content, layoutid: layoutid, media: media, groupid: groupid), medias: filephoto, fileType: "", fileName: "") { response in
            if let responseUploadFile = BaseResponse<NewFeed>(JSON: response){
                var newFeeds = self.phaseNewFeed.value ?? []
                var allNewFeeds = self.phaseAllNewFeed.value ?? []
                if responseUploadFile.status == 1{
                    // sucess
                    if let newFeed = responseUploadFile.data {
                        
                        
                        if let index = newFeeds.firstIndex(where: { $0.postid == newFeed.postid}) {
                            newFeeds[index] = newFeed
                            self.phaseNewFeed = .success(newFeeds)
                        }
                        
                        if let index = allNewFeeds.firstIndex(where: { $0.postid == newFeed.postid}) {
                            allNewFeeds[index] = newFeed
                            self.phaseAllNewFeed = .success(allNewFeeds)
                        }
                    }
                }else {
                    //error
                    self.generateError(description: "Error edit post with status \(String(describing: responseUploadFile.status) ?? "")", "edit_content")
                }
                
            }
        } failure: { error in
            self.isCreatePost = false
            self.error = self.generateError(description: error.localizedDescription,"edit_content")
            print(self.error)
        }
    }
    
    func getGroupLink(act: String, groupid: String, completion: @escaping (GroupLink) ->Void) {
        guard let userID = AuthenViewModel.shared.currentUser?.userid else{return}
        guard let checknum = AuthenViewModel.shared.currentUser?.checknum else{return}
        
        _ = APIService.sharedInstance.httpRequestAPI(ApiRouter.groupShare(act: act, userid: userID, checknum: checknum, groupid: groupid)) { response in
            if let groupLinkResponse = BaseResponse<GroupLink>(JSON: response) {
                if groupLinkResponse.status == 1 {
                    let groupLink = groupLinkResponse.data
                    completion(groupLink!)
                }
            }
        } failure: { error in
            self.error = self.generateError(description: error.localizedDescription,"group_link")
        }
    }
    
    func likePost(act: String, id: String) {
        guard let userID = AuthenViewModel.shared.currentUser?.userid else{return}
        guard let checknum = AuthenViewModel.shared.currentUser?.checknum else{return}
        
        _ = APIService.sharedInstance.httpRequestAPI(ApiRouter.likeGroupPost(userid: userID, checknum: checknum, act: act, id: id)) { response in
            if let likePostResponse = ResponseLikePost<NewFeed>(JSON: response) {
                var newFeeds = self.phaseNewFeed.value ?? []
                var allNewFeeds = self.phaseAllNewFeed.value ?? []
                if likePostResponse.status == 1 {
                    let newFeed = newFeeds.first(where: {$0.postid == id})
                    newFeed?.like = "1"
                    newFeed?.numLikes = likePostResponse.totallike ?? ""
                    
                    let allNewFeed = allNewFeeds.first(where: {$0.postid == id})
                    allNewFeed?.like = "1"
                    allNewFeed?.numLikes = likePostResponse.totallike ?? ""
                    
                    if let index = newFeeds.firstIndex(where: { $0.postid == newFeed?.postid}) {
                        newFeeds[index] = newFeed!
                        self.phaseNewFeed = .success(newFeeds)
                    }
                    
                    if let index1 = allNewFeeds.firstIndex(where: { $0.postid == allNewFeed?.postid}) {
                        allNewFeeds[index1] = allNewFeed!
                        self.phaseAllNewFeed = .success(allNewFeeds)
                    }
                    
                    print("like post success")
                } else if likePostResponse.status == 2 {
                    var newFeed = newFeeds.first(where: {$0.postid == id})
                    newFeed?.like = "0"
                    newFeed?.numLikes = likePostResponse.totallike ?? ""
                    
                    let allNewFeed = allNewFeeds.first(where: {$0.postid == id})
                    allNewFeed?.like = "0"
                    allNewFeed?.numLikes = likePostResponse.totallike ?? ""
                    
                    if let index = newFeeds.firstIndex(where: { $0.postid == newFeed?.postid}) {
                        newFeeds[index] = newFeed!
                        self.phaseNewFeed = .success(newFeeds)
                    }
                    
                    if let index1 = allNewFeeds.firstIndex(where: { $0.postid == allNewFeed?.postid}) {
                        allNewFeeds[index1] = allNewFeed!
                        self.phaseAllNewFeed = .success(allNewFeeds)
                    }
                    
                    print("dislike post success")
                }
            }
        } failure: { error in
            self.error = self.generateError(description: error.localizedDescription,"delete_post")
        }
    }
    
    func removeMember(act: String, groupid: String, memberid: String) {
        guard let userID = AuthenViewModel.shared.currentUser?.userid else{return}
        guard let checknum = AuthenViewModel.shared.currentUser?.checknum else{return}
        
        _ = APIService.sharedInstance.httpRequestAPI(ApiRouter.removeMember(act: act, userid: userID, checknum: checknum, groupid: groupid, memberid: memberid)) { response in
            if let removeMemberResponse = BaseResponse<NewFeed>(JSON: response) {
                var members = self.phaseMember.value ?? []
                if removeMemberResponse.status == 1 {
                    members.removeAll(where: {$0.userid == memberid})
                    self.phaseMember = .success(members)
                    print("remove member success: \(removeMemberResponse.mess ?? "")")
                    
                } else {
                    print("remove member error: \(removeMemberResponse.mess ?? "")")
                }
            }
        } failure: { error in
            self.error = self.generateError(description: error.localizedDescription,"remove_member")
        }
    }
    
    private func generateError(code: Int = 0, description: String,_ domain:String) -> Error {
        NSError(domain: domain, code: code, userInfo: [NSLocalizedDescriptionKey: description])
    }
}
