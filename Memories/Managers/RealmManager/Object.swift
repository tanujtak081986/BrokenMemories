//
//  Object.swift
//  Memories
//
//  Created by tanuj tak on 5/10/19.
//  Copyright © 2019 tanujtak. All rights reserved.
//

import Foundation
import RealmSwift

extension Object {
    func add() {
        do{
            let realm = try Realm()
            try realm.write {
                realm.add(self, update: true)
            }
        }
        catch{
            print("Save error : \(error.localizedDescription)")
        }
    }
    
    func update(_ updateBlock: () -> ()) {
        do{
            let realm = try Realm()
            try realm.write(updateBlock)
        }
        catch{
            print("Update error : \(error.localizedDescription)")
        }
    }
    
    func delete() {
        do{
            let realm = try Realm()
            try realm.write {
                realm.delete(self)
            }
        }
        catch{
            print("Delete error : \(error.localizedDescription)")
        }
    }
}


extension List {
    
    func toArray<T>(ofType: T.Type) -> [T] {
        var array = [T]()
        for result in self {
            if let result = result as? T {
                array.append(result)
            }
        }
        return array
    }
}

extension Results {
    
    func toArray1<T>(ofType: T.Type, query: String = "") -> [T] {
        var array = [T]()
        for result in self.filter(query) {
            if let result = result as? T {
                array.append(result)
            }
        }
        return array
    }
    
    func toArray<T>(ofType: T.Type) -> [T] {
        var array = [T]()
        for result in self {
            if let result = result as? T {
                array.append(result)
            }
        }
        return array
    }
}

class IntObject: Object {
    @objc dynamic var value = 0
}

class StringObject: Object {
    @objc dynamic var value = ""
}

extension String {
    func toStringObject() -> StringObject {
        return StringObject(value: self)
    }
}

extension Sequence where Iterator.Element == String {
    func toStringObjects() -> List<StringObject> {
        let list = List<StringObject>()
        for s in self {
            list.append(s.toStringObject())
        }
        return list
    }
}

extension Int {
    func toIntObject() -> IntObject {
        return IntObject(value: self)
    }
}

extension Sequence where Iterator.Element == Int {
    func toIntObjects() -> List<IntObject> {
        let list = List<IntObject>()
        for s in self {
            list.append(s.toIntObject())
        }
        return list
    }
}
