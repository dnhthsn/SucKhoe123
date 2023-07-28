//
//  CustomShape.swift
//  Kids
//
//  Created by Balaji on 28/09/20.
//

import SwiftUI

struct CustomShape : Shape {
    
    func path(in rect: CGRect) -> Path {
        Path { path in
           
            path.move(to: CGPoint(x: 0 * rect.width,y: 0 * rect.height))

            path.addLine(to: CGPoint(x: 0.8 * rect.width,y: 0 * rect.height))

            path.addLine(to: CGPoint(x: 1 * rect.width,y: 0.1 * rect.height))
            
            path.addLine(to: CGPoint(x:  rect.width,y: 1 * rect.height))
            
            path.addLine(to: CGPoint(x:0,y: 1 * rect.height))
            
//            path.addLine(to: CGPoint(x: 0 * width,y: 0.5 * height))

            path.closeSubpath()
        }
    }
}
