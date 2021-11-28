//
//  GrowthCardManager.swift
//  vini
//
//  Created by Yi-Chin Hsu on 2021/10/18.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

class GrowthCardManager {
    
    static let shared = GrowthCardManager()
        
    let cardDatabase = Firestore.firestore().collection(FSCollection.growthCard.rawValue)
    let contentDatabase = Firestore.firestore().collection(FSCollection.growthContents.rawValue)
    
    func fetchData(isArchived: Bool, completion: @escaping (Result<[GrowthCard], Error>) -> Void) {
        
        if let userID = UserManager.shared.userID {
            
            // swiftlint:disable line_length
            cardDatabase.whereField("user_id", isEqualTo: userID).whereField("is_archived", isEqualTo: isArchived).order(by: "created_time", descending: true).getDocuments { (querySnapshot, error) in
                // swiftlint:able line_length
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
        
    }
    
    func addData(growthCard: inout GrowthCard, completion: @escaping (Result<String, Error>) -> Void) {
        
        let document = cardDatabase.document()
        growthCard.id = document.documentID
        growthCard.createdTime = Timestamp(date: Date())
        
        do {
            
            try document.setData(from: growthCard) { error in
                
                if let error = error {
                    
                    completion(.failure(error))
                } else {
                    
                    completion(.success("Success: adding growth card"))
                }
            }
            
        } catch let error {
            
            print(error)
            completion(.failure(error))
        }
    }
    
    func updateConclusion(id: String, conclusion: String, completion: @escaping (Result<String, Error>) -> Void) {
        
        let document = cardDatabase.document(id)
        
        document.updateData(["conclusion": conclusion]) { error in
            
            if let error = error {
                
                completion(.failure(error))
            } else {
                
                completion(.success("Success: update conclusion"))
            }
        }
    }
    
    func fetchConclusion(id: String, completion: @escaping (Result<String, Error>) -> Void) {
        
        let document = cardDatabase.document(id)
        
        document.getDocument { (document, error) in
            
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
    
    func updateGrowthCard(id: String, emoji: String, title: String, completion: @escaping (Result<String, Error>) -> Void) {
        
        let document = cardDatabase.document(id)
        
        let updateDict = [
            "emoji": emoji,
            "title": title
        ]
        
        document.updateData(updateDict) { error in
            
            if let error = error {
                
                completion(.failure(error))
            } else {
                
                completion(.success("Success: update growth card"))
            }
        }
    }
    
    func deleteGrowthCardAndRelatedCards(id: String, completion: @escaping (Result<String, Error>) -> Void) {
                    
        let batch = Firestore.firestore().batch()
        
        let growthCardRef = cardDatabase.document(id)
        batch.deleteDocument(growthCardRef)
        
        GrowthContentManager.shared.fetchGrowthContents(id: id) { result in
            
            switch result {
                
            case .success(let cards):
                
                cards.forEach { card in
                    
                    let growthContentCardsRef = self.contentDatabase.document(card.id)
                    
                    batch.deleteDocument(growthContentCardsRef)
                    
                    if !card.image.isEmpty {
                        
                        GrowthContentManager.shared.deleteGrowthContentCardImage(id: card.id) { result in
                            
                            switch result {
                            case .success(let success):
                                
                                print("Content image deleted! \(success)")
                                
                            case .failure(let error):
                                
                                print(error)
                            }
                        }
                    }
                }
                
                batch.commit { err in
                    
                    if let err = err {
                        
                        print("Error deleting cards \(err)")
                        completion(.failure(err))
                        
                    } else {
                        
                        print("Success deleting cards!")
                        completion(.success("Success: cards deleted"))
                        
                    }
                }
                
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
    func archiveGrowthCard(id: String, completion: @escaping (Result<String, Error>) -> Void) {
        
        let document = cardDatabase.document(id)
        
        let updateDict = [
            "is_archived": true,
            "archived_time": Timestamp(date: Date())
        ] as [String: Any]
        
        document.updateData(updateDict) { error in
            
            if let error = error {
                
                completion(.failure(error))
            } else {
                
                completion(.success("Success: archive growth card"))
            }
        }
    }
    
    func unarchiveGrowthCard(id: String, completion: @escaping (Result<String, Error>) -> Void) {
        
        let document = cardDatabase.document(id)
        
        let updateDict = [
            "is_archived": false
        ] as [String: Any]
        
        document.updateData(updateDict) { error in
            
            if let error = error {
                
                completion(.failure(error))
            } else {
                
                completion(.success("Success: unarchive growth card"))
            }
        }
    }
    
}
