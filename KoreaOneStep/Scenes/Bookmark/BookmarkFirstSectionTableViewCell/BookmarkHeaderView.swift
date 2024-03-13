//
//  BookmarkHeaderView.swift
//  KoreaOneStep
//
//  Created by SUCHAN CHANG on 3/11/24.
//

import UIKit
import SnapKit

final class BookmarkHeaderView: UICollectionReusableView {
    
    let headerLabel: UILabel = {
        let label = UILabel()
        label.text = "지역 카테고리"
        label.textColor = .customBlack
        label.font = .systemFont(ofSize: 24.0, weight: .bold)
        return label
    }()
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: configureCollectionViewLayout())
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(BookmarkHeaderViewCell.self, forCellWithReuseIdentifier: BookmarkHeaderViewCell.identifier)
        
        collectionView.showsHorizontalScrollIndicator = false
        
        return collectionView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureConstraints()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension BookmarkHeaderView: UICollectionViewCellConfiguration {
    func configureConstraints() {
        [
            headerLabel,
            collectionView
        ].forEach { addSubview($0) }
        
        headerLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(8.0)
            $0.horizontalEdges.equalToSuperview().inset(16.0)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(headerLabel.snp.bottom).offset(8.0)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
    }
    
    func configureUI() {
        
    }
}

extension BookmarkHeaderView: UICollectionViewConfiguration {
    func configureCollectionViewLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 100, height: 140)
        layout.minimumLineSpacing = 12
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        layout.scrollDirection = .horizontal
        
        return layout
    }
}

extension BookmarkHeaderView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.item)
    }
}

extension BookmarkHeaderView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BookmarkHeaderViewCell.identifier, for: indexPath) as? BookmarkHeaderViewCell else { return UICollectionViewCell() }
        
        return cell
    }
}
