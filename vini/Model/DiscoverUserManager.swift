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
        
        db.collection("Users").getDocuments() { (querySnapshot, error) in
            
            if let error = error {
                
                completion(.failure(error))
            } else {
                
                var vinis = [Vini]()
                
                for document in querySnapshot!.documents {
                    
                    
                    guard let name = document.get("display_name") as? String else { return }
                    
                    let vini = Vini()
                    vini.name = name
                    vinis.append(vini)
                    
                    
//                    do {
//                        if let growthCard = try document.data(as: GrowthCard.self, decoder: Firestore.Decoder()) {
//
//                            growthCards.append(growthCard)
//                        }
//
//                    } catch {
//
//                        completion(.failure(error))
//                    }
                }
                
                completion(.success(vinis))
            }
        }
    }
    
}
