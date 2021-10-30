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
    
    func sendMails(mail: inout Mail, completion: @escaping (Result<String, Error>) -> Void) {
        
        let document = db.collection("Mailboxes").document(mail.receipientID).collection("Mails").document()
        mail.id = document.documentID
        mail.sentTime = Timestamp(date: Date())
        
        do {
            
            try document.setData(from: mail) { error in
                
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
    
    func deleteMail(userID: String, mailID: String, completion: @escaping (Result<String, Error>) -> Void) {
        
        db.collection("Mailboxes").document(userID).collection("Mails").document(mailID).delete() { err in
            
            if let err = err {
                print("Error removing mail: \(err)")
                completion(.failure(err))
            } else {
                print("Mail successfully removed!")
                    
                    completion(.success("Success"))
            }
        }
        
    }
    
    func updateReadTime(userID: String, mailID: String, completion: @escaping (Result<String, Error>) -> Void) {
        
        let document = db.collection("Mailboxes").document(userID).collection("Mails").document(mailID)
        
        let updateDict = [
            "read_timestamp": Timestamp(date: Date())
        ]
        
        document.updateData(updateDict) { error in
            
            if let error = error {
                
                completion(.failure(error))
            } else {
                
                completion(.success("Success"))
            }
        }
    }
    
}
