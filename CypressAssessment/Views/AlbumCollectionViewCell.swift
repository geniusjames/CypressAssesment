//
//  AlbumCollectionViewCell.swift
//  CypressAssessment
//
//  Created by James Anyanwu on 12/09/2023.
//

import UIKit

class AlbumCollectionViewCell: UICollectionViewCell {
    private var collectionView: UICollectionView!
    private var albumTitleLabel = UILabel()
    
    private var dataSource: UICollectionViewDiffableDataSource<Int, Image>!
    private var albumName: String = ""
    var images = [Image]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCollectionView()
        configureDataSource()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with albumName: String) {
        self.albumName = albumName
        albumTitleLabel.text = albumName
        applyInitialSnapshot()
    }
    
    private func configureCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 150, height: 150)
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)

        collectionView.register(ImageCell.self, forCellWithReuseIdentifier: "ImageCell")
        contentView.addSubview(collectionView)
        contentView.addSubview(albumTitleLabel)
        
        albumTitleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(20)
        }
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(albumTitleLabel.snp.bottom).offset(20)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Int, Image>(collectionView: collectionView) { collectionView, indexPath, image in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCell
            cell.setup(with: image)
            return cell
        }
    }
    
    private func applyInitialSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Image>()
        let photos = images.map { $0 }
        snapshot.appendSections([0])
        snapshot.appendItems(photos)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

