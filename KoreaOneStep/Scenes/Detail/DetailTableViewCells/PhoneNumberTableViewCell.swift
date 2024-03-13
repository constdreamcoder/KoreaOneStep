//
//  PhoneNumberTableViewCell.swift
//  KoreaOneStep
//
//  Created by SUCHAN CHANG on 3/12/24.
//

import UIKit
import SnapKit

final class PhoneNumberTableViewCell: UITableViewCell {
    
    private let phoneIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "phone")
        imageView.tintColor = .customBlack
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "전화번호"
        label.textColor = .customBlack
        label.font = .systemFont(ofSize: 18.0, weight: .bold)
        return label
    }()
    
    let phoneNumberLabel: UILabel = {
        let label = UILabel()
        label.text = "02-752-1945"
        label.textColor = .customBlack
        label.font = .systemFont(ofSize: 16.0, weight: .semibold)
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

extension PhoneNumberTableViewCell: UITableViewCellConfiguration {
    func configureConstraints() {
        [
            phoneIconImageView,
            titleLabel,
            phoneNumberLabel
        ].forEach { contentView.addSubview($0) }
        
        phoneIconImageView.snp.makeConstraints {
            $0.size.equalTo(20.0)
            $0.top.equalTo(contentView.safeAreaLayoutGuide).offset(8.0)
            $0.top.leading.equalTo(contentView.safeAreaLayoutGuide).offset(16.0)
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerY.equalTo(phoneIconImageView)
            $0.leading.equalTo(phoneIconImageView.snp.trailing).offset(8.0)
            $0.trailing.equalTo(contentView.safeAreaLayoutGuide).inset(16.0)
        }
        
        phoneNumberLabel.snp.makeConstraints {
            $0.top.equalTo(phoneIconImageView.snp.bottom).offset(8.0)
            $0.leading.equalTo(phoneIconImageView)
            $0.trailing.equalTo(contentView.safeAreaLayoutGuide).inset(16.0)
            $0.bottom.equalTo(contentView.safeAreaLayoutGuide).inset(8.0)
        }
    }
    
    func configureUI() {
    }
}
