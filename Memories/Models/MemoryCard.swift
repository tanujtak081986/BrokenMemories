//
//  MemoryCard.swift
//  Memories
//
//  Created by tanuj tak on 5/10/19.
//  Copyright © 2019 tanujtak. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

@objcMembers
class MemoryCard: Object, Decodable {
    
    dynamic var cardId: String?
    dynamic var title: String = ""
    dynamic var message: String = ""
    dynamic var photoUrl: String?
    dynamic var sequence : String?
    dynamic var hasBeenDisplayed : Bool = false
    dynamic var status : Bool = true
    
    private enum CodingKeys: String, CodingKey {
        case cardId
        case title
        case message
        case photoUrl
        case sequence
        case hasBeenDisplayed
        case status
    }
    
    override static func primaryKey() -> String? {
        return "cardId"
    }
    
    //Required initializers
    required init(from decoder : Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        cardId = try container.decode(String.self, forKey: .cardId)
        title = try container.decode(String.self, forKey: .title)
        message = try container.decode(String.self, forKey: .message)
        photoUrl = try container.decode(String.self, forKey: .photoUrl)
        sequence = try container.decode(String.self, forKey: .sequence)
        hasBeenDisplayed = try container.decode(Bool.self, forKey: .hasBeenDisplayed)
        status = try container.decode(Bool.self, forKey: .status)
        
        super.init()
    }
    
    required init() {
        super.init()
    }
    
    required init(value: Any, schema: RLMSchema) {
        super.init(value: value, schema: schema)
    }
    
    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }
    
}
