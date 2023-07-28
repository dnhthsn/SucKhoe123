//
//  ReversedScrollView.swift
//  Testing
//
//  Created by Stealer Of Souls on 2/20/23.
//

import Foundation
import SwiftUI

struct ReversedScrollView<Content: View>: View {
    var axis: Axis.Set
    var content: Content
    
    init(_ axis: Axis.Set = .horizontal, @ViewBuilder builder: ()->Content) {
        self.axis = axis
        self.content = builder()
    }
    
    var body: some View {
        GeometryReader { proxy in
            ScrollView(axis) {
                Stack(axis) {
                    Spacer()
                    content
                }
                .frame(
                    minWidth: minWidth(in: proxy, for: axis),
                    minHeight: minHeight(in: proxy, for: axis)
                )
            }
        }
        
    }
    func minWidth(in proxy: GeometryProxy, for axis: Axis.Set) -> CGFloat? {
        axis.contains(.horizontal) ? proxy.size.width : nil
    }
            
    func minHeight(in proxy: GeometryProxy, for axis: Axis.Set) -> CGFloat? {
        axis.contains(.vertical) ? proxy.size.height : nil
    }
}
    

struct ReversedScrollView_Previews: PreviewProvider {
    static var previews: some View {
        ReversedScrollView(.vertical) {
            ForEach(0..<5) { item in
                Text("\(item)")
                    .padding()
                    .background(Color.gray.opacity(0.5))
                    .cornerRadius(6)
            }
            .frame(maxWidth: .infinity)
        }
    }
}
