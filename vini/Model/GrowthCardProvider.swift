//
//  GrowthCardProvider.swift
//  vini
//
//  Created by Yi-Chin Hsu on 2021/10/18.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

class GrowthCardProvider {
    
    static let shared = GrowthCardProvider()
    
    lazy var db = Firestore.firestore()
    
    func fetchData(completion: @escaping (Result<[GrowthCard], Error>) -> Void) {
        
        db.collection("Growth_Cards").order(by: "created_time", descending: true).getDocuments() { (querySnapshot, error) in
            
            if let error = error {
                
                completion(.failure(error))
            } else {
                
                var growthCards = [GrowthCard]()
                
                for document in querySnapshot!.documents {
                    
                    do {
                        if let growthCard = try document.data(as: GrowthCard.self, decoder: Firestore.Decoder()) {
                            
                            growthCards.append(growthCard)
                        }
                        
                    } catch {
                        
                        completion(.failure(error))
                    }
                }
                
                completion(.success(growthCards))
            }
        }
    }
    
    func addData(growthCard: inout GrowthCard, completion: @escaping (Result<String, Error>) -> Void) {
        
        let document = db.collection("Growth_Cards").document()
        growthCard.id = document.documentID
        growthCard.createdTime = Timestamp(date: Date())
        
        do {
            
            try document.setData(from: growthCard) { error in
                
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
    
    func updateConclusion(id: String, conclusion: String, completion: @escaping (Result<String, Error>) -> Void) {
        
        let document = db.collection("Growth_Cards").document(id)
        
        document.updateData(["conclusion": conclusion]) { error in
            
            if let error = error {
                
                completion(.failure(error))
            } else {
                
                completion(.success("Success"))
            }
        }
    }
    
    func fetchConclusion(id: String, completion: @escaping (Result<String, Error>) -> Void) {
        
        let document = db.collection("Growth_Cards").document(id)
        
        document.getDocument{ (document, error) in
            
            if let document = document, document.exists {
                
                guard let documentData = document.data() else { return }
                
                let conclusion = documentData["conclusion"] as? String ?? ""
                completion(.success(conclusion))

            } else {
                print("Conclusion does not exist")
                completion(.failure(error!))
            }
        }
    }
}
