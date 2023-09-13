//
//  AlbumViewController.swift
//  CypressAssessment
//
//  Created by James Anyanwu on 12/09/2023.
//

import UIKit
import SnapKit
import Combine

enum AlbumSection: Int, Hashable {
    case main
}

struct CollectionRowItem: Hashable {
    var identifier: String { return AlbumCollectionViewCell.description() }
    var title: String
    var images: [Image]
}

struct GenericCollectionHeaderView {
    let identifier: String
}



class AlbumViewController: UIViewController {
    private typealias DataSource = UICollectionViewDiffableDataSource<AlbumSection, CollectionRowItem>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<AlbumSection, CollectionRowItem>
    
    private lazy var dataSource = makeDataSource()
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout())
    private var cancellables: Set<AnyCancellable> = []
    
    var viewModel: AlbumViewModel
    
    init(viewModel: AlbumViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        viewModel.fetchAlbums()
        viewModel.fetchPhotos()
        viewModel.bind()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupViews() {
        view.addSubview(collectionView)
        
        registerViews()
        setupObservers()
        applySnapshot()
    }
    
    func setupObservers() {
        viewModel.$sections
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] _ in
                self?.applySnapshot()
            })
            .store(in: &cancellables)
    }
    
    private func registerViews() {
        collectionView.register(AlbumCollectionViewCell.self, forCellWithReuseIdentifier: AlbumCollectionViewCell.description())
        collectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SectionHeader")
    }
    
    private func applySnapshot(animatingDifferences: Bool = true) {
        var snapshot = Snapshot()
        let sections = viewModel.sections.sorted(by: { $0.key.rawValue < $1.key.rawValue })
        
        for section in sections {
            snapshot.appendSections([section.key])
            snapshot.appendItems(section.value, toSection: section.key)
        }
        
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
    
    private func makeDataSource() -> DataSource {
        let dataSource = DataSource(
            collectionView: collectionView,
            cellProvider: { (collectionView, indexPath, item) -> UICollectionViewCell? in
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: item.identifier, for: indexPath) as? AlbumCollectionViewCell
                cell?.images = item.images
                cell?.configure(with: item.title)
                return cell
            })
        
        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            guard kind == UICollectionView.elementKindSectionHeader else { return nil }
            let header =  collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SectionHeader", for: indexPath) as? SectionHeader
            header?.title = "Title"
            return header
        }
        
        return dataSource
    }
    
    private func layout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout(sectionProvider: { (sectionIndex, environment) -> NSCollectionLayoutSection? in

            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)

            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(200))
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
  
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 8
            section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)
            
            return section
        })
    }


}

class SectionHeader: UICollectionReusableView {
    var title: String = "" {
        didSet {
            titleLabel.text = title
        }
    }

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.top.bottom.equalToSuperview()
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
