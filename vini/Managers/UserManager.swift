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
    
    func createNewUser(user: inout User, completion: @escaping (Result<String, Error>) -> Void) {
        
        let document = db.collection("Users").document(user.id)
        user.createdTime = Timestamp(date: Date())
        
        do {
            
            try document.setData(from: user) { error in
                
                if let error = error {
                    
                    completion(.failure(error))
                } else {
                    
                    completion(.success("Success"))
                }
            }
            
        } catch let error {
            
            print(error)
            completion(.failure(error))
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
    
    
      
}
