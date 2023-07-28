//
//  NotificationView.swift
//  VinSocial
//
//  Created by Đinh Thái Sơn on 16/03/2023.
//

import SwiftUI

struct NotificationView: View {
    @EnvironmentObject var mainTabViewModel: MainTabViewModel
    let notifications: [Notifications]
    var isFetchingNextPageNoti = false
    var nextPageNotiHandler: (() async -> ())? = nil
    @Environment(\.dismiss) var dismiss
    @State var presentBottomSheet = false
    @State var actionDelete : Bool = false
    @State var confirmDelete : Bool = false
    @State var showSheet: Bool = false
    
    var body: some View {
        VStack {
            HStack {
                Image("ic_back_arrow")
                    .resizable()
                    .frame(width: 26, height: 26)
                    .foregroundColor(Color.white)
                    .onTapGesture {
                        dismiss()
                    }
                
                Text(LocalizedStringKey("Label_Notification"))
                    .foregroundColor(Color.white)
                    .font(.system(size: 20))
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                if #available(iOS 16.0, *) {
                    Image("ic_option")
                        .resizable()
                        .frame(width: 25, height: 25)
                        .foregroundColor(Color.white)
                        .onTapGesture {
                            presentBottomSheet.toggle()
                        }
                        .sheet(isPresented: $presentBottomSheet) {
                            BottomSheetNotification(actionDelete: $actionDelete, confirmDelete: $confirmDelete).presentationDetents([.height(100), .large])
                        }
                } else {
                    Image("ic_option")
                        .resizable()
                        .frame(width: 35, height: 25)
                        .foregroundColor(Color.white)
                        .onTapGesture {
                            showSheet.toggle()
                        }
                        .halfSheet(showSheet: $showSheet, sheetView: {
                            BottomSheetNotification(actionDelete: $actionDelete, confirmDelete: $confirmDelete)
                        })
                }
                
                
            }
            .padding(.bottom, 20)
            .padding([.leading, .trailing], 20)
            .background(Color(red: 23/255, green: 136/255, blue: 192/255))
            .frame(maxWidth: .infinity, alignment: .top)
            
//            ScrollView {
//                VStack {
//                    NotificationCell()
//                    NotificationCell()
//                    NotificationCell()
//                    NotificationCell()
//                    NotificationCell()
//                    NotificationCell()
//                    NotificationCell()
//                }
//                .frame(maxHeight: .infinity)
//                .ignoresSafeArea()
//            }
            
            if notifications.isEmpty {
                VStack {
                    Image("empty")
                        .resizable()
                        .frame(width: 200, height: 200)
                    
                    Text("Quý khách hiện không có thông báo nào")
                        .multilineTextAlignment(.center)
                        .foregroundColor(.gray)
                        .frame(width: 200)
                }
                .padding(.top, 200)
            } else {
                ScrollView {
                    VStack{
                        ForEach(notifications) { noti in
                            if let nextPageNotiHandler = nextPageNotiHandler, noti.id == notifications.last?.id {
                                NotificationCell(viewModel: NotiCellViewModel(noti))
                                    .task { await nextPageNotiHandler() }

                                if isFetchingNextPageNoti {
                                    bottomProgressView
                                }

                            } else {
                                NotificationCell(viewModel: NotiCellViewModel(noti))
                            }
                            NotificationCell(viewModel: NotiCellViewModel(noti))
                        }
                        
                    }
                    
                    .padding(.top, 2)
                    
                }
            }
            Spacer()
        }
        .gesture(
            DragGesture()
                .onEnded { gesture in
                    if gesture.translation.width > 100 {
                        dismiss()
                    }
                }
        )
    }
    
    @ViewBuilder
    private var bottomProgressView: some View {
        Divider()
        HStack {
            Spacer()
            ProgressView()
            Spacer()
        }.padding()
    }
}

extension View {
    func halfSheet<SheetView: View>(showSheet: Binding<Bool>, @ViewBuilder sheetView: @escaping ()->SheetView) ->some View {
        return self
            .background(
                HalfSheetHelper(sheetView: sheetView(), showSheet: showSheet)
            )
    }
}

struct HalfSheetHelper<SheetView: View>: UIViewControllerRepresentable {
    var sheetView: SheetView
    @Binding var showSheet: Bool
    
    let controller = UIViewController()
    func makeUIViewController(context: Context) -> UIViewController {
        controller.view.backgroundColor = .clear
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        if showSheet {
            let sheetController = CustomHostingController(rootView: sheetView)
            
            uiViewController.present(sheetController, animated: true) {
                DispatchQueue.main.async {
                    self.showSheet.toggle()
                }
            }
        }
    }
}

class CustomHostingController<Content: View>: UIHostingController<Content> {
    override func viewDidLoad() {
        if let presentationController = presentationController as? UISheetPresentationController {
            presentationController.detents = [
                .medium(),
                .large(),
            ]
            
            presentationController.prefersGrabberVisible = true
            
            presentationController.preferredCornerRadius = 30.0
            
            presentationController.prefersScrollingExpandsWhenScrolledToEdge = false
        }
    }
}

//struct NotificationView_Previews: PreviewProvider {
//    static var previews: some View {
//        NotificationView()
//    }
//}

