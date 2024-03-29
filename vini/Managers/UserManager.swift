//
//  UserManager.swift
//  vini
//
//  Created by Yi-Chin Hsu on 2021/11/4.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

typealias Handler<T> = (Result<T, Error>) -> Void

class UserManager {
    
    static let shared = UserManager()
    
    let userDatabase = Firestore.firestore().collection(FSCollection.users.rawValue)
    
    let mailboxDatabase = Firestore.firestore().collection(FSCollection.mailboxes.rawValue)
    
    private(set) var userID = Auth.auth().currentUser?.uid
    
    var userBlockList: [String]?
    
    enum BlockAction {
        
        case block
        case unblock
    }
    
    private init() { }
    
    func createNewUser(user: inout User, completion: @escaping Handler<String>) {
        
        let document = userDatabase.document(user.id)
        user.createdTime = Timestamp(date: Date())
        userID = user.id
        
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
    
    func deleteUser(completion: @escaping Handler<Bool>) {
        
        let user = Auth.auth().currentUser
                
        user?.delete { error in
          if let error = error {

              completion(.failure(error))
              
          } else {

              print("User Deletion Success")
              completion(.success(true))
          }
        }
    }
    
    func createNewMailBox(completion: @escaping Handler<String>) {
        
        if let userID = self.userID {
            
            let document = mailboxDatabase.document(userID)
  
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
        } else {
            
            completion(.failure(ApiError.userIDNotFound))
        }
        
    }
    
    func updateDisplayName(name: String, completion: @escaping Handler<Bool>) {
        
        if let userID = self.userID {
                        
            let document = userDatabase.document(userID)
            
            let updateDict = [
                "display_name": name
            ]
            
            document.updateData(updateDict) { error in
                
                if let error = error {
                    print("display name error")
                    completion(.failure(error))
                } else {
                    print("update success")
                    completion(.success(true))
                }
            }
        } else {
            
            completion(.failure(ApiError.userIDNotFound))
        }
        
    }
    
    func fetchUser(userID: String, completion: @escaping Handler<User>) {
        
       userDatabase.document(userID).getDocument { (document, error) in
            
            if let error = error {
                
                completion(.failure(error))
                
            } else {
                
                if let document = document {
                    
                    var user = User()
                    
                    do {

                        let userInfo = try document.data(as: User.self, decoder: Firestore.Decoder())
                        
                            user = userInfo
                        
                            self.userBlockList = user.blockList
                        
                    } catch {
                        
                        completion(.failure(error))
                    }
                    
                    completion(.success(user))
                }
                
            }
        }
        
    }
    
    func updateBlockUserList(blockUserID: String, action: BlockAction, completion: @escaping Handler<Bool>) {
        
        if let userID = self.userID {
            
            let document = userDatabase.document(userID)
            
            var updateDict: [String: FieldValue] = [:]
            
            switch action {
            case .block:
                updateDict["block_list"] = FieldValue.arrayUnion([blockUserID])
            case .unblock:
                updateDict["block_list"] = FieldValue.arrayRemove([blockUserID])
            }
            
            document.updateData(updateDict) { error in
                
                if let error = error {
                    
                    completion(.failure(error))
                } else {
                    
                    switch action {
                    case .block:
                        self.userBlockList?.append(blockUserID)
                    case .unblock:
                        self.userBlockList?.removeObject(object: blockUserID)
                    }
                    
                    completion(.success(true))
                }
            }
        } else {
            
            completion(.failure(ApiError.userIDNotFound))
        }
    }
    
}
