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
    
    func uploadImage(imageView: UIImageView, id: String, completion: @escaping (_ url: String) -> Void) {
        
        let storageRef = Storage.storage().reference().child("\(id).jpg")
        
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
                    
                    completion(downloadURL.absoluteString)
                })
                
            }
        } else {
            completion("")
        }
    }
    
    func addGrowthContents(id: String, title: String, content: String, imageView: UIImageView, completion: @escaping (Result<String, Error>) -> Void) {
        
        let document = self.db.collection("Growth_Contents").document()
        
        uploadImage(imageView: imageView, id: document.documentID) { url in
            
            let growthContent = GrowthContent(
                id: document.documentID,
                growthCardId: self.db.collection("Growth_Cards").document(id),
                title: title,
                content: content,
                image: url,
                createdTime: Timestamp(date: Date())
            )
            
            do {
                
                try document.setData(from: growthContent) { error in
                    
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
        
    }
    
    func updateGrowthContents(contentID: String, title: String, content: String, imageView: UIImageView? = nil, completion: @escaping (Result<String, Error>) -> Void) {
        
        let document = self.db.collection("Growth_Contents").document(contentID)
        
        var updateDict = [
            "title": title,
            "content": content
        ]
        
        if let imageView = imageView {
            
            uploadImage(imageView: imageView, id: document.documentID) { url in
                
                updateDict["image"] = url
                
                document.updateData(updateDict) { error in
                    
                    if let error = error {
                        
                        completion(.failure(error))
                    } else {
                        
                        completion(.success("Success"))
                    }
                }
            }
        } else {
            
            document.updateData(updateDict) { error in
                
                if let error = error {
                    
                    completion(.failure(error))
                } else {
                    
                    completion(.success("Success"))
                }
            }
        }
    }
    
    func deleteGrowthContentCard(id: String, imageExists: Bool, completion: @escaping (Result<String, Error>) -> Void) {
        
        db.collection("Growth_Contents").document(id).delete() { err in
            
            if let err = err {
                print("Error removing growth content card: \(err)")
                completion(.failure(err))
            } else {
                print("Growth content card successfully removed!")
                
                if imageExists {
                    
                    self.deleteGrowthContentCardImage(id: id) { result in
                        
                        switch result {
                        case .success(let success):
                            completion(.success(success))
                        case .failure(let error):
                            completion(.failure(error))
                        }
                    }
                } else {
                    
                    completion(.success("Success"))
                }
                
            }
        }
    }
    
    func deleteGrowthContentCardImage(id: String, completion: @escaping (Result<String, Error>) -> Void) {
        
        let ref = Storage.storage().reference().child("\(id).jpg")

        ref.delete { error in
          if let error = error {
              print("Error removing growth content card image: \(error)")
              completion(.failure(error))
          } else {
              print("Growth content card image successfully removed!")
              completion(.success("Success"))
          }
        }
    }
    
}
    
