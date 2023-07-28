//
//  CommentCellViewModel.swift
//  VinSocial
//
//  Created by Đinh Thái Sơn on 18/04/2023.
//

import Foundation
class CommentCellViewModel :ObservableObject{
    @Published var comment: CommentResponse
    
    init(_ comment: CommentResponse) {
        self.comment = comment
    }
    
    var content: String{
        return comment.content ?? ""
    }
    
    var nameUser: String{
        return comment.userid_create_comment?.fullname ?? ""
    }
    
    var getUserID: String{
        return comment.userid_create_comment?.userid ?? ""
    }
    
    var addTime: String{
        return comment.addtime ?? ""
    }
    
    
    var getLike: String{
        return comment.likes ?? ""
    }
    
    var getReply: String{
        return comment.totalreply ?? ""
    }
    
    var getLinkAvatarUser: String {
        if comment.userid_create_comment == nil {
            return ""
        }
        if comment.userid_create_comment?.avatar == nil {
            return ""
        }
        if comment.userid_create_comment!.avatar!.contains("https://"){
            return comment.userid_create_comment?.avatar ?? ""
        }
        return "https://ws.suckhoe123.vn"+(comment.userid_create_comment?.avatar ?? "")
    }
    
    var checkOwnerPost : Bool {
        if comment.userid_create_comment == nil {
            return false
        }
        guard let currentUser = AuthenViewModel.shared.currentUser?.userid else {return false}
        return comment.userid_create_comment?.userid == currentUser
        
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
        return "\(hourResult):\(minuteResult), \(dayResult)/\(monthResult)/\(year)"

    }
    
    func convertTime(time: String)-> String {
        let timeInterval = TimeInterval(Int64(time) ?? 0)
        
        let date = Date(timeIntervalSince1970: timeInterval)
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+7")
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "HH:mm, dd/MM/yyyy"
        return dateFormatter.string(from: date)
    }
    
    func compareTime(timeArr1: String, timeArr2: String)-> String {
        if timeArr1 == timeArr2 {
            return "Vừa xong"
        }
        let dateTimeArr1 = timeArr1.components(separatedBy: ", ")
        
        let dateMonthYear1 = dateTimeArr1[1]
        let hourMinute1 = dateTimeArr1[0]
        
        let dateTimeArr2 = timeArr2.components(separatedBy: ", ")
        
        let dateMonthYear2 = dateTimeArr2[1]
        let hourMinute2 = dateTimeArr2[0]
        
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
                if abs((hourInt1*60 + minuteInt1) - (hourInt2*60 + minuteInt2)) < 60 {
                    return "\(abs((hourInt1*60 + minuteInt1) - (hourInt2*60 + minuteInt2))) phút"
                } else {
                    return "\(abs(hourInt1 - hourInt2)) giờ"
                }
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

