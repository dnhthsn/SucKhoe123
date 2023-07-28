//
//  ProfileInformationView.swift
//  VinSocial
//
//  Created by Đinh Thái Sơn on 15/03/2023.
//

import SwiftUI

struct ProfileInformationView: View {
    @EnvironmentObject var homeViewModel: HomeViewModel
    private let user: UserInfoRes?
    @State var showWritePostView: Bool = false
    @State var currentUserId: String
    var fontSize: CGFloat = 16

    init(user: UserInfoRes?,currentUserId:String) {
        self.user = user
        self.currentUserId = currentUserId
    }
    
    var body: some View {
        VStack {
            if AuthenViewModel.shared.currentUser?.userid == currentUserId {
                Button(action: {
                    showWritePostView.toggle()
                    
                }, label: {
                    Image("ic_edit")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(Color.white)
                    
                    Text(LocalizedStringKey("Label_Post_Status"))
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding([.top, .bottom])
                })
                .frame(maxWidth: .infinity)
                .background(Color(red: 23/255, green: 136/255, blue: 192/255))
                .cornerRadius(10)
                .shadow(radius: 5)
            }
           
            
            HStack {
                Image("ic_education")
                    .resizable()
                    .frame(width: 30, height: 30)
                
                Text(LocalizedStringKey("Label_Education \(user?.education ?? "")"))
                    .foregroundColor(Color.black)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 5)
            }
            
            HStack {
                Image("ic_location")
                    .resizable()
                    .frame(width: 30, height: 30)
                
                Text(LocalizedStringKey("Label_Location \(user?.address ?? "")"))
                    .foregroundColor(Color.black)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 5)
            }
            
            HStack {
                Image("ic_option")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .foregroundColor(Color(red: 23/255, green: 136/255, blue: 192/255))
                
                Text(LocalizedStringKey("Label_Other_Information"))
                    .foregroundColor(Color.black)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 5)
            }
            if user?.list_function != nil {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 10) {
                        // Displaying Tags.....
                        ForEach(getRows(),id: \.self){rows in
                            HStack(spacing: 6){
                                ForEach(rows){row in
                                    // Row View....
                                    RowView(tag: row)
                                }
                            }
                        }
                    }
                    .frame(width: UIScreen.main.bounds.width - 80,alignment: .leading)
                    .padding(.bottom,16)
                }
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .strokeBorder(Color("Tag").opacity(0.15),lineWidth: 1)
                )
                // Animation...
                .animation(.easeInOut, value: user?.list_function!)

            }
           
        }
        .padding([.leading, .trailing])
        .fullScreenCover(isPresented: $showWritePostView, content: {
            if AuthenViewModel.shared.currentUser != nil {
                WritePostView(user: AuthenViewModel.shared.currentUser!,homeViewModel: homeViewModel, isEditPost: false, postid: "")
            }else{
                
            }
        })
    }
    
    
    // Adding Geometry Effect to Tag...
    @Namespace var animation
    @ViewBuilder
    func RowView(tag: ListFunction)->some View{
        HStack{
            Image(getImageIcon(tag:tag))
                .resizable()
                .scaledToFit()
                .frame(width: 20,height: 20)
                .foregroundColor(Color(red: 23/255, green: 136/255, blue: 192/255))
                .padding([.top, .bottom], 5)
                .padding(.leading, 8)
            Text(tag.title ?? "")
            // applying same font size..
            // else size will vary..
                .font(.system(size: fontSize))
            // adding capsule..
                .padding(.horizontal,8)
                .foregroundColor(Color(red: 23/255, green: 136/255, blue: 192/255))
                .lineLimit(1)
            // Delete...
                .contentShape(Capsule())
        }
        .background(Capsule().fill(Color(red: 238/255, green: 249/255, blue: 255/255)))
        .contextMenu{
            Button("Delete"){
                // deleting...
//                    user?.list_function?.remove(at: getIndex(tag: tag))
            }
        }
        .matchedGeometryEffect(id: tag.id, in: animation)
    }
    
    func getIndex(tag: ListFunction)->Int{
        let index = user?.list_function?.firstIndex { currentTag in
            return tag.id == currentTag.id
        } ?? 0
        return index
    }
    
    func getImageIcon(tag: ListFunction)->String{
        guard let act = tag.act else { return ""}
        switch act {
        case "coupons":
            return "ic_collaborators"
        case "benh-an":
            return "ic_medical_report"
        default:
            return "ic_collaborators"
        }
    }
    
    // Basic Logic..
    // Splitting the array when it exceeds the screen size....
    func getRows()->[[ListFunction]]{
        
        var rows: [[ListFunction]] = []
        var currentRow: [ListFunction] = []
        
        // caluclating text width...
        var totalWidth: CGFloat = 0
        
        // For safety extra 10....
        let screenWidth: CGFloat = UIScreen.main.bounds.width - 90
        user?.list_function!.forEach { tag in
            
            // updating total width...
            // getting Text Size....
            let font = UIFont.systemFont(ofSize: fontSize)
            
            let attributes = [NSAttributedString.Key.font: font]
            
            let size = (tag.title! as NSString).size(withAttributes: attributes)
            
            
            // adding the capsule size into total width with spacing..
            // 14 + 14 + 6 + 6
            // extra 6 for safety...
            totalWidth += (size.width + 20+24)
            
            // checking if totalwidth is greater than size...
            if totalWidth > screenWidth{
                
                // adding row in rows...
                // clearing the data...
                // checking for long string...
                totalWidth = (!currentRow.isEmpty || rows.isEmpty ? (size.width + 20+24) : 0)
                
                rows.append(currentRow)
                currentRow.removeAll()
                currentRow.append(tag)
                
            }else{
                currentRow.append(tag)
            }
        }
        
        // Safe check...
        // if having any value storing it in rows...
        if !currentRow.isEmpty{
            rows.append(currentRow)
            currentRow.removeAll()
        }
        
        return rows
    }
}





//struct ProfileInformationView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProfileInformationView()
//    }
//}
