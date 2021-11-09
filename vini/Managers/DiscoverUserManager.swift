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
    
    func fetchData(category: String, completion: @escaping (Result<[ViniView], Error>) -> Void) {
        
        db.collection("Users").whereField("is_published", isEqualTo: true).whereField("cloud_category", isEqualTo: category).getDocuments() { (querySnapshot, error) in
            
            if let error = error {
                
                completion(.failure(error))
            } else {
                
                var vinis = [ViniView]()
                
                for document in querySnapshot!.documents {
                    
                    do {
                        if let userInfo = try document.data(as: User.self, decoder: Firestore.Decoder()) {
                            
                            let vini = ViniView()
                            vini.data.id = userInfo.id
                            vini.data.name = userInfo.displayName
                            vini.data.wondering = userInfo.wondering
                            vini.data.viniType = userInfo.viniType
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
    
    func updateUserStatus(wondering: String, name: String, viniType: String, isOn: Bool, completion: @escaping (Result<String, Error>) -> Void) {
        
        if let userID = UserManager.shared.userID {
            
            let document = db.collection("Users").document(userID)
            
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
        
    }
    
    func fetchUserProfile(completion: @escaping (Result<User, Error>) -> Void) {
        
        if let userID = UserManager.shared.userID {
            
            db.collection("Users").document(userID).getDocument { (document, error) in
                
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
}
