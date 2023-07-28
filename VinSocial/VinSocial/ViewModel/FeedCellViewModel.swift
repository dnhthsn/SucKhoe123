//
//  FeedCellViewModel.swift
//  VinSocial
//
//  Created by Stealer Of Souls on 3/15/23.
//

import Foundation
class FeedCellViewModel :ObservableObject {
    @Published var newFeed: NewFeed
    
    init(_ newFeed: NewFeed) {
        self.newFeed = newFeed
        checkLikedPost()
    }
    
    var postId: String {
        return newFeed.postid ?? ""
    }
    
    var title: String{
        return newFeed.title ?? ""
    }
    
    var urlshare: String{
        return newFeed.urlshare ?? ""
    }
    
    var nameUser: String{
        return newFeed.user_info?.fullname ?? ""
    }
    
    var followStatus: String {
        return newFeed.user_info?.friend_info?.follow ?? ""
    }
    
    var isFriendStatus: String {
        return newFeed.user_info?.friend_info?.isfriend ?? ""
    }
    
    var getUserID: String{
        return newFeed.user_info?.userid ?? ""
    }
    
    var addTime: String{
        return newFeed.addtime ?? ""
    }
    
    
    var getLike: Int{
        return newFeed.list_like?.count ?? 0
    }
    
    var getListLike: [Like] {
        if newFeed.list_like == nil {
            return []
        }
        
        guard let likes = newFeed.list_like else {return []}
        return likes
    }
    
    var getComment: String{
        return newFeed.commenttotal ?? ""
    }
    
    var getLinkAvatarUser: String {
        if newFeed.user_info == nil {
            return ""
        }
        if newFeed.user_info?.avatar == nil {
            return ""
        }
        if newFeed.user_info!.avatar!.contains("https://"){
            return newFeed.user_info?.avatar ?? ""
        }
        return "https://suckhoe123.vn"+(newFeed.user_info?.avatar ?? "")
    }
    
    var getMedia: [Media] {
        if newFeed.media == nil {
            return []
        }
        
        guard let medias = newFeed.media else {return []}
        return medias
    }
    
    var checkOwnerPost : Bool {
        if newFeed.user_info == nil {
            return false
        }
        guard let currentUser = AuthenViewModel.shared.currentUser?.userid else {return false}
        return newFeed.user_info?.userid == currentUser
        
    }
    
    func likePost() {
        guard let userID = AuthenViewModel.shared.currentUser?.userid else{return}
        guard let checknum = AuthenViewModel.shared.currentUser?.checknum else{return}
        
        _ = APIService.sharedInstance.httpRequestAPI(ApiRouter.likePost(userid: userID, checknum: checknum, id: newFeed.postid ?? "")) { response in
            if let likePostResponse = ResponseLikePost<NewFeed>(JSON: response) {
                if likePostResponse.status == 1 {
                    self.newFeed.didLike = true
                    print("like post success")
                } else if likePostResponse.status == 2 {
                    self.newFeed.didLike = false
                    print("dislike post success")
                }
            }
        } failure: { error in
//            self.error = self.generateError(description: error.localizedDescription,"delete_post")
            print("error like post: \(error.localizedDescription)")
        }
    }
    
    func checkLikedPost() {
        if newFeed.like == "1" {
            self.newFeed.didLike = true
        } else {
            self.newFeed.didLike = false
        }
    }
    
    func initUserInfo()->UserInfoRes{
        var userInfo = UserInfoRes(fullname:
            nameUser, avatar:
            getLinkAvatarUser)
        userInfo.fullname = nameUser
        userInfo.avatar = getLinkAvatarUser
        return userInfo
    }
    
    func getCurrentTime()-> String {
        let date = Date()
        let calendar = Calendar.current
        let day = calendar.component(.day, from: date)
        let month = calendar.component(.month, from: date)
        let year = calendar.component(.year, from: date)
        let hour = calendar.component(.hour, from: date)
        let minute = calendar.component(.minute, from: date)
        
        var dayResult = ""
        var monthResult = ""
        var hourResult = ""
        var minuteResult = ""
        
        if day < 10 {
            dayResult = "0\(day)"
        } else if day >= 10 {
            dayResult = "\(day)"
        }
        
        if month < 10 {
            monthResult = "0\(month)"
        } else if month >= 10 {
            monthResult = "\(month)"
        }
        
        if hour < 10 {
            hourResult = "0\(hour)"
        } else if hour >= 10 {
            hourResult = "\(hour)"
        }
        
        if minute < 10 {
            minuteResult = "0\(minute)"
        } else if minute >= 10 {
            minuteResult = "\(minute)"
        }
        return "\(dayResult)/\(monthResult)/\(year) \(hourResult):\(minuteResult)"

    }
    
    func getTime(time: String)-> String {
        let num = Int(time)
        if num != nil {
            return convertTime(time: num ?? 0)
        } else {
            let timeArr = time.components(separatedBy: ", ")
            return timeArr.count == 1 ? timeArr[0] : timeArr[1]
        }
        
    }
    
    func convertTime(time: Int)-> String {
        let timeInterval = TimeInterval(time)
        
        let date = Date(timeIntervalSince1970: timeInterval/1000.0)
        
        return date.formatted(
            .dateTime
                .day(.twoDigits)
                .month(.twoDigits)
                .year()
                .hour(.conversationalDefaultDigits(amPM: .omitted))
                .minute()
                
                
        )
    }
    
    func compareTime(timeArr1: String, timeArr2: String)-> String {
        let dateTimeArr1 : [String]
        let dateMonthYear1: String
        let hourMinute1: String
        if timeArr1.contains(",") {
            dateTimeArr1 = timeArr1.components(separatedBy: ", ")
            dateMonthYear1 = dateTimeArr1[1]
            hourMinute1 = dateTimeArr1[0]
        } else {
            dateTimeArr1 = timeArr1.components(separatedBy: " ")
            dateMonthYear1 = dateTimeArr1[0]
            hourMinute1 = dateTimeArr1[1]
        }
        
        
        let dateTimeArr2 = timeArr2.components(separatedBy: " ")
        
        let dateMonthYear2 = dateTimeArr2[0]
        let hourMinute2 = dateTimeArr2[1]
        
        let dateMonthYear1Arr = dateMonthYear1.components(separatedBy: "/")
        let day1 = dateMonthYear1Arr[0]
        let month1 = dateMonthYear1Arr[1]
        let year1 = dateMonthYear1Arr[2]
        
        let dateMonthYear2Arr = dateMonthYear2.components(separatedBy: "/")
        let day2 = dateMonthYear2Arr[0]
        let month2 = dateMonthYear2Arr[1]
        let year2 = dateMonthYear2Arr[2]
        
        if dateMonthYear1 == dateMonthYear2 {
            let timeSplit1 = hourMinute1.components(separatedBy: ":")
            
            let hour1 = timeSplit1[0]
            let minute1 = timeSplit1[1]
            
            let timeSplit2 = hourMinute2.components(separatedBy: ":")
            
            let hour2 = timeSplit2[0]
            let minute2 = timeSplit2[1]
            
            let minuteInt1: Int = Int(minute1) ?? 0
            let minuteInt2: Int = Int(minute2) ?? 0
            let hourInt1: Int = Int(hour1) ?? 0
            let hourInt2: Int = Int(hour2) ?? 0
            
            if hour1 == hour2 {
                return "\(abs(minuteInt1 - minuteInt2)) phút"
            } else {
                return "\(abs(hourInt1 - hourInt2)) giờ"
            }
        } else {
            let dayInt1: Int = Int(day1) ?? 0
            let monthInt1: Int = Int(month1) ?? 0
            let yearInt1: Int = Int(year1) ?? 0
            
            let dayInt2: Int = Int(day2) ?? 0
            let monthInt2: Int = Int(month2) ?? 0
            let yearInt2: Int = Int(year2) ?? 0
            
            if yearInt1 == yearInt2 {
                if monthInt1 == monthInt2 {
                    if abs(dayInt1 - dayInt2) < 7 {
                        return "\(abs(dayInt1 - dayInt2)) ngày"
                    } else {
                        return "\(abs(dayInt1 - dayInt2)/7) tuần"
                    }
                } else {
                    return "\(day1) tháng \(month1)"
                }
            } else {
                return "\(day1) tháng \(month1), \(year1)"
            }
        }
    }
    
}
