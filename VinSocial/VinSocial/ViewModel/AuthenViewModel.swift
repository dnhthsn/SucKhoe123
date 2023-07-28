//
//  AuthenViewModel.swift
//  Messenger
//
//  Created by Stealer Of Souls on 2/7/23.
//

import Foundation
import Firebase
import UIKit
import SwiftUI
import FacebookLogin
import GoogleSignIn
import AuthenticationServices
import Combine

class AuthenViewModel : NSObject, ObservableObject{
    @Published var shouldShowAlert: Bool = false
    @Published var alertTitle: String = ""
    @Published var alertMessage: String = ""
    
    @Published var didAuthenticateUser = false
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: UserResponse?
    @Published var userDetailInfo: UserInfoRes?
    //@Published var avatarChanged: ChangedAvatar?
    @Published var showLoading: Bool = false
    @Published var showLoadingForget: Bool = false
    @Published var showLoadingChangePass: Bool = false
    @Published var messageRegister: String = ""
    @Published var messageLogin: String = ""
    @Published var messageChangePass: String = ""
    @Published var checkRegister: Bool = false
    @Published var checkForget: Bool = false
    @Published var showNewPass: Bool = false
    @Published var finishChange: Bool = false
    private var tempCurrentUser: FirebaseAuth.User?
    @Published var userFirebase: UserFirebase?
    let loginManager = LoginManager()
    let keyClientGoogle = "213499681043-lgao2r6j6iccmu3h3mtsbknlhtc47v0a.apps.googleusercontent.com"
    
    static var shared = AuthenViewModel()
    
    override init(){
        super.init()
        let json = self.load("USER")
        if(json != nil){
            self.currentUser = UserResponse(JSON: json!)
        }
        userSession = Auth.auth().currentUser;
        checkForget = false
        showNewPass = false
        finishChange = false
        checkRegister = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(getAuthorizationState), name: ASAuthorizationAppleIDProvider.credentialRevokedNotification, object: nil)
    }
    
    func sendDeviceInfo(deviceid: String, token: String) {
        _ = APIService.sharedInstance.httpRequestAPI(ApiRouter.deviceInfo(deviceid: deviceid, system: "ios", token: token)) { response in
            if let deviceInfoResponse = ResponseRequest(JSON: response) {
                if deviceInfoResponse.status1 == "ok" {
                    print("Send device info successful")
                } else {
                    print(deviceInfoResponse.mess ?? "")
                }
            }
        } failure: { error in
            print("\(error.localizedDescription)")
        }
    }
    
    func login(withEmail email: String, password: String,completion: @escaping (Bool) ->Void){
        //        if (!email.isEmpty && !password.isEmpty) {
        self.messageLogin = ""
        self.showLoading = true
        APIService.sharedInstance.httpRequestAPI( ApiRouter.login(email: email, password: password)) { response in
            if let loginResponse = ResponseRequest(JSON: response){
                if loginResponse.status == 1 {
                    var decodedString = ""
                    if let decodedData = Data(base64Encoded: (loginResponse.data?.checknum2)!, options: .ignoreUnknownCharacters) {
                        decodedString = String(data: decodedData, encoding: .utf8)!
                        Auth.auth().signIn(withCustomToken: decodedString){ (result, error) in
                            if error != nil {
                                self.showLoading = true
                            } else {
                                self.showLoading = false
                                self.currentUser = loginResponse.data;
                                //self.userDetailInfo?.fullname = loginResponse.data?.fullname

                                COLLECTION_CONVERSATION.child("Users").child(Auth.auth().currentUser?.uid ?? "").updateChildValues(["device_token": AppDelegate.fcmToken ?? ""]) { (error, ref) in
                                    if(error != nil){
                                        //error to send message
                                        print("update device token error")
                                    }else{
                                        
                                    }
                                }
//
                                let s = loginResponse.data?.toJSON();
                                self.save(json: s!)
                                guard let user = result?.user else {return}
                                self.userSession = user;
                                //self.getUinfo(profileid: "")
                                AuthenViewModel.shared.userSession = user
                                AuthenViewModel.shared.currentUser = self.currentUser
                                self.messageLogin = ""
                                completion(true)
                            }
                        }
                    }
                    
                }else{
                    self.messageLogin = loginResponse.message!
                    self.showLoading = false
                }
            }else{
                print("Erro")
                self.showLoading = false
            }
            
        } failure: { error in
            self.messageLogin = String(localized: "Label_No_Internet_Connection")
            self.showLoading = false
            print(" hoinx response \(error.localizedDescription)")
        }
        
        //        }
    }
    
    func editUinfo(fullname: String, gender: String, birthday: String, address: String, mobile: String, education: String, working: String, description: String,profile:ProfileViewModel) {
        guard let userID = AuthenViewModel.shared.currentUser?.userid else{return}
        guard let checknum = AuthenViewModel.shared.currentUser?.checknum else{return}
        
        let _ = APIService.sharedInstance.httpRequestAPI(ApiRouter.editUinfo(userid: userID, checknum: checknum, fullname: fullname, gender: gender, birthday: birthday, address: address, mobile: mobile, education: education, working: working, description: description)) { response in
            if let editResponse = ResponseEditInfo<UserInfoRes>(JSON: response){
                if editResponse.status == 1 {
//                    self.getUinfo(profileid: "")
                    AuthenViewModel.shared.currentUser?.fullname = editResponse.data?.fullname ?? ""
                    AuthenViewModel.shared.currentUser?.gender = editResponse.data?.gender ?? ""
                    AuthenViewModel.shared.currentUser?.birthday = editResponse.data?.birthday ?? ""
                    AuthenViewModel.shared.currentUser?.address = editResponse.data?.address ?? ""
                    AuthenViewModel.shared.currentUser?.mobile = editResponse.data?.mobile ?? ""
                    AuthenViewModel.shared.currentUser?.education = editResponse.data?.education ?? ""
                    AuthenViewModel.shared.currentUser?.working = editResponse.data?.working ?? ""
                    AuthenViewModel.shared.currentUser?.description = editResponse.data?.description ?? ""
            
                    editResponse.data?.avatar = profile.userDetailInfo?.avatar ?? ""
                    self.userDetailInfo = editResponse.data;
                    profile.userDetailInfo = editResponse.data;
                    
                }else{
                    print("Error loggin==== 6")
                    
                }
            }else{
                print("Erro")
            }
        } failure: { error in
            
            
        }
    }
    
    func updateAvatar(act: Int, image_file: Data, crop_x: Int, crop_y: Int, crop_width: Int, crop_height: Int) {
        guard let userID = AuthenViewModel.shared.currentUser?.userid else{return}
        guard let checknum = AuthenViewModel.shared.currentUser?.checknum else{return}
        
        APIService.sharedInstance.httpUploadFile(ApiRouter.updateAvatar(userid: userID, checknum: checknum, act: act, crop_width: crop_width, crop_height: crop_height), file: image_file, fileType: "", fileName:"" , withName: "image_file") { response in
            if let avatarResponse = BaseResponse<ChangedAvatar>(JSON: response){
                if avatarResponse.status == 1 {
                    //self.avatarChanged = avatarResponse.data
                    self.currentUser?.photo = avatarResponse.data?.avatar ?? ""
                }else{
                    print("Error change avatar: \(avatarResponse.mess ?? "")")
                }
            }else{
                print("Error change avatar")
            }
        } failure: { error in
            print(error.localizedDescription)
        }
    }
    
    func changePassword(passwordold: String, password: String, repassword: String) {
        self.showLoadingChangePass = true
        self.messageChangePass = ""
        guard let userID = AuthenViewModel.shared.currentUser?.userid else{return}
        guard let checknum = AuthenViewModel.shared.currentUser?.checknum else{return}
        
        _ = APIService.sharedInstance.httpRequestAPI(ApiRouter.changePassword(userid: userID, checknum: checknum, passwordold: passwordold, password: password, repassword: repassword)) { response in
            if let changePasswordResponse = ResponseRequest(JSON: response) {
                if changePasswordResponse.status == 1 {
                    print(changePasswordResponse.message ?? "")
                    self.finishChange = true
                    self.messageChangePass = changePasswordResponse.message ?? ""
                    self.signout()
                    self.showLoadingChangePass = false
                } else {
                    self.showLoadingChangePass = false
                    self.messageChangePass = changePasswordResponse.message ?? ""
                }
            } else {
                self.showLoadingChangePass = false
            }
        } failure: { error in
            print(error.localizedDescription)
            self.showLoadingChangePass = false
            self.messageChangePass = ""
        }
    }
    
    @Published var showLoadingGetInfo: Bool = false
    func getUinfo(profileid: String){
        //self.showLoadingGetInfo = true
        guard let userID = AuthenViewModel.shared.currentUser?.userid else{return}
        guard let checknum = AuthenViewModel.shared.currentUser?.checknum else{return}
        let _ = APIService.sharedInstance.httpRequestAPI(ApiRouter.getUinfo(userid: userID, checknum: checknum, profileid: profileid)) { response in
            if let infoResponse = BaseResponse<UserInfoRes>(JSON: response){
                if infoResponse.status == 1 {
                    self.userDetailInfo = infoResponse.data;
                    print("getUinfo \(self.userDetailInfo?.fullname)")
                    AuthenViewModel.shared.userDetailInfo = infoResponse.data	
                }else{
                    print("Error getinfo====")
                }
            }else{
                print("Error get info")
            }
        } failure: { error in
            print(error.localizedDescription)
        }
    }
    
    func forget(userField: String, step: Int, verifykey: String, new_password: String, re_password: String){
        self.showLoadingForget = true
        self.messageChangePass = ""
//        self.checkForget = false
//        self.showNewPass = false
//        self.finishChange = false
        APIService.sharedInstance.httpRequestAPI(ApiRouter.forget(userField: userField, step: step, verifykey: verifykey, new_password: new_password, re_password: re_password)) { response in
            if let infoResponse = ForgetPasswordResponse(JSON: response){
                if infoResponse.status == "ok" {
                    self.showLoadingForget = false
                    print(infoResponse.mess)
                    if step == 1 {
                        self.checkForget = true
                    } else if step == 2 {
                        self.showNewPass = true
                    } else if step == 3 {
                        self.finishChange = true
                    }
                    
                }else{
                    print("Error loggin==== 1 ")
                    self.messageChangePass = infoResponse.mess ?? ""
//                    self.checkForget = false
//                    self.showNewPass = false
//                    self.finishChange = false
                    self.showLoadingForget = false
                }
            }else{
                print("Erro")
                self.messageChangePass = "error"
//                self.checkForget = false
//                self.showNewPass = false
//                self.finishChange = false
                self.showLoadingForget = false
            }
        } failure: { error in
            self.messageChangePass = error.localizedDescription
//            self.finishChange = false
//            self.checkForget = false
//            self.showNewPass = false
            self.showLoadingForget = false
        }
    }
    
    func register(withEmail email:String, password:String,fullname:String, username:String){
        print("RegisterUser from view model")
        self.messageRegister = ""
        self.showLoading = true
        //self.checkRegister = false
        //fullname:"Hoinx",email: "hoinguyenxuan99777@gmail.com", password: "123456@A")
        APIService.sharedInstance.httpRequestAPI( ApiRouter.register(fullname:fullname,email: email, password: password)) { response in
            if let registerResponse = ResponseRegister<UserResponse>(JSON: response){
                if registerResponse.status == 2 {
                    print("Hoinx CREATE TÀI KHOẢN THÀNH CÔNG")
                    //self.currentUser = registerResponse.data;
                    let s = registerResponse.data?.toJSON();
                    //self.save(json: s!)
                    self.messageRegister = registerResponse.message ?? ""
                    
                    Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                        if let _eror = error {
                            print("HOINX \(_eror.localizedDescription)" )
                            self.showLoading = true
                            //self.checkRegister = false
                            return;
                        }
                        self.checkRegister = true
                        self.showLoading = false
                        print("HOINX CREATE USER SUCCESS FULL TO FIREBASE" )
                        
                    }
                    //self.checkRegister = true
                    self.showLoading = false
                }else{
                    print("HOINX CREATE false" )
                    print(registerResponse.message!)
                    //self.checkRegister = false
                    self.showLoading = false
                    self.messageRegister = registerResponse.message!
                }
        
            }
        } failure: { error in
            //self.checkRegister = false
            self.showLoading = false
            self.messageLogin = String(localized: "Label_No_Internet_Connection")
            print(" hoinx response \(error.localizedDescription)")
        }
        
       
    }
    
//    func uploadProfileImage(_ image: UIImage){
//        guard let uid = tempCurrentUser?.uid else{return}
//        ImageUploader.uploadImage(image: image) { imageUrl in
//            COLLECTION_USER.document(uid).updateData(["profileImageUrl":imageUrl]){_ in
//                self.userSession = self.tempCurrentUser
//                print("SUCCESS UPDATE")
//            }
//        }
//        
//        
//    }
    
    func signout(){
        self.currentUser = nil
        self.userDetailInfo = nil
        UserDefaults.standard.removeObject(forKey: "USER")
        deleteUserData()
        try? Auth.auth().signOut()
        AuthenViewModel.shared.userSession = nil
        AuthenViewModel.shared.currentUser = nil

        UIApplication.shared.windows.first?.rootViewController?.viewWillAppear(false)

        
    }
    
    func save(json: [String:Any]) {
        UserDefaults.standard.set(json, forKey: "USER")
        UserDefaults.standard.synchronize()
    }
    
    func load(_ key:String) -> [String:Any]?
    {
        if let data = UserDefaults.standard.value(forKey: key) as? [String:Any] {
            return data
        }
        return nil
    }
    
    func loginFacebook(completion: @escaping (Bool) ->Void){
        loginManager.logIn(permissions: [.publicProfile, .email], viewController: nil) { loginResult in
            switch loginResult {
            case .failed(let error):
                print(error)
                self.messageLogin = String(localized: "Label_No_Internet_Connection")
            case .cancelled:
                print("User cancelled login.")
            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                GraphRequest(graphPath: "me", parameters: ["fields": "id, name, email, first_name "]).start(completionHandler: { (connection, result, error) -> Void in
                    if (error == nil){
                        let fbDetails = result as! NSDictionary
                        self.loginSocial(server: "facebook", id: fbDetails["id"] as! String, email: fbDetails["email"] as! String, phone: "", first_name: fbDetails["name"] as! String, gender: "", avatar_url: "",completion: completion)
                    }
                })
            }
        }
    }
    
    func loginGoolge(completion: @escaping (Bool) ->Void){
        guard let presentingViewController = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController else {return}
        GIDSignIn.sharedInstance.signIn(
            with: GIDConfiguration.init(clientID: keyClientGoogle),
            presenting: presentingViewController,
            callback: { user, error in
                if let error = error {
                    print("error: \(error.localizedDescription)")
                    self.messageLogin = error.localizedDescription
                }
                else if let user = user {
                    self.loginSocial(server: "google", id: user.userID!, email: user.profile?.email ?? "", phone: "", first_name: user.profile?.name ?? "", gender: "", avatar_url: "",completion: completion)
                }
            })
    }
    func loginSocial(server: String, id: String, email: String, phone: String, first_name: String, gender: String, avatar_url: String,completion: @escaping (Bool) ->Void){
        self.showLoading = true
        self.messageLogin = ""
        APIService.sharedInstance.httpRequestAPI(ApiRouter.loginSocial(server: server, id: id, email: email, phone: phone, first_name: first_name, gender: gender, avatar_url: avatar_url)) {response in
            if let loginResponse = ResponseRequest(JSON: response){
                if loginResponse.data != nil {
                    if let checknum2 = loginResponse.data?.checknum2{
                        var decodedString = ""
                        if let decodedData = Data(base64Encoded: checknum2, options: .ignoreUnknownCharacters) {
                            decodedString = String(data: decodedData, encoding: .utf8)!
                            Auth.auth().signIn(withCustomToken: decodedString){ (result, error) in
                                if result != nil{
                                    self.showLoading = false
                                    self.currentUser = loginResponse.data;
                                    let s = loginResponse.data?.toJSON();
                                    self.save(json: s!)
                                    guard let user = result?.user else {return}
                                    self.userSession = user;
                                    AuthenViewModel.shared.userSession = user
                                    AuthenViewModel.shared.currentUser = self.currentUser
                                    //self.getUinfo(profileid: "")
                                    completion(true)
                                    COLLECTION_CONVERSATION.child("Users").child(Auth.auth().currentUser?.uid ?? "").updateChildValues(["device_token": AppDelegate.fcmToken ?? ""]) { (error, ref) in
                                        if(error != nil){
                                            //error to send message
                                            print("update device token error")
                                        }else{
                                            
                                        }
                                    }
                                }else{
                                    self.showLoading = false
                                    self.messageLogin = loginResponse.message!
                                    print("Error login Firebase")
                                }
                            }
                        }else{
                            self.showLoading = false
                            self.messageLogin = loginResponse.message!
                            print("Error base 64")
                        }
                    }else{
                        self.showLoading = false
                        self.messageLogin = loginResponse.message!
                        print("Error checknum2 is nil")
                    }
                }
            }else{
                self.showLoading = false
                print("HOINX CREATE false" )
            }
        } failure: { error in
            self.showLoading = false
            self.messageLogin = String(localized: "Label_No_Internet_Connection")
        }
    }
    
    func loginWithAppleId(result: Result<ASAuthorization, Error>,completion: @escaping (Bool) ->Void) {
        self.showLoading = true
        switch result {
        case .success(let auth):
            self.showLoading = false
            guard let credential = auth.credential as? ASAuthorizationAppleIDCredential else{
                shouldShowAlert = true
                alertTitle = "Error"
                alertMessage = "Something went wrong. Please try again later."
                self.deleteUserData()
                return
            }
            
            let userId = credential.user
            let email = credential.email
            let firstName = credential.fullName?.givenName
            let lastName = credential.fullName?.familyName
            print(userId)
            
            self.loginSocial(server: "apple", id: userId, email: email ?? "", phone: "", first_name: firstName ?? "", gender: "", avatar_url: "",completion:completion)
            
//            self.loginSocial(server: "apple", id: "000857.1cb7623c9be141568d7f8fee363da158.0909", email: "dnhthsn2000@gmail.com", phone: "", first_name: "Thái Sơn", gender: "", avatar_url: "")
        case .failure(let error):
            print(error)
            self.deleteUserData()
            shouldShowAlert = true
            alertTitle = "Error"
            alertMessage = error.localizedDescription
            self.showLoading = false
        }
    }
    
    //store the user information in UserDefaults
    func saveUserData(name: String?, email: String?, userId: String?){
        UserDefaults.standard.setValue(name, forKey: "name")
        UserDefaults.standard.setValue(email, forKey: "email")
        UserDefaults.standard.setValue(userId, forKey: "userId")
    }
        
    //store nil for all user information in USerDefaults
    func deleteUserData(){
        UserDefaults.standard.setValue(nil, forKey: "name")
        UserDefaults.standard.setValue(nil, forKey: "email")
        UserDefaults.standard.setValue(nil, forKey: "userId")
    }
    
    @objc func getAuthorizationState() {
        let provider = ASAuthorizationAppleIDProvider()
        if let userId = UserDefaults.standard.value(forKey: "userId") as? String {
            provider.getCredentialState(forUserID: userId) { [self] (state, error) in
                switch state {
                case .authorized:
                    // Credential are still valid
                    break
                case .revoked:
                    //Credential is revoked. It is similar to Logout. Show login screen.
                    self.deleteUserData()
                    break
                case .notFound:
                    //Credential was not found. Show login screen.
                    self.deleteUserData()
                    break
                case .transferred:
                    //The app is transfeered from one development team to another development team. You need to login again so show login screen.
                    self.deleteUserData()
                    break
                default:
                    break
                }
            }
        }
    }
    
}
