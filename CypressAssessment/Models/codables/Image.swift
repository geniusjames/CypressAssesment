//
//  Image.swift
//  CypressAssessment
//
//  Created by James Anyanwu on 13/09/2023.
//

import Foundation
import RealmSwift

struct Image: Codable {
    let albumID, id: Int
    let title: String
    let url, thumbnailURL: String

    enum CodingKeys: String, CodingKey {
        case albumID = "albumId"
        case id, title, url
        case thumbnailURL = "thumbnailUrl"
    }
}

extension Image: Hashable {
    
}

extension Image: Persistable {
    static func fromRealmObject(_ object: ImageRealm) -> Image {
        return Image(albumID: object.albumID, id: object.id, title: object.title, url: object.url, thumbnailURL: object.thumbnailURL)
    }
    
    func toRealmObject() -> ImageRealm {
        let realmObject = ImageRealm()
        realmObject.albumID = self.albumID
        realmObject.title = self.title
        realmObject.url = self.url
        realmObject.thumbnailURL = self.thumbnailURL
        realmObject.id = self.id
        return realmObject
    }
    
    typealias ObjectType = ImageRealm
    
    
}

class ImageRealm: Object {
    @Persisted(primaryKey: true) var id: Int
    @Persisted var albumID: Int
    @Persisted var title: String
    @Persisted var url: String
    @Persisted var thumbnailURL: String

    convenience init(image: Image) {
        self.init()
        self.id = image.id
        self.albumID = image.albumID
        self.title = image.title
        self.url = image.url
        self.thumbnailURL = image.thumbnailURL
    }
}
