//
//  RealmManager.swift
//  Memories
//
//  Created by tanuj tak on 5/10/19.
//  Copyright © 2019 tanujtak. All rights reserved.
//

import Foundation
import RealmSwift

class RealmManager {
    
    static func objects<T: Object>(_ type: T.Type) -> Results<T>? {
        do{
            let realm = try Realm()
            return  realm.objects(type)
        }
        catch{
            print("Fetch error : \(error.localizedDescription)")
            
        }
        return nil
    }
    
    static func doesObjectExist<T: Object>(id: String, type : T.Type) -> Bool {
        do{
            let realm = try Realm()
            return  realm.object(ofType: type, forPrimaryKey: id) != nil
        }
        catch{
            print("Fetch error : \(error.localizedDescription)")
            
        }
        return false
    }
    
    static func queryForObjects<T: Object>(type: T.Type, query: String) -> Results<T>?{
        do{
            let realm = try Realm()
            return  realm.objects(type).filter(query)
        }
        catch{
            print("Query error : \(error.localizedDescription)")
        }
        return nil
    }
    
    static func deleteObjects<T: Object>(type : T.Type, query: String){
        do{
            let realm = try Realm()
            let objects = realm.objects(type).filter(query)
            try realm.write{
                realm.delete(objects)
            }
        }
        catch{
            print("Delete error : \(error.localizedDescription)")
        }
    }
    
    static func deleteAllObjects<T: Object>(type : T.Type){
        do{
            let realm = try Realm()
            let allObjects = realm.objects(type)
            try realm.write{
                realm.delete(allObjects)
            }
        }
        catch{
            print("Delete error : \(error.localizedDescription)")
        }
    }
}
