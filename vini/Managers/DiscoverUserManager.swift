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
    
    let userDatabase = Firestore.firestore().collection(FSCollection.users.rawValue)
    
    private init() { }
    
    func fetchData(category: String, blockList: [String], completion: @escaping Handler<[ViniView]>) {
        
        userDatabase.whereField("is_published", isEqualTo: true).whereField("cloud_category", isEqualTo: category).getDocuments { (querySnapshot, error) in
            
            if let error = error {
                
                completion(.failure(error))
                
            } else {
                
                var vinis = [ViniView]()
                
                for document in querySnapshot!.documents {
                    
                    do {
                        if let userInfo = try document.data(as: User.self, decoder: Firestore.Decoder()) {
                            
                            if !blockList.contains(userInfo.id) {
                                
                                let vini = ViniView()
                                vini.data.id = userInfo.id
                                vini.data.name = userInfo.displayName
                                vini.data.wondering = userInfo.wondering
                                vini.data.viniType = userInfo.viniType
                                vinis.append(vini)
                            }
                            
                        }
                        
                    } catch {
                        
                        completion(.failure(error))
                    }
                    
                }
                
                completion(.success(vinis))
            }
        }
    }
    
    func updateUserStatus(wondering: String, name: String, viniType: String, isOn: Bool, category: String, completion: @escaping Handler<String>) {
        
        if let userID = UserManager.shared.userID {
            
            let document = userDatabase.document(userID)
            
            let updateDict = [
                "display_name": name,
                "wondering": wondering,
                "vini_type": viniType,
                "cloud_category": category,
                "is_published": isOn
            ] as [String: Any]
            
            document.updateData(updateDict) { error in
                
                if let error = error {
                    
                    completion(.failure(error))
                } else {
                    
                    completion(.success("Success"))
                }
            }
        } else {
            
            completion(.failure(ApiError.userIDNotFound))
        }
        
    }
    
    func fetchUserProfile(completion: @escaping Handler<User>) {
        
        if let userID = UserManager.shared.userID {
            
            userDatabase.document(userID).getDocument { (document, error) in
                
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
        } else {
            
            completion(.failure(ApiError.userIDNotFound))
        }
    }
}
