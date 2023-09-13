//
//  ImageCacheManager.swift
//  CypressAssessment
//
//  Created by James Anyanwu on 13/09/2023.
//
import RealmSwift
import UIKit

class ImageCacheManager {

    static let shared = ImageCacheManager()
    
    private init() {}

    func getCachedImage(imageURL: String, completion: @escaping (UIImage?) -> Void) {

        if let cachedImage = getCachedImageFromCache(imageURL: imageURL) {
            completion(cachedImage)
        } else {
            fetchAndCacheImage(imageURL: imageURL, completion: completion)
        }
    }

    private func getCachedImageFromCache(imageURL: String) -> UIImage? {
        let realm = try! Realm()
        if let cachedImage = realm.objects(CachedImage.self).filter("imageURL == %@", imageURL).first,
           let uiImage = UIImage(data: cachedImage.imageData) {
            return uiImage
        }
        return nil
    }

    private func fetchAndCacheImage(imageURL: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: imageURL) else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let data = data, let uiImage = UIImage(data: data) {
                self.cacheImage(imageURL: imageURL, imageData: data)
                DispatchQueue.main.async {
                    completion(uiImage)
                }
            } else {
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }.resume()
    }

    private func cacheImage(imageURL: String, imageData: Data) {
        let cachedImage = CachedImage()
        cachedImage.imageURL = imageURL
        cachedImage.imageData = imageData
        
        DispatchQueue(label: "ImageCacheQueue").async {
            let realm = try! Realm()
            try! realm.write {
                realm.add(cachedImage, update: .modified)
            }
        }
    }
}
