//
//  SearchResultListTableViewCell.swift
//  KoreaOneStep
//
//  Created by SUCHAN CHANG on 3/13/24.
//

import UIKit
import SnapKit

final class SearchResultListTableViewCell: UITableViewCell {
    
    let regionImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo")
        imageView.contentMode = .scaleToFill
        imageView.tintColor = .customDarkGray
        imageView.backgroundColor = .lightGray
        return imageView
    }()
    
    let regionNameLabel: UILabel = {
        let label = UILabel()
        label.text = "우가우가 한식당"
        label.textColor = .customBlack
        label.font = .systemFont(ofSize: 20.0, weight: .bold)
        return label
    }()
    
    let bookmarkIconButton: UIButton = {
        let button = UIButton()
        let buttonImage = UIImage(systemName: "bookmark")?.withTintColor(.systemGreen, renderingMode: .alwaysOriginal)
        button.setImage(buttonImage, for: .normal)
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 20)
        button.setPreferredSymbolConfiguration(symbolConfig, forImageIn: .normal)
        return button
    }()
    
    let distanceLabel: UILabel = {
        let label = UILabel()
        // TODO: - 거리에 따른 다른 단위 보여주기
        // 예) 1000m 이상일 때는 ~km로 단위 변경하여 표시
        label.text = "997m"
        label.textColor = .customOrange
        label.font = .systemFont(ofSize: 16.0, weight: .semibold)
        return label
    }()
    
    let telephoneNumberLabel: UILabel = {
        let label = UILabel()
        label.text = "02-752-1945"
        label.textColor = .customBlack
        label.font = .systemFont(ofSize: 16.0, weight: .semibold)
        return label
    }()
    
    lazy var isBookmarked: Bool = false {
        didSet {
            if isBookmarked {
                let buttonImage = UIImage(systemName: "bookmark.fill")?.withTintColor(.systemGreen, renderingMode: .alwaysOriginal)
                bookmarkIconButton.setImage(buttonImage, for: .normal)
            } else {
                let buttonImage = UIImage(systemName: "bookmark")?.withTintColor(.systemGreen, renderingMode: .alwaysOriginal)
                bookmarkIconButton.setImage(buttonImage, for: .normal)
            }
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureConstraints()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SearchResultListTableViewCell: UITableViewCellConfiguration {
    func configureConstraints() {
        [
            regionImageView,
            regionNameLabel,
            bookmarkIconButton,
            distanceLabel,
            telephoneNumberLabel
        ].forEach { contentView.addSubview($0) }
        
        regionImageView.snp.makeConstraints {
            $0.top.equalTo(contentView.safeAreaLayoutGuide).offset(16.0)
            $0.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide).inset(16.0)
            $0.height.equalTo(200.0)
        }
        
        regionNameLabel.snp.makeConstraints {
            $0.leading.equalTo(regionImageView)
            $0.top.equalTo(regionImageView.snp.bottom).offset(12.0)
        }
        
        distanceLabel.snp.makeConstraints {
            $0.leading.equalTo(regionNameLabel)
            $0.top.equalTo(regionNameLabel.snp.bottom).offset(10.0)
            $0.bottom.equalTo(contentView.safeAreaLayoutGuide)
        }
        
        bookmarkIconButton.snp.makeConstraints {
            $0.leading.equalTo(regionNameLabel.snp.trailing).offset(8.0)
            $0.centerY.equalTo(regionNameLabel)
            $0.trailing.equalTo(regionImageView)
        }
        bookmarkIconButton.setContentCompressionResistancePriority(.required, for: .horizontal)
        bookmarkIconButton.setContentHuggingPriority(.required, for: .horizontal)
        
        telephoneNumberLabel.snp.makeConstraints {
            $0.centerY.equalTo(distanceLabel)
            $0.trailing.equalTo(bookmarkIconButton)
        }
        
    }
    
    func configureUI() {
        backgroundColor = .customWhite
        contentView.backgroundColor = .customWhite
    }
}
