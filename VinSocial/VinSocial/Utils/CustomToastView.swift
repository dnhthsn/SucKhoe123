//
//  CustomToastView.swift
//  VinChat
//
//  Created by Đinh Thái Sơn on 13/03/2023.
//

import SwiftUI

struct Toast {
    var title: String
    var image: String
}

struct ToastView: View {
    let toast: Toast
    @Binding var show: Bool
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: toast.image)
                Text(toast.title)
                    .multilineTextAlignment(.center)
            }
            .font(.headline)
            .foregroundColor(.primary)
            .padding([.top, .bottom], 20)
            .padding(.horizontal, 40)
            .background(.gray.opacity(0.4), in: Capsule())
            
            Spacer()
        }
        .frame(width: UIScreen.main.bounds.width / 1.25)
        .transition(AnyTransition.move(edge: .bottom).combined(with: .opacity))
        .onTapGesture {
            withAnimation {
                self.show = false
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                withAnimation {
                    self.show = false
                }
            }
        }
    }
}
