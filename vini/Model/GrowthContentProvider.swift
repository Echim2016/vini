//
//  GrowthContentProvider.swift
//  vini
//
//  Created by Yi-Chin Hsu on 2021/10/19.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

class GrowthContentProvider {
    
    static let shared = GrowthContentProvider()
    
    lazy var db = Firestore.firestore()
    
    func fetchGrowthContents(id: String, completion: @escaping (Result<[GrowthContent], Error>) -> Void) {
        
        let ref = db.collection("Growth_Cards").document(id)
        
        db.collection("Growth_Contents").whereField("growth_card_id", isEqualTo: ref).order(by: "created_time").getDocuments() { (querySnapshot, error) in
            
            if let error = error {
                
                completion(.failure(error))
            } else {
                
                var growthContents = [GrowthContent]()
                
                for document in querySnapshot!.documents {
                    
                    do {
                        if let growthContent = try document.data(as: GrowthContent.self, decoder: Firestore.Decoder()) {
                            
                            growthContents.append(growthContent)
                        }
                        
                    } catch {
                        
                        completion(.failure(error))
                    }
                }
                
                completion(.success(growthContents))
            }
        }
    }
    
}
