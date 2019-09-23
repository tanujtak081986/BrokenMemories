//
//  LandingViewModel.swift
//  Memories
//
//  Created by tanuj tak on 5/10/19.
//  Copyright © 2019 tanujtak. All rights reserved.
//

import Foundation
import CodableFirebase
import Firebase

class LandingViewModel {
    
    var memoryCards: [MemoryCard] = []
    private let notificationManager : NotificationManager = NotificationManager()
    private lazy var firestoreManager = FireStoreManager()
    
    var shouldRefreshViewOnDataReset: (() -> ())?
    
    //Loads card from the list for the sequence number passed.
    func loadCardForSequence(_ sequence: String = "0") {
        memoryCards.removeAll()
        if let obj = RealmManager.objects(MemoryCard.self)?.filter("sequence = %@ AND hasBeenDisplayed = %@ AND status = %@", sequence, false, true).first {
            memoryCards.append(obj)
        } else {
            guard let totalCount = RealmManager.objects(MemoryCard.self)?.count else {
                return
            }
            //recursive card fetch until no more cards are left
            if let currentSeq = Int(sequence), currentSeq <= totalCount {
                loadCardForSequence("\(currentSeq+1)")
            }
        }
    }
    
    //downloads the cards from the collection in firebase db.
    func downloadCards(completion: @escaping () -> Void) {
        firestoreManager.fetchDocumentsForCollection("MemoriesDemo", orderBy: "sequence") { (documents, error) in
            
            guard error == nil else {
                return
            }
            
            documents?.forEach({ document in
                let model = try! FirestoreDecoder().decode(MemoryCard.self, from: document.data())
                model.add()
            })
            completion()
        }
    }
    
    func didDisplayCard(_ card: MemoryCard) {
        card.update {
            card.hasBeenDisplayed = true
        }
    }
}

extension LandingViewModel {
    //Handle for the local notification trigger for the timeinterval set in the firebase database config collection.
    func setListnerForLocalNotificationTrigger() {
        firestoreManager
            .addSnapshotListnerForDocumentInCollection(
                "Config",
                documentName: "localNotification") { (documentSnapshot, error) in
                    guard let document = documentSnapshot else {
                        print("Error fetching document: \(error!)")
                        //default notification trigger
                        self.setDefaultNotificationTrigger()
                        return
                    }
                    guard let data = document.data() else {
                        print("Document data was empty.")
                        //default notification trigger
                        self.setDefaultNotificationTrigger()
                        return
                    }
                    
                    //check for reset flag
                    if let resetFlag = data["reset"] as? Bool, resetFlag == true {
                        self.firestoreManager.setDataFor(key: "reset", value: false, collection: "Config", document: "localNotification")
                        self.resetData()
                        self.shouldRefreshViewOnDataReset?()
                    }
                    
                    if let component = data["component"] as? String, let intervalStr = data["interval"] as? String, let interval = Int(intervalStr) {
                        if let timeintervalForDate = data["startDate"] as? Timestamp, timeintervalForDate.dateValue() > Date() {
                            self.notificationManager.addNotificationTriggerFromNowFor(component: component, interval: interval, fireDate: timeintervalForDate.dateValue())
                        } else {
                            self.notificationManager.addNotificationTriggerFromNowFor(component: component, interval: interval, fireDate: nil)
                        }
                    } else {
                        //default notification trigger
                        self.setDefaultNotificationTrigger()
                    }
        }
    }
    
    private func setDefaultNotificationTrigger() {
        notificationManager.addNotificationTriggerFromNowFor(component: "hour", interval: 1, fireDate: nil)
    }
    
    func resetData() {
        notificationManager.removeAllPendingNotifications()
        UserDefaults.standard.removeObject(forKey: AppStrings.Keys.sequence)
    }
}
