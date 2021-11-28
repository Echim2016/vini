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
    
    let mailboxDatabase = Firestore.firestore().collection(FSCollection.mailboxes.rawValue)
    
    let userDatabase = Firestore.firestore().collection(FSCollection.users.rawValue)
    
    let welcomeMailSenderID = "WelcomeMail"
    
    func fetchData(blockList: [String], completion: @escaping Handler<[Mail]>) {
        
        if let userID = UserManager.shared.userID {
            
            let ref = mailboxDatabase.document(userID)
            ref.collection(FSCollection.mails.rawValue).order(by: "sent_time", descending: true).getDocuments() { (querySnapshot, error) in
        
                if let error = error {
                    
                    completion(.failure(error))
                } else {
                    
                    var mails = [Mail]()
                    for document in querySnapshot!.documents {
                        
                        do {
                            if let mail = try document.data(as: Mail.self, decoder: Firestore.Decoder()) {
                               
                                if !blockList.contains(mail.senderID) {
                                    
                                    mails.append(mail)
                                }
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
    
    func sendMails(mail: inout Mail, completion: @escaping Handler<String>) {
        
        let document = mailboxDatabase.document(mail.recipientID).collection(FSCollection.mails.rawValue).document()
        mail.id = document.documentID
        mail.sentTime = Timestamp(date: Date())
        
        do {
            
            try document.setData(from: mail) { error in
                
                if let error = error {
                    
                    completion(.failure(error))
                } else {
                    
                    completion(.success("Success: send a mail"))
                }
            }
            
        } catch let error {
            
            print(error)
            completion(.failure(error))
        }
    }
    
    func sendWelcomeMail(completion: @escaping Handler<String>) {
        
        if let id = UserManager.shared.userID {
            
            var welcomeMail = Mail()
            welcomeMail.setupWelcomeMail()
            
            let document = mailboxDatabase.document(id).collection(FSCollection.mails.rawValue).document()
            welcomeMail.id = document.documentID
            welcomeMail.recipientID = id
            welcomeMail.sentTime = Timestamp(date: Date())
            
            do {
                
                try document.setData(from: welcomeMail) { error in
                    
                    if let error = error {
                        
                        completion(.failure(error))
                    } else {
                        
                        completion(.success("Success: send welcome mail"))
                    }
                }
                
            } catch let error {
                
                print(error)
                completion(.failure(error))
            }
        }
    }
    
    func deleteMail(mailID: String, completion: @escaping Handler<String>) {
        
        if let userID = UserManager.shared.userID {
        
            mailboxDatabase.document(userID).collection(FSCollection.mails.rawValue).document(mailID).delete() { err in
                
                if let err = err {
                    print("Error removing mail: \(err)")
                    completion(.failure(err))
                } else {
                    print("Mail successfully removed!")
                    
                    completion(.success("Success: delete a mail"))
                }
            }
        }
    }
    
    func updateReadTime(mailID: String, completion: @escaping Handler<String>) {
        
        if let userID = UserManager.shared.userID {
            
            let document = mailboxDatabase.document(userID).collection(FSCollection.mails.rawValue).document(mailID)
            
            let updateDict = [
                "read_timestamp": Timestamp(date: Date())
            ]
            
            document.updateData(updateDict) { error in
                
                if let error = error {
                    
                    completion(.failure(error))
                } else {
                    
                    completion(.success("Success: update read time"))
                }
            }
        }
        
    }
    
    func getReflectionTime(completion: @escaping Handler<Int>) {
        
        if let userID = UserManager.shared.userID {
            
            userDatabase.document(userID).getDocument { (document, error) in
                
                if let error = error {
                    
                    completion(.failure(error))
                } else {
                    
                    if let document = document {
                        
                        guard let startTime = document.get("preferred_reflection_hour") as? Int else {
                            return
                        }
                        
                        completion(.success(startTime))
                    }
                }
            }
        }
    }
    
    func updateReflectionTime(time: Int, completion: @escaping Handler<String>) {
        
        if let userID = UserManager.shared.userID {
            
            let document = userDatabase.document(userID)
            
            let updateDict = [
                "preferred_reflection_hour": time
            ]
            
            document.updateData(updateDict) { error in
                
                if let error = error {
                    
                    completion(.failure(error))
                } else {
                    
                    completion(.success("Success: update reflection time"))
                }
            }
        }
    }
    
    func fetchNumberOfUnreadMails(completion: @escaping Handler<Int>) {
        
        if let userID = UserManager.shared.userID {
            
            var count = 0
            
            mailboxDatabase.document(userID).collection(FSCollection.mails.rawValue).getDocuments { (querySnapshot, err) in
                
                if let err = err {
                    print("Error getting number of mails: \(err)")
                    completion(.failure(err))
                    
                } else {
                    
                    guard let querySnapshot = querySnapshot else { return }
                    
                    for document in querySnapshot.documents {
                        
                        if document.get("read_timestamp") == nil {
                            count += 1
                        }
                    }
                        
                    completion(.success(count))
                    
                }
            }
        }
    }
    
}
