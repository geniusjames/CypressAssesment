//
//  ImageCell.swift
//  CypressAssessment
//
//  Created by James Anyanwu on 12/09/2023.
//

import UIKit

class ImageCell: UICollectionViewCell {

    private let photoView = UIImageView()
    var image: Image?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(photoView)
        photoView.layer.cornerRadius = 3
        photoView.snp.makeConstraints { $0.edges.equalToSuperview() }

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(with image: Image) {
        ImageCacheManager.shared.getCachedImage(imageURL: image.thumbnailURL) { [weak self] image in
                self?.photoView.image = image
            }
    }
}
