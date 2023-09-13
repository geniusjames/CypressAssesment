//
//  CacheManager.swift
//  CypressAssessment
//
//  Created by James Anyanwu on 13/09/2023.
//

import Foundation
import RealmSwift

protocol Persistable {
    associatedtype ObjectType: Object
    static func fromRealmObject(_ object: ObjectType) -> Self
    func toRealmObject() -> ObjectType
}


class CacheManager<T: Codable & Persistable> {

    private func createRealmInstance() -> Realm {
        do {
            return try Realm()
        } catch {
            fatalError("Failed to create Realm instance: \(error)")
        }
    }

    func persistObject(_ object: T) {
        let realm = createRealmInstance()
        let persistedObject = object.toRealmObject()
        do {
            try realm.write {
                realm.add(persistedObject, update: .modified)
            }
        } catch {
            fatalError("Failed to persist object to Realm: \(error)")
        }
    }

    func getPersistedObjects() -> [T] {
        let realm = createRealmInstance()
        let persistedObjects = realm.objects(T.ObjectType.self)
        return persistedObjects.map { T.fromRealmObject($0) }
    }
}
