//
//  PolicyView.swift
//  Suckhoe123
//
//  Created by Đinh Thái Sơn on 17/07/2023.
//

import SwiftUI

struct PolicyView: View {
    @Environment(\.presentationMode) var mode
    @State var data = ""
    
    func load(file: String) {
        if let filepath = Bundle.main.path(forResource: file, ofType: "txt") {
                    do {
                        let contents = try String(contentsOfFile: filepath)
                        DispatchQueue.main.async {
                            self.data = contents
                        }
                    } catch let error as NSError {
                        print(error.localizedDescription)
                    }
                } else {
                    print("File not found")
                }
    }
    
    var body: some View {
        VStack {
            ZStack(alignment: .leading) {
                Image("ic_back_arrow")
                    .resizable()
                    .foregroundColor(Color.black)
                    .frame(width: 12, height: 20)
                    .onTapGesture {
                        mode.wrappedValue.dismiss()
                    }
                
                Text("Chính sách và pháp lý")
                    .frame(maxWidth: .infinity, alignment: .center)
                    .font(.system(size: 20, weight: .bold))
            }
            .padding(.top, 10)
            
            ScrollView {
                Text(data.htmlToString())
                    .foregroundColor(Color.black)
            }
        }
        .padding([.leading, .trailing], 15)
        .onAppear {
            load(file: "policy")
        }
    }
}

struct PolicyView_Previews: PreviewProvider {
    static var previews: some View {
        PolicyView()
    }
}
