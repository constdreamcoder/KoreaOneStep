//
//  RegionDetailTableViewCell.swift
//  KoreaOneStep
//
//  Created by SUCHAN CHANG on 3/12/24.
//

import UIKit
import SnapKit

final class RegionDetailTableViewCell: UITableViewCell {
    
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
        label.text = ""
        label.textAlignment = .center
        label.textColor = .customBlack
        label.font = .systemFont(ofSize: 20.0, weight: .bold)
        label.numberOfLines = 2
        return label
    }()
    
    let regionDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .customBlack
        label.font = .systemFont(ofSize: 14.0)
        label.numberOfLines = 0
        return label
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

extension RegionDetailTableViewCell: UITableViewCellConfiguration {
    func configureConstraints() {
        [
            regionImageView,
            regionNameLabel,
            regionDescriptionLabel
        ].forEach { contentView.addSubview($0) }
        
        regionImageView.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide)
            $0.height.equalTo(200)
        }
        
        regionNameLabel.snp.makeConstraints {
            $0.top.equalTo(regionImageView.snp.bottom).offset(16.0)
            $0.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide).inset(16.0)
        }
        
        regionDescriptionLabel.snp.makeConstraints {
            $0.top.equalTo(regionNameLabel.snp.bottom).offset(16.0)
            $0.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide).inset(16.0)
            $0.bottom.equalTo(contentView.safeAreaLayoutGuide).inset(16.0)
        }
    }
    
    func configureUI() {
        
    }
}
