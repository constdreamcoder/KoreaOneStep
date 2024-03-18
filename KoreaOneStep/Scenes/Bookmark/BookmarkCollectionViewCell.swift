//
//  BookmarkSecondSectionTableViewCellCollectionViewCell.swift
//  KoreaOneStep
//
//  Created by SUCHAN CHANG on 3/11/24.
//

import UIKit
import SnapKit

final class BookmarkCollectionViewCell: UICollectionViewCell {
    
    let thumnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo")
        imageView.contentMode = .scaleToFill
        imageView.tintColor = .customDarkGray
        imageView.backgroundColor = .lightGray
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "우가우가 한식당 한식당"
        label.textColor = .customWhite
        label.font = .systemFont(ofSize: 20.0, weight: .bold)
        label.numberOfLines = 2
        return label
    }()
    
    let bookmarkIconButton: UIButton = {
        let button = UIButton()
        let buttonImage = UIImage(systemName: "bookmark.fill")?.withTintColor(.customWhite, renderingMode: .alwaysOriginal)
        button.setImage(buttonImage, for: .normal)
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 28)
        button.setPreferredSymbolConfiguration(symbolConfig, forImageIn: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureConstraints()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = 16.0
        clipsToBounds = true
    }
}

extension BookmarkCollectionViewCell: UICollectionViewCellConfiguration {
    func configureConstraints() {
        [
            thumnailImageView,
            nameLabel,
            bookmarkIconButton,
        ].forEach { contentView.addSubview($0) }
        
        thumnailImageView.snp.makeConstraints {
            $0.edges.equalTo(contentView.safeAreaLayoutGuide)
        }
        
        nameLabel.snp.makeConstraints {
            $0.horizontalEdges.bottom.equalTo(contentView.safeAreaLayoutGuide).inset(16.0)
        }
        
        bookmarkIconButton.snp.makeConstraints {
            $0.top.trailing.equalTo(contentView.safeAreaLayoutGuide).inset(16.0)
        }
    }
    
    func configureUI() {
        
    }
}
