//
//  SearchTableViewCell.swift
//  KoreaOneStep
//
//  Created by SUCHAN CHANG on 3/10/24.
//

import UIKit
import SnapKit

final class SearchTableViewCell: UITableViewCell {
    
    let magnifyingglassImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "magnifyingglass")
        imageView.tintColor = .customBlack
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let keywordLabel: UILabel = {
        let label = UILabel()
        label.text = "크리스탈 팰리스"
        label.textColor = .customBlack
        label.font = .boldSystemFont(ofSize: 18.0)
        return label
    }()
    
    let xmarkButton: UIButton = {
        let button = UIButton()
        let buttonImage = UIImage(systemName: "xmark")?.withTintColor(.customBlack, renderingMode: .alwaysOriginal)
        button.setImage(buttonImage, for: .normal)
        return button
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureConstraints()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SearchTableViewCell: UITableViewCellConfiguration {
    func configureConstraints() {
        [
            magnifyingglassImageView,
            keywordLabel,
            xmarkButton
        ].forEach { contentView.addSubview($0) }
        
        magnifyingglassImageView.snp.makeConstraints {
            $0.size.equalTo(24.0)
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(16.0)
        }
        
        keywordLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(magnifyingglassImageView.snp.trailing).offset(16.0)
            $0.trailing.equalTo(xmarkButton.snp.leading).offset(-8.0)
        }
        
        xmarkButton.snp.makeConstraints {
            $0.size.equalTo(24.0)
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(16.0)
        }
        
    }
    
    func configureUI() {
        
    }
}


