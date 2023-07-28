//
//  ShimmerView.swift
//  VinSocial
//
//  Created by Stealer Of Souls on 3/21/23.
//

import SwiftUI

struct ShimmerView: View {
    @State var data : [Card] = []

    var body: some View {
        VStack(spacing: 0){
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 4){
                    ForEach(self.data){i in
                        ZStack{
                            // Showing Only When Data Is Loading...
                            // because show variable is animating...
                            // Shimmer Card.
                                HStack(spacing: 15){
                                    
                                    Circle()
                                        .fill(Color.black.opacity(0.09))
                                        .frame(width: 75, height: 75)
                                    
                                    VStack(alignment: .leading, spacing: 12) {
                                        
                                        Rectangle()
                                            .fill(Color.black.opacity(0.09))
                                            .frame(width: 250, height: 15)
                                        
                                        Rectangle()
                                            .fill(Color.black.opacity(0.09))
                                            .frame(width: 100, height: 15)
                                    }
                                    
                                    Spacer(minLength: 0)
                                }
                                
                                // Shimmer Animation...
                                HStack(spacing: 15){
                                    Circle()
                                        .fill(Color.white.opacity(0.6))
                                        .frame(width: 75, height: 75)
                                    
                                    VStack(alignment: .leading, spacing: 12) {
                                        
                                        Rectangle()
                                            .fill(Color.white.opacity(0.6))
                                            .frame(width: 250, height: 15)
                                        
                                        Rectangle()
                                            .fill(Color.white.opacity(0.6))
                                            .frame(width: 100, height: 15)
                                    }
                                    
                                    Spacer(minLength: 0)
                                }
                                // Masking View...
                                .mask(
                                
                                    Rectangle()
                                        .fill(Color.white.opacity(0.6))
                                        .rotationEffect(.init(degrees: 70))
                                    // Moving View....
                                        .offset(x: i.show ? 1000 : -350)
                                )
                            
                        }
                    }
                }
            }
        }
        .onAppear {
            self.loadTempData()
        }
    }
    
    func loadTempData(){
        for i in 0...19{
            let temp = Card(id: "\(i)", name: "", url: "", show: false)
            
            self.data.append(temp)
            
            // Enabling Animation..
            withAnimation(Animation.linear(duration: 1.5).repeatForever(autoreverses: false)){
                
                self.data[i].show.toggle()
            }
        }
    }
}

struct ShimmerView_Previews: PreviewProvider {
    static var previews: some View {
        ShimmerView()
    }
}

struct Card : Identifiable {
    
    var id : String
    var name : String
    var url : String
    var show : Bool
}
