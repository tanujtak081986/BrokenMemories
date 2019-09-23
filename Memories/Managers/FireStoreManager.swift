//
//  FireStoreManager.swift
//  Memories
//
//  Created by tanuj tak on 5/13/19.
//  Copyright © 2019 tanujtak. All rights reserved.
//

import Foundation
import Firebase

class FireStoreManager {
   
    private let db = Firestore.firestore()

    func setDataFor(key: String, value: Any, collection: String, document: String) {
        db.collection(collection)
            .document(document)
            .setData([ key: value ], merge: true)
    }
    
    func addSnapshotListnerForDocumentsInCollection(_ collection: String, completion: @escaping (QuerySnapshot?, Error?) -> Void) {
        
        db.collection(collection)
            .addSnapshotListener { querySnapShot, error in
                guard let document = querySnapShot else {
                    print("Error fetching document: \(error!)")
                    completion(nil, error)
                    return
                }
                completion(document, nil)
        }
    }
    
    func addSnapshotListnerForDocumentInCollection(_ collection: String, documentName: String, completion: @escaping (DocumentSnapshot?, Error?) -> Void) {
        
        db.collection(collection)
            .document(documentName)
            .addSnapshotListener { documentSnapshot, error in
                guard let document = documentSnapshot else {
                    print("Error fetching document: \(error!)")
                    completion(nil, error)
                    return
                }
                completion(document, nil)
        }
    }
    
    func fetchDocumentsForCollection(_ collection: String, orderBy:String?, completion: @escaping ([QueryDocumentSnapshot]?, Error?) -> Void) {
        
        let collectionRef = db.collection(collection)
        
        if let orderString = orderBy {
            collectionRef.order(by: orderString, descending: false)
        }
        
        collectionRef
            .getDocuments { (snapshot, error) in
                if let error = error {
                    completion(nil, error)
                } else {
                    completion(snapshot?.documents, nil)
                }
        }
    }
}
