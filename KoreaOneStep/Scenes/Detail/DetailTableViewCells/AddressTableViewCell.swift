//
//  AddressTableViewCell.swift
//  KoreaOneStep
//
//  Created by SUCHAN CHANG on 3/12/24.
//

import UIKit
import SnapKit

final class AddressTableViewCell: UITableViewCell {

    private let mapIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "map")
        imageView.tintColor = .customBlack
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "주소"
        label.textColor = .customBlack
        label.font = .systemFont(ofSize: 18.0, weight: .bold)
        return label
    }()
    
    let addressLabel: UILabel = {
        let label = UILabel()
        label.text = "전북특별자치도 부안군 변산면 조각공원길 31"
        label.textColor = .customBlack
        label.font = .systemFont(ofSize: 16.0)
        return label
    }()
    
    private let chevronRightIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.right")
        imageView.tintColor = .customBlack
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

extension AddressTableViewCell: UITableViewCellConfiguration {
    func configureConstraints() {
        [
            mapIconImageView,
            titleLabel,
            addressLabel,
            chevronRightIconImageView
        ].forEach { contentView.addSubview($0) }
        
        mapIconImageView.snp.makeConstraints {
            $0.size.equalTo(20.0)
            $0.top.leading.equalTo(contentView.safeAreaLayoutGuide).offset(16.0)
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerY.equalTo(mapIconImageView)
            $0.leading.equalTo(mapIconImageView.snp.trailing).offset(8.0)
            $0.trailing.equalTo(contentView.safeAreaLayoutGuide).inset(16.0)
        }
        
        addressLabel.snp.makeConstraints {
            $0.top.equalTo(mapIconImageView.snp.bottom).offset(8.0)
            $0.leading.equalTo(mapIconImageView)
            $0.trailing.equalTo(chevronRightIconImageView.snp.leading).inset(8.0)
            $0.bottom.equalTo(contentView.safeAreaLayoutGuide).inset(8.0)
        }
        
        chevronRightIconImageView.snp.makeConstraints {
            $0.height.equalTo(22.0)
            $0.width.equalTo(13.0)
            $0.centerY.equalTo(addressLabel)
            $0.trailing.equalTo(contentView.safeAreaLayoutGuide).inset(16.0)
        }
    }
    
    func configureUI() {

    }
}
