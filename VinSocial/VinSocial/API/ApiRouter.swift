//
//  ApiRouter.swift
//  Messenger
//
//  Created by Stealer Of Souls on 2/10/23.
//

import Foundation
import Foundation
import Alamofire

enum ApiRouter {
    // =========== Begin define api ===========
    case login(email: String, password: String)
    case register(fullname: String, email: String, password: String)
    case uploadFile(userid: String, checknum: String, action: String,data:Data)
    case loginSocial(server: String, id: String, email: String, phone: String, first_name: String, gender: String, avatar_url: String)
    case getNewFeed(page: Int, userid: String, checknum: String)
    case getCatalog(act: String, catalogid: String)
    case timeline(userid: String, checknum: String,pageuserid:String,page:Int)
    case getNotification(userid: String, checknum: String, page: Int)
    case createPost(userid: String, checknum: String, title: String, image:String, urlshare:String,content:String,layoutid:String,display:String)
    case editUinfo(userid: String, checknum: String, fullname: String, gender: String, birthday: String, address: String, mobile: String, education: String, working: String, description: String)
    case getUinfo(userid: String, checknum: String, profileid: String)
    case follow(userid: String, checknum: String, friendID:String, verifykey:String)
    case listFriend(userid: String, checknum: String, friendid:String, sort:Int, page: Int)
    
    case listVideo(act: String, catid: String, sortby:String, page:Int)
    case listPhoto(act: String, catid: String, sortby:String, page:Int)
    case forget(userField: String, step: Int, verifykey: String, new_password: String, re_password: String)
    case postComment(userid: String, checknum: String, id: String, cid: String, pid: String, reptouserid: String, content: String)
    case getComment(userid: String, checknum: String, cid: String, id: String, pid: String, sortcomm: String, page: Int)
    case searchFeed(mode: String, act: String, keyword: String, page: Int)
    case createGroup(act: String, userid: String, checknum: String, title: String, about: String, grouptype: Int, catid: String, member: Int)
    case groupInfo(userid: String, checknum: String, groupid: String)
    case makeFriend(userid: String, checknum: String, friendid: String, act: String, verifykey: String)
    case getMediaUser(userid: String, checknum: String, mediatype: Int, friendid: String, sort: Int, page: Int)
    case topDoctor(act: String)
    case listCatalog(act: String)
    case detailCatalog(categorty: String, catid: String)
    case catalogDoctor(categorty: String, catid: String, act: String, page: Int, sortby: String)
    case catalogNewsDetail(category: String, postid: String, act: String)
    case listProvince
    case catalogAsk(userid: String, checknum: String, act: String, title: String, content: String, catid: String, province: String)
    case groupList(userid: String, checknum: String, act: String, groupby: Int, page: Int)
    case groupCatalog(act: String)
    case memberGroup(act: String, userid: String, checknum: String, groupid: String, usertype: String, page: Int)
    case inviteMember(act: String, userid: String, checknum: String, groupid: String, usertype: String, memberid: String)
    case groupCreatePost(userid: String, checknum: String, act:String, title: String, image:String, urlshare:String, content:String, layoutid:String, groupid: String)
    case getGroupNewFeed(act: String, userid: String, checknum: String, groupid: String, page: Int)
    case leaveGroup(act: String, userid: String, checknum: String, groupid: String)
    case getGroupComment(act: String, userid: String, checknum: String, cid: String, id: String, pid: String, sortcomm: String, page: Int)
    case postGroupComment(userid: String, checknum: String, act: String, id: String, cid: String, pid: String, reptouserid: String, content: String)
    case getContentEdit(userid: String, checknum: String, getpost: String, postid: String)
    case editContent(userid: String, checknum: String, postid: String, title: String, image:String, urlshare:String,content:String,layoutid:Int,display:Int, media: [String])
    case deletePost(userid: String, checknum: String, postid: String)
    case groupAllNewFeed(act: String, userid: String, checknum: String, page: Int)
    case deleteGroupPost(userid: String, checknum: String, act: String, postid: String, groupid: String)
    case getGroupContentEdit(userid: String, checknum: String, act: String, postid: String, groupid: String)
    case groupEditContent(userid: String, checknum: String, act: String, postid: String, title: String, image:String, urlshare:String,content:String,layoutid:String, media: [String], groupid: String)
    case groupShare(act: String, userid: String, checknum: String, groupid: String)
    case likePost(userid: String, checknum: String, id: String)
    case likeGroupPost(userid: String, checknum: String, act: String, id: String)
    case searchMod(mod: String, showsuggest: String, keyword: String, page: Int)
    case removeMember(act: String, userid: String, checknum: String, groupid: String, memberid: String)
    case deviceInfo(deviceid: String, system: String, token: String)
    case updateAvatar(userid: String, checknum: String, act: Int, crop_width: Int, crop_height: Int)
    case changePassword(userid: String, checknum: String, passwordold: String, password: String, repassword: String)
    case getExpert(category: String, doctorid: String)
    case getExpertNewFeed(category: String, doctorid: String, act: String, page: Int)
    case getExpertImage(category: String, doctorid: String, act: String, page: Int, sortby: String)
    case getExpertDetailNewFeed(category: String, postid: String, act: String)
    case getLayoutContent
    
    // =========== End define api ===========
    
    // MARK: - HTTPMethod
    public var method: HTTPMethod {
        switch self {
        case .login, .changePassword,.register,.uploadFile, .loginSocial,.getNewFeed, .getCatalog, .getNotification,.timeline,.createPost, .editUinfo,.follow, .getUinfo,.listFriend,.listVideo, .forget, .postComment, .getComment,.searchFeed,.listPhoto, .createGroup, .groupInfo, .makeFriend, .getMediaUser, .topDoctor, .listCatalog, .detailCatalog, .catalogDoctor, .catalogNewsDetail, .listProvince, .catalogAsk, .groupList, .groupCatalog, .memberGroup, .inviteMember, .groupCreatePost, .getGroupNewFeed, .leaveGroup, .getGroupComment, .postGroupComment, .getContentEdit, .editContent, .deletePost, .groupAllNewFeed, .deleteGroupPost, .getGroupContentEdit, .groupEditContent, .groupShare, .likePost, .likeGroupPost, .searchMod, .removeMember, .deviceInfo, .updateAvatar, .getExpert, .getExpertNewFeed, .getExpertImage, .getExpertDetailNewFeed, .getLayoutContent:
            return .post
        }
    }
    
    public var encoding: ParameterEncoding {
        switch self {
        case .login,.changePassword,.register,.uploadFile,
                .loginSocial,.getNewFeed, .getCatalog,.timeline,.getNotification,.createPost, .editUinfo, .follow, .getUinfo,.listFriend,.listVideo, .forget, .postComment, .getComment,.searchFeed,.listPhoto, .createGroup, .groupInfo, .makeFriend, .getMediaUser, .topDoctor, .listCatalog, .detailCatalog, .catalogDoctor, .catalogNewsDetail, .listProvince, .catalogAsk, .groupList, .groupCatalog, .memberGroup, .inviteMember, .groupCreatePost, .getGroupNewFeed, .leaveGroup, .getGroupComment, .postGroupComment, .getContentEdit, .editContent, .deletePost, .groupAllNewFeed, .deleteGroupPost, .getGroupContentEdit, .groupEditContent, .groupShare, .likePost, .likeGroupPost, .searchMod, .removeMember, .deviceInfo, .updateAvatar, .getExpert, .getExpertNewFeed, .getExpertImage, .getExpertDetailNewFeed, .getLayoutContent:
            return URLEncoding.httpBody
        }
    }
    
    // MARK: - Path
    public var path: String {
        switch self {
        case .login:
            return Production.BASE_URL+"login"
        case .register:
            return Production.BASE_URL+"register"
        case .uploadFile:
            return Production.BASE_URL+"upload"
        case .loginSocial:
            return Production.BASE_URL+"openid"
        case .getNewFeed:
            return Production.BASE_URL_SOCIAL+"main"
        case .getCatalog:
            return Production.BASE_URL_SOCIAL+"concerns"
        case .timeline:
            return Production.BASE_URL_SOCIAL+"timeline"
        case .getNotification:
            return Production.BASE_URL_SOCIAL+"getNotification"
        case .createPost:
            return Production.BASE_URL_SOCIAL+"createContent"
        case .editUinfo:
            return Production.BASE_URL_SOCIAL+"editUinfo"
        case .getUinfo:
            return Production.BASE_URL_SOCIAL+"getUinfo"
        case .follow:
            return Production.BASE_URL_SOCIAL+"follow"
        case .listFriend:
            return Production.BASE_URL_SOCIAL+"listFriend"
        case .listVideo:
            return Production.BASE_URL_SOCIAL+"listVideo"
        case .listPhoto:
            return Production.BASE_URL_SOCIAL+"listPhoto"
        case .forget:
            return Production.BASE_URL+"forget"
        case .postComment:
            return Production.BASE_URL_SOCIAL+"postComment"
        case .getComment:
            return Production.BASE_URL_SOCIAL+"getComment"
        case .searchFeed:
            return Production.BASE_URL_SOCIAL+"search"
        case .createGroup:
            return Production.BASE_URL_SOCIAL+"group"
        case .groupInfo:
            return Production.BASE_URL_SOCIAL+"group"
        case .makeFriend:
            return Production.BASE_URL_SOCIAL+"makeFriend"
        case .getMediaUser:
            return Production.BASE_URL_SOCIAL+"getMediaUser"
        case .topDoctor:
            return Production.BASE_URL_SOCIAL+"topDoctor"
        case .listCatalog:
            return Production.BASE_URL_SOCIAL+"listCatalog"
        case .detailCatalog:
            return Production.BASE_URL_SOCIAL+"catalog"
        case .catalogDoctor:
            return Production.BASE_URL_SOCIAL+"catalog"
        case .catalogNewsDetail:
            return Production.BASE_URL_SOCIAL+"catalog"
        case .listProvince:
            return Production.BASE_URL_SOCIAL+"listProvince"
        case .catalogAsk:
            return Production.BASE_URL_SOCIAL+"catalog"
        case .groupList:
            return Production.BASE_URL_SOCIAL+"group"
        case .groupCatalog:
            return Production.BASE_URL_SOCIAL+"group"
        case .memberGroup:
            return Production.BASE_URL_SOCIAL+"group"
        case .inviteMember:
            return Production.BASE_URL_SOCIAL+"group"
        case .groupCreatePost:
            return Production.BASE_URL_SOCIAL+"group"
        case .getGroupNewFeed:
            return Production.BASE_URL_SOCIAL+"group"
        case .leaveGroup:
            return Production.BASE_URL_SOCIAL+"group"
        case .getGroupComment:
            return Production.BASE_URL_SOCIAL+"group"
        case .postGroupComment:
            return Production.BASE_URL_SOCIAL+"group"
        case .getContentEdit:
            return Production.BASE_URL_SOCIAL+"editContent"
        case .editContent:
            return Production.BASE_URL_SOCIAL+"editContent"
        case .deletePost:
            return Production.BASE_URL_SOCIAL+"deleteContent"
        case .groupAllNewFeed:
            return Production.BASE_URL_SOCIAL+"group"
        case .deleteGroupPost:
            return Production.BASE_URL_SOCIAL+"group"
        case .getGroupContentEdit:
            return Production.BASE_URL_SOCIAL+"group"
        case .groupEditContent:
            return Production.BASE_URL_SOCIAL+"group"
        case .groupShare:
            return Production.BASE_URL_SOCIAL+"group"
        case .likePost:
            return Production.BASE_URL_SOCIAL+"likePost"
        case .likeGroupPost:
            return Production.BASE_URL_SOCIAL+"group"
        case .searchMod:
            return Production.BASE_URL_SOCIAL+"searchmod"
        case .removeMember:
            return Production.BASE_URL_SOCIAL+"group"
        case .deviceInfo:
            return Production.BASE_URL+"device"
        case .updateAvatar:
            return Production.BASE_URL_SOCIAL+"updateAvatar"
        case .changePassword:
            return Production.BASE_URL+"changepass"
        case .getExpert:
            return Production.BASE_URL_SOCIAL+"expert"
        case .getExpertNewFeed:
            return Production.BASE_URL_SOCIAL+"expert"
        case .getExpertImage:
            return Production.BASE_URL_SOCIAL+"expert"
        case .getExpertDetailNewFeed:
            return Production.BASE_URL_SOCIAL+"expert"
        case .getLayoutContent:
            return Production.BASE_URL_SOCIAL+"getLayoutContent"
        }
    }
    
    // MARK: - Headers
    private var headers: HTTPHeaders {
        var headers: HTTPHeaders = ["Accept": "application/json"]
        switch self {
        case .login:
            break
        case .register:
            break
        case .uploadFile:
            break
        case .changePassword:
            headers["Authorization"] = getAuthorizationHeader()
            break
        case .loginSocial:
            break
        case .getNewFeed:
            break
        case .getCatalog:
            break
        case .timeline:
            break
        case .getNotification:
            break
        case .createPost:
            break
        case .editUinfo:
            break
        case .getUinfo:
            break
        case .follow:
            break
        case .listFriend:
            break
        case .listVideo:
            break
        case .listPhoto:
            break
        case .forget:
            break
        case .postComment:
            break
        case .getComment:
            break
        case .searchFeed:
            break
        case .createGroup:
            break
        case .groupInfo:
            break
        case .makeFriend:
            break
        case .getMediaUser:
            break
        case .topDoctor:
            break
        case .listCatalog:
            break
        case .detailCatalog:
            break
        case .catalogDoctor:
            break
        case .catalogNewsDetail:
            break
        case .listProvince:
            break
        case .catalogAsk:
            break
        case .groupList:
            break
        case .groupCatalog:
            break
        case .memberGroup:
            break
        case .inviteMember:
            break
        case .groupCreatePost:
            break
        case .getGroupNewFeed:
            break
        case .leaveGroup:
            break
        case .getGroupComment:
            break
        case .postGroupComment:
            break
        case .getContentEdit:
            break
        case .editContent:
            break
        case .deletePost:
            break
        case .groupAllNewFeed:
            break
        case .deleteGroupPost:
            break
        case .getGroupContentEdit:
            break
        case .groupEditContent:
            break
        case .groupShare:
            break
        case .likePost:
            break
        case .likeGroupPost:
            break
        case .searchMod:
            break
        case .removeMember:
            break
        case .deviceInfo:
            break
        case .updateAvatar:
            break
        case .getExpert:
            break
        case .getExpertNewFeed:
            break
        case .getExpertImage:
            break
        case .getExpertDetailNewFeed:
            break
        case .getLayoutContent:
            break
        }

        return headers;
    }
    
    public var parameters: [String:Any]? {
        switch self {
        case .login(let email, let password):
            return [
                "username": email,
                "password": password
            ]
        case .register(let fullname,let email, let password):
            return [
                "fullname": fullname,
                "email": email,
                "password": password
            ]
        case .uploadFile(let userid, let checknum, _, _):
            return [
                "userid": String(userid),
                "checknum": checknum,
                "action": "",
            ]
        case .getNewFeed(let page, let userid,let checknum):
            return [
                "page": String(page),
                "checknum": checknum,
                "userid": String(userid)
            ]
        case .getCatalog(let act, let catalogid):
            return [
                "act": act,
                "catalogid": String(catalogid)
            ]
        case .timeline(let userid, let checknum, let pageuserid, let page):
            return [
                "userid": userid,
                "checknum": checknum,
                "pageuserid": pageuserid,
                "page": String(page)
                ]
        case .getNotification(let userid,let checknum, let page):
            return [
                "userid": userid,
                "checknum": checknum,
                "page": String(page)
                
            ]
        case .createPost(let userid,let checknum , let title, let image, let urlshare, let content, let layoutid, let display):
            return [
                "userid": userid,
                "checknum": checknum,
                "title": title,
                "image": image,
                "urlshare": urlshare,
                "content": content,
                "layoutlid": layoutid,
                "display": display,
                ]
        case .follow(let userid, let checknum, let friendID, let verifykey):
            return [
                "userid": userid,
                "checknum": checknum,
                "friendid": friendID,
                "verifykey": verifykey
                ]
        case .editUinfo(let userid, let checknum, let fullname, let gender, let birthday, let address, let mobile, let education, let working, let description):
            return [
                "userid": userid,
                "checknum": checknum,
                "fullname": fullname,
                "gender": gender,
                "birthday": birthday,
                "address": address,
                "mobile": mobile,
                "education": education,
                "working": working,
                "description": description
            ]
        case .getUinfo(let userid, let checknum, let profileid):
            return [
                "userid": userid,
                "checknum": checknum,
                "profileid": profileid
                
            ]
        case .listFriend(let userid, let checknum, let friendid, let sort, let page):
            return [
                "userid": userid,
                "checknum": checknum,
                "friendid": friendid,
                "sort": String(sort),
                "page": String(page)
                
            ]
        case .listVideo(let act, let catid, let sortby, let page):
            return [
                "act": act,
                "catid": catid,
                "sortby": sortby,
                "page": String(page),
                
            ]
        case .listPhoto(let act, let catid, let sortby, let page):
            return [
                "act": act,
                "catid": catid,
                "sortby": sortby,
                "page": String(page),
                
            ]
        case .loginSocial(server: let server ,id: let id ,email: let email,phone: let phone ,first_name: let first_name,gender: let gender,avatar_url: let avatar_url):
                return [
                    "server": server,
                    "id": id,
                    "email": email,
                    "phone": phone,
                    "first_name": first_name,
                    "gender": gender,
                    "avatar_url": avatar_url
                ]
        case .forget(let userField, let step, let verifykey, let new_password, let re_password):
            return [
                "userField": userField,
                "step": String(step),
                "verifykey": verifykey,
                "new_password": new_password,
                "re_password": re_password
            ]
        case .postComment(let userid, let checknum, let id, let cid, let pid, let reptouserid, let content):
            return [
                "userid": userid,
                "checknum": checknum,
                "id": id,
                "cid": cid,
                "pid": pid,
                "reptouserid": reptouserid,
                "content": content
            ]
        case .getComment(let userid, let checknum, let cid, let id, let pid, let sortcomm, let page):
            return [
                "userid": userid,
                "checknum": checknum,
                "id": id,
                "cid": cid,
                "pid": pid,
                "sortcomm": String(sortcomm),
                "page": String(page)
            ]
        case .searchFeed(let mode, let act, let keyword, let page):
            return [
                "mod": mode,
                "act": act,
                "keyword": keyword,
                "page": String(page)
            ]
        case .createGroup(let act, let userid, let checknum, let title, let about, let grouptype, let catid, let member):
            return [
                "act": act,
                "userid": userid,
                "checknum": checknum,
                "title": title,
                "about": about,
                "grouptype": String(grouptype),
                "catid": String(catid),
                "member": String(member)
            ]
        case .groupInfo(let userid, let checknum, let groupid):
            return [
                "userid": userid,
                "checknum": checknum,
                "groupid": String(groupid)
            ]
        case .makeFriend(let userid, let checknum, let friendid, let act, let verifykey):
            return [
                "userid": userid,
                "checknum": checknum,
                "friendid": friendid,
                "act": act,
                "verifykey": verifykey,
            ]
        case .getMediaUser(let userid, let checknum, let mediatype, let friendid, let sort, let page):
            return [
                "userid": userid,
                "checknum": checknum,
                "mediatype": String(mediatype),
                "friendid": friendid,
                "sort": String(sort),
                "page": String(page)
            ]
        case .topDoctor(let act):
            return [
                "act": act
            ]
        case .listCatalog(let act):
            return [
                "act": act
            ]
        case .detailCatalog(let categorty, let catid):
            return [
                "category": categorty,
                "catid": catid
            ]
        case .catalogDoctor(let categorty, let catid, let act, let page, let sortby):
            return [
                "category": categorty,
                "catid": catid,
                "act": act,
                "page": String(page),
                "sortby": sortby
            ]
        case .catalogNewsDetail(let category, let postid, let act):
            return [
                "category": category,
                "postid": postid,
                "act": act
            ]
        case .listProvince:
            return [
                :
            ]
        case .catalogAsk(let userid, let checknum, let act, let title, let content, let catid, let province):
            return [
                "userid": userid,
                "checknum": checknum,
                "act": act,
                "title": title,
                "content": content,
                "catid": catid,
                "province": province
            ]
        case .groupList(let userid, let checknum, let act, let groupby, let page):
            return [
                "userid": userid,
                "checknum": checknum,
                "act": act,
                "groupby": String(groupby),
                "page": String(page)
            ]
        case .groupCatalog(let act):
            return [
                "act": act
            ]
        case .memberGroup(let act, let userid, let checknum, let groupid, let usertype, let page):
            return [
                "act": act,
                "userid": userid,
                "checknum": checknum,
                "groupid": groupid,
                "usertype": usertype,
                "page": String(page)
            ]
        case .inviteMember(let act, let userid, let checknum, let groupid, let usertype, let memberid):
            return [
                "act": act,
                "userid": userid,
                "checknum": checknum,
                "groupid": groupid,
                "usertype": usertype,
                "memberid": memberid
            ]
        case .groupCreatePost(let userid,let checknum, let act, let title, let image, let urlshare, let content, let layoutid, let groupid):
            return [
                "userid": userid,
                "checknum": checknum,
                "act": act,
                "title": title,
                "image": image,
                "urlshare": urlshare,
                "content": content,
                "layoutid": layoutid,
                "groupid": groupid
            ]
        case .getGroupNewFeed(let act, let userid, let checknum, let groupid, let page):
            return [
                "act": act,
                "userid": userid,
                "checknum": checknum,
                "groupid": groupid,
                "page": String(page)
            ]
        case .leaveGroup(let act, let userid, let checknum, let groupid):
            return [
                "act": act,
                "userid": userid,
                "checknum": checknum,
                "groupid": groupid
            ]
        case .getGroupComment(let act, let userid, let checknum, let cid, let id, let pid, let sortcomm, let page):
            return [
                "act": act,
                "userid": userid,
                "checknum": checknum,
                "cid": cid,
                "id": id,
                "pid": pid,
                "sortcomm": sortcomm,
                "page": String(page)
            ]
        case .postGroupComment(let userid, let checknum, let act, let id, let cid, let pid, let reptouserid, let content):
            return [
                "userid": userid,
                "checknum": checknum,
                "act": act,
                "id": id,
                "cid": cid,
                "pid": pid,
                "reptouserid": reptouserid,
                "content": content
            ]
        case .getContentEdit(let userid, let checknum, let getpost, let postid):
            return [
                "userid": userid,
                "checknum": checknum,
                "getpost": getpost,
                "postid": postid
            ]
        case .editContent(let userid, let checknum, let postid, let title, let image, let urlshare, let content, let layoutid, let display, let media):
            //
            return [
                "userid": userid,
                "checknum": checknum,
                "postid": postid,
                "title": title,
                "image": image,
                "urlshare": urlshare,
                "content": content,
                "layoutid": String(layoutid),
                "display": display,
                "media": media
            ]
        case .deletePost(let userid, let checknum, let postid):
            return [
                "userid": userid,
                "checknum": checknum,
                "postid": postid
            ]
        case .groupAllNewFeed(let act, let userid, let checknum, let page):
            return [
                "act": act,
                "userid": userid,
                "checknum": checknum,
                "page": String(page)
            ]
        case .deleteGroupPost(let userid, let checknum, let act, let postid, let groupid):
            return [
                "userid": userid,
                "checknum": checknum,
                "act": act,
                "postid": postid,
                "groupid": groupid
            ]
        case .getGroupContentEdit(let userid, let checknum, let act, let postid, let groupid):
            return [
                "userid": userid,
                "checknum": checknum,
                "act": act,
                "postid": postid,
                "groupid": groupid
            ]
        case .groupEditContent(let userid, let checknum, let act, let postid, let title, let image, let urlshare, let content, let layoutid, let media, let groupid):
            return [
                "userid": userid,
                "checknum": checknum,
                "act": act,
                "postid": postid,
                "title": title,
                "image": image,
                "urlshare": urlshare,
                "content": content,
                "layoutid": layoutid,
                "media": media,
                "groupid": groupid
            ]
        case .groupShare(let act, let userid, let checknum, let groupid):
            return [
                "act": act,
                "userid": userid,
                "checknum": checknum,
                "groupid": groupid
            ]
        case .likePost(let userid, let checknum, let id):
            return [
                "userid": userid,
                "checknum": checknum,
                "id": id
            ]
        case .likeGroupPost(let userid, let checknum, let act, let id):
            return [
                "userid": userid,
                "checknum": checknum,
                "act": act,
                "id": id
            ]
        case .searchMod(let mod, let showsuggest, let keyword, let page):
            return [
                "mod": mod,
                "showsuggest": showsuggest,
                "keyword": keyword,
                "page": String(page)
            ]
        case .removeMember(let act, let userid, let checknum, let groupid, let memberid):
            return [
                "act": act,
                "userid": userid,
                "checknum": checknum,
                "groupid": groupid,
                "memberid": memberid,
            ]
        case .deviceInfo(let deviceid, let system, let token):
            return [
                "deviceid": deviceid,
                "system": system,
                "token": token
            ]
        case .updateAvatar(let userid, let checknum, let act, let crop_width, let crop_height):
            return [
                "userid": userid,
                "checknum": checknum,
                "act": String(act),
                "crop_width": String(crop_width),
                "crop_height": String(crop_height),
            ]
        case .changePassword(let userid, let checknum, let passwordold, let password, let repassword):
            return [
                "userid": userid,
                "checknum": checknum,
                "passwordold": passwordold,
                "password": password,
                "repassword": repassword
            ]
        case .getExpert(let category, let doctorid):
            return [
                "category": category,
                "doctorid": doctorid
            ]
        case .getExpertNewFeed(let category, let doctorid, let act, let page):
            return [
                "category": category,
                "doctorid": doctorid,
                "act": act,
                "page": String(page)
            ]
        case .getExpertImage(let category, let doctorid, let act, let page, let sortby):
            return [
                "category": category,
                "doctorid": doctorid,
                "act": act,
                "page": String(page),
                "sortby": sortby
            ]
        case .getExpertDetailNewFeed(let category, let postid, let act):
            return [
                "category": category,
                "postid": postid,
                "act": act
            ]
        case .getLayoutContent:
            return [
                :
            ]
        }
    }
    
    private func getAuthorizationHeader() -> String {
        return "Authorization token"
    }
}
