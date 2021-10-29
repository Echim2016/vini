//
//  DiscoverUserManager.swift
//  vini
//
//  Created by Yi-Chin Hsu on 2021/10/27.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

class DiscoverUserManager {
    
    static let shared = DiscoverUserManager()
    
    lazy var db = Firestore.firestore()
    
    func fetchData(completion: @escaping (Result<[Vini], Error>) -> Void) {
        
        db.collection("Users").whereField("is_published", isEqualTo: true).getDocuments() { (querySnapshot, error) in
            
            if let error = error {
                
                completion(.failure(error))
            } else {
                
                var vinis = [Vini]()
                
                for document in querySnapshot!.documents {
                    
                    do {
                        if let userInfo = try document.data(as: User.self, decoder: Firestore.Decoder()) {
                            
                            let vini = Vini()
                            vini.name = userInfo.displayName
                            vini.wondering = userInfo.wondering
                            vini.viniType = userInfo.viniType
                            vinis.append(vini)
                        }
                        
                    } catch {
                        
                        completion(.failure(error))
                    }
                    
                }
                
                completion(.success(vinis))
            }
        }
    }
    
    func updateUserStatus(id: String, wondering: String, name: String, viniType: String, isOn: Bool, completion: @escaping (Result<String, Error>) -> Void) {
        
        let document = db.collection("Users").document(id)
        
        let updateDict = [
            "display_name": name,
            "wondering": wondering,
            "vini_type": viniType,
            "is_published": isOn
        ] as [String: Any]
        
        document.updateData(updateDict) { error in
            
            if let error = error {
                
                completion(.failure(error))
            } else {
                
                completion(.success("Success"))
            }
        }
    }
    
    func fetchUserProfile(id: String, completion: @escaping (Result<User, Error>) -> Void) {
        
        db.collection("Users").document(id).getDocument{ (document, error) in
            
            if let error = error {
                
                completion(.failure(error))
            } else {
                
                if let document = document {
                    
                    var user = User()
                    
                    do {
                        if let userInfo = try document.data(as: User.self, decoder: Firestore.Decoder()) {
                            
                            user = userInfo
                        }
                        
                    } catch {
                        
                        completion(.failure(error))
                    }
                    
                    completion(.success(user))
                }
                
            }
        }
    }
}
