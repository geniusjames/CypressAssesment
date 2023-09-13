//
//  Album.swift
//  CypressAssessment
//
//  Created by James Anyanwu on 13/09/2023.
//

import Foundation
import RealmSwift

struct Album: Codable {
    let id: Int
    let userId: Int
    let title: String
}

extension Album: Persistable {
    static func fromRealmObject(_ object: AlbumRealm) -> Album {
        return Album(id: object.id, userId: object.userId, title: object.title)
    }
    
    func toRealmObject() -> AlbumRealm {
        let realmObject = AlbumRealm()
        realmObject.id = self.id
        realmObject.title = self.title
        realmObject.userId = self.userId
        
        return realmObject
    }
    
    typealias ObjectType = AlbumRealm
    
    
}

class AlbumRealm: Object {
    @Persisted(primaryKey: true) var id: Int
    @Persisted var userId: Int
    @Persisted var title: String

    convenience init(album: Album) {
        self.init()
        self.id = album.id
        self.userId = album.userId
        self.title = album.title
    }
}
