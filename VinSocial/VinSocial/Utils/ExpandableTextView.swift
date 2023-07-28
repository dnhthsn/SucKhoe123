//
//  ExpandableTextView.swift
//  Suckhoe123
//
//  Created by Đinh Thái Sơn on 25/04/2023.
//

import SwiftUI

struct ExpandableTextView: View {
    @State private var isExpand = false
    
    let text: String
    let maxLines: Int
//    @State private var attributedString: NSAttributedString?
//
//    init(text:String,maxLines:Int) {
//        self.text = text
//        self.maxLines = maxLines
//        attributedString = self.text.htmlToAttributedString()
//       }
    
    var body: some View {
        VStack(alignment: .leading) {
//            let test = print(attributedString?.string)
//            if let attributedString = attributedString {
//                Text(attributedString.string)
//                    .font(.system(size: 20))
//                    .lineLimit(isExpand ? nil : maxLines)
//                    .minimumScaleFactor(20)
//                    .frame(maxWidth: .infinity, alignment: .leading)
//            } else {
//                Text(text)
//                    .font(.system(size: 20))
//                    .lineLimit(isExpand ? nil : maxLines)
//                    .minimumScaleFactor(20)
//                    .frame(maxWidth: .infinity, alignment: .leading)
//            }
            Text(text)
                .font(.system(size: 20))
                .lineLimit(isExpand ? nil : maxLines)
                .minimumScaleFactor(20)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            if !isExpand && text.count >= 120 {
                Button(action: {
                    isExpand.toggle()
                }, label: {
                    Text("Xem thêm")
                        .foregroundColor(Color.blue)
                        .font(.subheadline)
                })
                .padding(.trailing, 5)
            }
        }
        .onTapGesture{
            isExpand = false
        }
    }
    
    
}

extension NSAttributedString {
    convenience init?(htmlString: String) {
        guard let data = htmlString.data(using: .utf8) else { return nil }
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        try? self.init(data: data, options: options, documentAttributes: nil)
    }
}

extension String {
    func htmlToAttributedString() -> NSAttributedString? {
        guard let data = self.data(using: .utf8) else { return nil }
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        do {
            return try NSAttributedString(data: data, options: options, documentAttributes: nil)
        } catch {
            print("Error converting HTML to attributed string: \(error)")
            return nil
        }
    }
}

