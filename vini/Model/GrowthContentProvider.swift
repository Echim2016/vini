//
//  GrowthContentProvider.swift
//  vini
//
//  Created by Yi-Chin Hsu on 2021/10/19.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift
import FirebaseStorage

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
    
    func uploadImage(imageView: UIImageView, completion: @escaping (_ url: String) -> Void) {
        
        let storageRef = Storage.storage().reference().child("\(Date().timeIntervalSince1970).jpg")
        
        if let uploadData = imageView.image?.jpegData(compressionQuality: 0.5) {
            
            storageRef.putData(uploadData, metadata: nil) { (metadata, error) in
                
                guard let metadata = metadata else {
                    completion("")
                    return
                    
                }
                
                storageRef.downloadURL(completion: { (url, error) in
                    
                    guard let downloadURL = url else {
                        completion("")
                        return
                    }
                    print(downloadURL)
                    completion(downloadURL.absoluteString)
                })
                
            }
        } else {
            completion("")
        }
    }
    
    func addGrowthContents(id: String, title: String, content: String, imageView: UIImageView, completion: @escaping (Result<String, Error>) -> Void) {
        
        uploadImage(imageView: imageView) { url in
            
            let document = self.db.collection("Growth_Contents").document()
            
            let growthContent = GrowthContent(
                id: document.documentID,
                growthCardId: self.db.collection("Growth_Cards").document(id),
                title: title,
                content: content,
                image: url,
                createdTime: Timestamp(date: Date())
            )
            
            document.setData(growthContent.toDict) { error in
                
                if let error = error {
                    
                    completion(.failure(error))
                } else {
                    
                    completion(.success("Success"))
                }
            }
        }
        
    }
    
    func deleteGrowthContentCard(id: String, completion: @escaping (Result<String, Error>) -> Void) {
        
        db.collection("Growth_Contents").document(id).delete() { err in
            
            if let err = err {
                print("Error removing growth content card: \(err)")
                completion(.failure(err))
            } else {
                print("Growth content card successfully removed!")
                completion(.success("Success"))
            }
        }
    }
    
}
    
