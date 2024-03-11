//
//  BookmarkHeaderViewCell.swift
//  KoreaOneStep
//
//  Created by SUCHAN CHANG on 3/11/24.
//

import UIKit
import SnapKit

final class BookmarkHeaderViewCell: UICollectionViewCell {
    
    let regionImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo")
        imageView.tintColor = .black
        imageView.contentMode = .scaleToFill
        imageView.backgroundColor = .brown
        
        return imageView
    }()
    
    let regionLabel: UILabel = {
        let label = UILabel()
        label.text = "서울"
        label.textAlignment = .center
        label.textColor = .customDarkGray
        label.font = .systemFont(ofSize: 18.0, weight: .semibold)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureConstraints()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        regionImageView.clipsToBounds = true
        regionImageView.layer.cornerRadius = regionImageView.frame.height / 2
    }
}

extension BookmarkHeaderViewCell: UICollectionViewCellConfiguration {
    func configureConstraints() {
        [
            regionImageView,
            regionLabel
        ].forEach { contentView.addSubview($0) }
        
        regionImageView.snp.makeConstraints {
            $0.size.equalTo(80.0)
            $0.centerX.equalTo(contentView.safeAreaLayoutGuide)
        }
        
        regionLabel.snp.makeConstraints {
            $0.top.equalTo(regionImageView.snp.bottom).offset(8.0)
            $0.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide)
        }
    }
    
    func configureUI() {
        
    }
}
