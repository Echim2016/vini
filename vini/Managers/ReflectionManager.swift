//
//  ReflectionManager.swift
//  vini
//
//  Created by Yi-Chin Hsu on 2021/11/3.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

class ReflectionManager {
    
    static let shared = ReflectionManager()
    
    lazy var db = Firestore.firestore()
    
    func fetchQuestions(completion: @escaping Handler<[String]>) {
        
        db.collection(FSCollection.reflection.rawValue).document("Questions").getDocument { (document, err) in
            
            if let err = err {
                print("Error getting quotes: \(err)")
                completion(.failure(err))
            } else {
                
                if let document = document, document.exists {
                    
                    guard let list = document.get("question_list") as? [String] else {
                        return
                    }
                
                    completion(.success(list))
                }
            }
        }
    }
    
    func fetchUserReflectionTime(userID: String, completion: @escaping Handler<Int>) {
        
        db.collection(FSCollection.users.rawValue).document(userID).getDocument { (document, err) in
            
            if let err = err {
                print("Error getting quotes: \(err)")
                completion(.failure(err))
            } else {
                
                if let document = document, document.exists {
                    
                    guard let time = document.get("preferred_reflection_hour") as? Int else {
                        return
                    }
                
                    completion(.success(time))
                }
            }
        }
    }
    
}
