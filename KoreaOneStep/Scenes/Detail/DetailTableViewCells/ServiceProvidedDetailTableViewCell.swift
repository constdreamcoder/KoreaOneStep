//
//  ServiceProvidedDetailTableViewCell.swift
//  KoreaOneStep
//
//  Created by SUCHAN CHANG on 3/12/24.
//

import UIKit
import SnapKit

final class ServiceProvidedDetailTableViewCell: UITableViewCell {
    
    let serviceTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "안녕"
        label.textColor = .customBlack
        label.font = .systemFont(ofSize: 18.0, weight: .bold)
        return label
    }()
    
    let chevronImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.down")
        imageView.tintColor = .customBlack
        imageView.contentMode = .scaleAspectFit
        return imageView
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

extension ServiceProvidedDetailTableViewCell: UITableViewCellConfiguration {
    func configureConstraints() {
       [
            serviceTitleLabel,
            chevronImageView
       ].forEach { contentView.addSubview($0) }
        
        serviceTitleLabel.snp.makeConstraints {
            $0.top.leading.equalTo(contentView.safeAreaLayoutGuide).offset(16.0)
            $0.bottom.equalTo(contentView.safeAreaLayoutGuide).inset(16.0)
        }
        
        chevronImageView.snp.makeConstraints {
            $0.centerY.equalTo(serviceTitleLabel)
            $0.trailing.equalTo(contentView.safeAreaLayoutGuide).inset(16.0)
            $0.width.equalTo(19.0)
            $0.height.equalTo(22.0)
        }
    }
    
    func configureUI() {
        
    }
}
