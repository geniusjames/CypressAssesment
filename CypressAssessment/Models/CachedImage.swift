//
//  CachedImage.swift
//  CypressAssessment
//
//  Created by James Anyanwu on 13/09/2023.
//

import Foundation
import RealmSwift

class CachedImage: Object {
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var imageURL = ""
    @objc dynamic var imageData = Data()
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
