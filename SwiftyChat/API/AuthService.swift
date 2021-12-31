//
//  AuthService.swift
//  SwiftyChat
//
//  Created by John McCants on 12/31/21.
//

import Foundation
import UIKit
import Firebase

struct RegistrationCredentials {
    let email: String
    let password: String
    let fullname: String
    let username: String
    let profileImage: UIImage
}

struct AuthService {
    static let shared = AuthService()
    
    func logUserIn(email: String, password: String, completion: AuthDataResultCallback?) {
        Auth.auth().signIn(withEmail: email, password: password, completion: completion)
    }
    
    func createUser(credentials: RegistrationCredentials, completion: ((Error?) -> Void)?) {
        guard let imageData = credentials.profileImage.jpegData(compressionQuality: 0.5) else { return }

        let filename = NSUUID().uuidString
        let ref = Storage.storage().reference(withPath: "/profile_images/\(filename)")
        
        ref.putData(imageData, metadata: nil) { meta, err in
            if let err = err {
                print("DEBUG: Failed to upload an image with error: \(err.localizedDescription)")
                return
            }
            
            ref.downloadURL { url, er in
                guard let profileImageUrl = url else { return }
                
                Auth.auth().createUser(withEmail: credentials.email, password: credentials.password) { result, error in
                    
                    guard let uid = result?.user.uid else { return }
                    
                    let data = ["email": credentials.email, "fullname": credentials.fullname, "username": credentials.username, "uid": uid, "profileImageUrl": profileImageUrl.absoluteString] as [String : Any]
                    
                    Firestore.firestore().collection("users").document(uid).setData(data, completion: completion)
                    
                }
            }
        }
    }
}
