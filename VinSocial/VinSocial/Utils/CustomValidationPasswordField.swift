//
//  CustomValidationField.swift
//  Messenger
//
//  Created by Đinh Thái Sơn on 13/02/2023.
//

import SwiftUI

struct CustomValidationPasswordField:View{
    @Binding var text: String
    var body: some View{
        if text.count > 0 {
            VStack(alignment: .leading){
                    if (text.count < 8) {
                        HStack{
                            Image("gray_check")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20,height: 20)
                                .foregroundColor(Color(red: 239/255, green: 60/255, blue: 77/255))
                            
                            Text(LocalizedStringKey("Validate_Over_8_Characters")).foregroundColor(Color(red: 239/255, green: 60/255, blue: 77/255))
                        }
                    } else{
                        HStack {
                            Image("green_check")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20,height: 20)
                                .foregroundColor(Color.green)
                            
                            Text(LocalizedStringKey("Validate_Over_8_Characters")).foregroundColor(Color.green)
                        }
                    }
                    
                    let capitalLetterReg1 = ".*[A-Z]+.*"
                    let textTest1 = NSPredicate(format: "SELF MATCHES %@", capitalLetterReg1)
                    let capitalResust1 = textTest1.evaluate(with: text)
                    if (capitalResust1) {
                        HStack {
                            Image("green_check")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20,height: 20)
                                .foregroundColor(Color.green)
                            
                            Text(LocalizedStringKey("Validate_At_Least_One_Upper_Case")).foregroundColor(Color.green)
                        }
                        
                    } else {
                        HStack {
                            Image("gray_check")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20,height: 20)
                                .foregroundColor(Color(red: 239/255, green: 60/255, blue: 77/255))
                            
                            Text(LocalizedStringKey("Validate_At_Least_One_Upper_Case")).foregroundColor(Color(red: 239/255, green: 60/255, blue: 77/255))
                        }
                        
                    }
                    
                    let capitalLetterReg2 = "^(?=.*[a-zA-Z])(?=.*[0-9]).*$"
                    let textTest2 = NSPredicate(format: "SELF MATCHES %@", capitalLetterReg2)
                    let capitalResust2 = textTest2.evaluate(with: text)
                    if (capitalResust2) {
                        HStack {
                            Image("green_check")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20,height: 20)
                                .foregroundColor(Color.green)
                            
                            Text(LocalizedStringKey("Validate_Contains_Both_Number_And_Letter")).foregroundColor(Color.green)
                        }
                        
                    } else {
                        HStack {
                            Image("gray_check")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20,height: 20)
                                .foregroundColor(Color(red: 239/255, green: 60/255, blue: 77/255))
                            
                            Text(LocalizedStringKey("Validate_Contains_Both_Number_And_Letter")).foregroundColor(Color(red: 239/255, green: 60/255, blue: 77/255))
                        }
                    }
            }
        }
        
    }
}

