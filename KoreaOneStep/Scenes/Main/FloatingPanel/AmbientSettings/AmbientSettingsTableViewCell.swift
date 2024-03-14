//
//  AmbientSettingsTableViewCell.swift
//  KoreaOneStep
//
//  Created by SUCHAN CHANG on 3/13/24.
//

import UIKit
import SnapKit

final class AmbientSettingsTableViewCell: UITableViewCell {
    
    let ambientLabel: UILabel = {
        let label = UILabel()
        label.text = "주변"
        label.textColor = .customBlack
        label.font = .systemFont(ofSize: 18.0, weight: .bold)
        return label
    }()
    
    let settingButton: UIButton = {
        let button = UIButton()
        button.setTitle("\(FilteringOrder.FilteringDistance.allCases[3].rawValue) 반경 \(FilteringOrder.allCases[0].rawValue)", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16.0)
        button.setTitleColor(.customBlack, for: .normal)
        return button
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

extension AmbientSettingsTableViewCell: UITableViewCellConfiguration {
    func configureConstraints() {
        [
            ambientLabel,
            settingButton,
            chevronImageView
        ].forEach { contentView.addSubview($0) }
        
        ambientLabel.snp.makeConstraints {
            $0.top.equalTo(contentView.safeAreaLayoutGuide).offset(8.0)
            $0.leading.equalTo(contentView.safeAreaLayoutGuide).offset(14.0)
            $0.bottom.equalTo(contentView.safeAreaLayoutGuide)
        }
        
        settingButton.snp.makeConstraints {
            $0.centerY.equalTo(chevronImageView)
            $0.trailing.equalTo(chevronImageView.snp.leading)
        }
        
        chevronImageView.snp.makeConstraints {
            $0.size.equalTo(14.0)
            $0.trailing.equalTo(contentView.safeAreaLayoutGuide).inset(16.0)
            $0.centerY.equalTo(ambientLabel)
        }
    }
    
    func configureUI() {
        backgroundColor = .customWhite
        contentView.backgroundColor = .customWhite
    }
    
    func setSettingButtonAttributedTitle(_ selectedSearchingDistance: String, _ selectedFilteringCategory: String) {
        guard let buttonTitle = settingButton.title(for: .normal) else { return }
        let attributedString = NSMutableAttributedString(string: buttonTitle)
        attributedString.addAttribute(.foregroundColor, value: UIColor.customLightBlue, range: ((buttonTitle) as NSString).range(of: selectedSearchingDistance))
        attributedString.addAttribute(.foregroundColor, value: UIColor.customLightBlue, range: ((buttonTitle) as NSString).range(of: selectedFilteringCategory))
        settingButton.setAttributedTitle(attributedString, for: .normal)
    }
}
