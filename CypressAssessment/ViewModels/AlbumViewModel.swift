//
//  AlbumViewModel.swift
//  CypressAssessment
//
//  Created by James Anyanwu on 13/09/2023.
//

import Foundation
import Combine

class AlbumViewModel {

    @Published var sections: [AlbumSection: [CollectionRowItem]] = [:]
    var albums = CurrentValueSubject<[Album], Never>([])
    var images = CurrentValueSubject<[Image], Never>([])
    
    @Published var errorText: String?
    private var cancellable = Set<AnyCancellable>()
    let imageManager = CacheManager<Image>()
    let albumManager = CacheManager<Album>()
    
    func bind() {
        albums.receive(on: RunLoop.main)
            .sink { albums in
                self.parseData()
            }.store(in: &cancellable)
        
        images.receive(on: RunLoop.main)
            .sink { images in
                self.parseData()
            }.store(in: &cancellable)
        images.send(imageManager.getPersistedObjects())
        albums.send(albumManager.getPersistedObjects())
        
    }
    
    func parseData() {
        let items = albums.value.map { album in
            CollectionRowItem(title: album.title,
                              images: images.value.compactMap { $0.albumID == album.id ? $0 : nil })
            
        }
        sections[.main] = items
    }
    func fetchPhotos() {
        NetworkService.shared.fetchData(route: .photos) { [weak self] (result: Result<[Image], NetworkError>) in
            switch result {
            case .success(let success):
                self?.images.send(success)
                self?.persistImage(images: success)
            case .failure(let failure):
                self?.errorText = failure.localizedDescription
            }
        }
    }

    func fetchAlbums() {
        NetworkService.shared.fetchData(route: .albums) { [weak self] (result: Result<[Album], NetworkError>) in
            switch result {
            case .success(let success):
                self?.albums.send(success)
                self?.persistAlbum(albums: success)
            case .failure(let failure):
                self?.errorText = failure.localizedDescription
            }
        }
    }
    
    func persistImage(images: [Image]) {
        for image in images {
            imageManager.persistObject(image)
        }
    }
    
    func persistAlbum(albums: [Album]) {
        for album in albums {
            albumManager.persistObject(album)
        }
    }
}
