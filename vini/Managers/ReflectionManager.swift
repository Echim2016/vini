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
    
    let database = Firestore.firestore().collection(FSCollection.reflection.rawValue)
    
    func fetchQuestions(completion: @escaping Handler<[String]>) {
        
        database.document("Questions").getDocument { (document, err) in
            
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
    
}
