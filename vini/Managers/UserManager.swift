//
//  UserManager.swift
//  vini
//
//  Created by Yi-Chin Hsu on 2021/11/4.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

class UserManager {
    
    static let shared = UserManager()
    
    lazy var db = Firestore.firestore()
    
    let userID = Auth.auth().currentUser?.uid
    
    var userBlockList: [String]?
    
    func createNewUser(user: inout User, completion: @escaping (Result<String, Error>) -> Void) {
        
        let document = db.collection("Users").document(user.id)
        user.createdTime = Timestamp(date: Date())
        
        do {
            
            try document.setData(from: user) { error in
                
                if let error = error {
                    
                    completion(.failure(error))
                } else {
                    
                    self.createNewMailBox { result in
                        
                        switch result {
                            
                        case .success(let success):
                            print(success)
                        case .failure(let error):
                            print(error)
                        }
                    }
                    
                    completion(.success("Create new user success!"))
                }
            }
            
        } catch let error {
            
            print(error)
            completion(.failure(error))
        }
    }
    
    func createNewMailBox(completion: @escaping (Result<String, Error>) -> Void) {
        
        if let userID = self.userID {
            
            let document = db.collection("Mailboxes").document(userID)
  
            document.setData(["created_time": Timestamp(date: Date())]) { error in
                
                if let error = error {
                    
                    completion(.failure(error))
                } else {
                    
                    completion(.success("Create New Mailbox Success"))
                    
                    MailManager.shared.sendWelcomeMail { result in
                        
                        switch result {
                            
                        case .success(let success):
                            print(success)
                        case .failure(let error):
                            print(error)
                        }
                    }
                }
            }
        }
        
    }
    
    func updateReflectionTime(userID: String, name: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        
        let document = db.collection("Users").document(userID)
        
        let updateDict = [
            "display_name": name
        ]
        
        document.updateData(updateDict) { error in
            
            if let error = error {
                
                completion(.failure(error))
            } else {
                
                completion(.success(true))
            }
        }
    }
    
    func fetchUser(userID: String, completion: @escaping (Result<User, Error>) -> Void) {
        
        db.collection("Users").document(userID).getDocument { (document, error) in
            
            if let error = error {
                
                completion(.failure(error))
            } else {
                
                if let document = document {
                    
                    var user = User()
                    
                    do {
                        if let userInfo = try document.data(as: User.self, decoder: Firestore.Decoder()) {
                            
                            user = userInfo
                            self.userBlockList = user.blockList
                        }
                        
                    } catch {
                        
                        completion(.failure(error))
                    }
                    
                    completion(.success(user))
                }
                
            }
        }
        
    }
    
    func blockUser(blockUserID: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        
        if let userID = self.userID {
            
            let document = db.collection("Users").document(userID)
            
            let updateDict = [
                "block_list": FieldValue.arrayUnion([blockUserID])
            ]
            
            document.updateData(updateDict) { error in
                
                if let error = error {
                    
                    completion(.failure(error))
                } else {
                    
                    self.userBlockList?.append(blockUserID)
                    completion(.success(true))
                }
            }
        }
    }
    
    func unblockUser(blockUserID: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        
        if let userID = userID {
            
            let document = db.collection("Users").document(userID)
            
            let updateDict = [
                "block_list": FieldValue.arrayRemove([blockUserID])
            ]
            
            document.updateData(updateDict) { error in
                
                if let error = error {
                    
                    completion(.failure(error))
                } else {
                    
                    self.userBlockList?.removeObject(object: blockUserID)
                    completion(.success(true))
                }
            }
        }
        
    }
    
}
