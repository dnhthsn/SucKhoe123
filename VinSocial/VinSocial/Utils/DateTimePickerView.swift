//
//  DateTimePickerView.swift
//  Suckhoe123
//
//  Created by Đinh Thái Sơn on 19/05/2023.
//

import SwiftUI

struct DateTimePickerView: View {
    @State private var date = Date()
    @Binding var dateString: String
    
    func convertString(date: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+7")
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "dd/MM/yyyy"
        self.dateString = dateFormatter.string(from: date)
    }
    
    var body: some View {
        HStack {
            Text(self.dateString)
                .foregroundColor(Color(red: 102/255, green: 102/255, blue: 102/255))
                .font(.system(size: 15))
                .frame(maxWidth: .infinity, alignment: .leading)

            Image("ic_date")
                .resizable()
                .frame(width: 25, height: 25)
                .overlay {
                    DatePicker("", selection: $date, displayedComponents: .date)
                        .datePickerStyle(.compact)
                        .blendMode(.destinationOver)
                        .padding(.leading, 5)
                        .onChange(of: date) { output in
                            convertString(date: output)
                        }
                }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 10).fill(Color(red: 244/255, green: 244/255, blue: 244/255)))
        
    }
}
