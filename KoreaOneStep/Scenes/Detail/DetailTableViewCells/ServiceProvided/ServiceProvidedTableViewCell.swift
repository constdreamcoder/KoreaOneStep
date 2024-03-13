//
//  ServiceProvidedTableViewCell.swift
//  KoreaOneStep
//
//  Created by SUCHAN CHANG on 3/12/24.
//

import UIKit
import SnapKit

protocol ServiceProvidedTableViewCellDelegate: AnyObject {
    func transferSelectedService(selectedService: DetailTableViewSection.ServiceDetailSection)
}

final class ServiceProvidedTableViewCell: UITableViewCell {
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: configureCollectionViewLayout())
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(ServiceProvidedInternalCollectionViewCell.self, forCellWithReuseIdentifier: ServiceProvidedInternalCollectionViewCell.identifier)
        
        return collectionView
    }()
    
    weak var delegate: ServiceProvidedTableViewCellDelegate?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureConstraints()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ServiceProvidedTableViewCell: UITableViewCellConfiguration {
    func configureConstraints() {
        contentView.addSubview(collectionView)
        
        collectionView.snp.makeConstraints {
            $0.edges.equalTo(contentView.safeAreaLayoutGuide)
        }
    }
    
    func configureUI() {
        
    }
}

extension ServiceProvidedTableViewCell: UICollectionViewConfiguration {
    func configureCollectionViewLayout() -> UICollectionViewFlowLayout {
        let spacing: CGFloat = 16
        
        let layout = UICollectionViewFlowLayout()
        let itemSize = UIScreen.main.bounds.width - (spacing * 6)
        layout.itemSize = CGSize(width: itemSize / 5, height: (itemSize / 5))
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        layout.sectionInset = UIEdgeInsets(top: 8, left: spacing, bottom: 0, right: spacing)
        
        return layout
    }
}

extension ServiceProvidedTableViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedService = DetailTableViewSection.ServiceDetailSection.allCases[indexPath.item]
        
        delegate?.transferSelectedService(selectedService: selectedService)
    }
}

extension ServiceProvidedTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return DetailTableViewSection.ServiceDetailSection.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ServiceProvidedInternalCollectionViewCell.identifier, for: indexPath) as? ServiceProvidedInternalCollectionViewCell else { return UICollectionViewCell() }
        let service = DetailTableViewSection.ServiceDetailSection.allCases[indexPath.item]
        cell.serviceImageView.image = service.serviceImage
        return cell
    }
}
