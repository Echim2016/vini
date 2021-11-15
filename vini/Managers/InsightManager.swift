//
//  InsightManager.swift
//  vini
//
//  Created by Yi-Chin Hsu on 2021/11/2.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

class InsightManager {
    
    static let shared = InsightManager()
    
    lazy var db = Firestore.firestore()
    
    func fetchInsights(completion: @escaping (Result<[InsightTitle : String], Error>) -> Void) {
        
        if let userID = UserManager.shared.userID {
            
            let group = DispatchGroup()
            var insightDict: [InsightTitle : String] = [:]
            
            group.enter()
            fetchNumberOfGrowthContentCards(userID: userID) { result in
                switch result {
                    
                case .success(let number):
                    insightDict[.totalGrowthContentCards] = number
                    group.leave()
                case.failure(let error):
                    print(error)
                    group.leave()
                }
            }
            
            group.enter()
            fetchNumberOfArchivedGrowthCards(userID: userID) { result in
                switch result {
                    
                case .success(let number):
                    insightDict[.totalArchivedCards] = number
                    group.leave()
                case.failure(let error):
                    print(error)
                    group.leave()
                }
            }
            
            group.enter()
            fetchNumberOfAllGrowthCards { result in
                switch result {
                    
                case .success(let number):
                    insightDict[.totalCardsInApp] = number + "+"
                    group.leave()
                case.failure(let error):
                    print(error)
                    group.leave()
                }
            }
            
            group.enter()
            fetchCurrentStreak(userID: userID) { result in
                switch result {
                    
                case .success(let streak):
                    insightDict[.currentStreak] = streak
                    group.leave()
                case.failure(let error):
                    print(error)
                    group.leave()
                }
            }
            
            group.notify(queue: DispatchQueue.main) {
                
                completion(.success(insightDict))
            }
        }
        
        
    }
    
    func fetchNumberOfGrowthContentCards(userID: String, completion: @escaping (Result<String, Error>) -> Void) {
        
        db.collection("Growth_Contents").whereField("user_id", isEqualTo: userID).getDocuments { (querySnapshot, err) in

            if let err = err {
                print("Error getting growth content cards: \(err)")
                completion(.failure(err))
            } else {
                if let count = querySnapshot?.count {
                    
                    completion(.success("\(count)"))
                }
            }
        }
    }
    
    func fetchNumberOfArchivedGrowthCards(userID: String, completion: @escaping (Result<String, Error>) -> Void) {
        
        db.collection("Growth_Cards").whereField("user_id", isEqualTo: userID).whereField("is_archived", isEqualTo: true).getDocuments { (querySnapshot, err) in

            if let err = err {
                print("Error getting growth cards: \(err)")
                completion(.failure(err))
            } else {
                if let count = querySnapshot?.count {
                    
                    completion(.success("\(count)"))
                }
            }
        }
    }
    
    func fetchNumberOfAllGrowthCards(completion: @escaping (Result<String, Error>) -> Void) {
        
        db.collection("Growth_Cards").getDocuments { (querySnapshot, err) in

            if let err = err {
                print("Error getting growth cards: \(err)")
                completion(.failure(err))
            } else {
                if let count = querySnapshot?.count {
                    
                    completion(.success("\(count)"))
                }
            }
        }
    }
    
    func fetchCurrentStreak(userID: String, completion: @escaping (Result<String, Error>) -> Void) {
        
        db.collection("Growth_Contents").whereField("user_id", isEqualTo: userID).order(by: "created_time", descending: true).getDocuments { (querySnapshot, err) in

            if let err = err {
                print("Error getting growth cards: \(err)")
                completion(.failure(err))
            } else {
                
                if let querySnapshot = querySnapshot {
                    
                    var currentDate = Date()
                    var currentStreak = 0
                    
                    for document in querySnapshot.documents {

                        guard let createdTime = document.get("created_time") as? Timestamp else {

                            break
                        }

                        let createdDate = createdTime.toDate()

                        if createdDate.getDayDistance(to: currentDate) <= 1 {

                            currentDate = createdTime.toDate()
                            currentStreak += 1

                        } else {
                            
                            break
                        }
                    }
                    
                    completion(.success("\(currentStreak)"))
                }
            }
        }
    }
}
