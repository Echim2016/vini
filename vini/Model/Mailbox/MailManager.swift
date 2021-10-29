//
//  MailManager.swift
//  vini
//
//  Created by Yi-Chin Hsu on 2021/10/29.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

class MailManager {
    
    static let shared = MailManager()
    
    lazy var db = Firestore.firestore()
    
    func fetchData(id: String, completion: @escaping (Result<[Mail], Error>) -> Void) {
        
        let userRef = db.collection("Mailboxes").document(id)
        
        userRef.collection("Mails").getDocuments() { (querySnapshot, error) in
            
            if let error = error {
                
                completion(.failure(error))
            } else {
                
                var mails = [Mail]()
                
                for document in querySnapshot!.documents {
                    
                    do {
                        if let mail = try document.data(as: Mail.self, decoder: Firestore.Decoder()) {
                            mails.append(mail)
                        }
                        
                    } catch {
                        
                        completion(.failure(error))
                    }
                    
                }
                
                completion(.success(mails))
            }
        }
        
        
    }
    
    
}
