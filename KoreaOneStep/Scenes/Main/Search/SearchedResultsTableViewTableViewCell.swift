//
//  SearchedResultsTableViewTableViewCell.swift
//  KoreaOneStep
//
//  Created by SUCHAN CHANG on 3/19/24.
//

import UIKit
import SnapKit

final class SearchedResultsTableViewTableViewCell: UITableViewCell {
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18.0, weight: .semibold)
        label.textColor = .customBlack
        label.text = "테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트"
        return label
    }()
    
    private let mapImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "map")
        imageView.tintColor = .customBlack
        return imageView
    }()
    
    let addressLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16.0)
        label.textColor = .customDarkGray
        label.text = "테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트"
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

extension SearchedResultsTableViewTableViewCell: UITableViewCellConfiguration {
    func configureConstraints() {
        [
            nameLabel,
            mapImageView,
            addressLabel
        ].forEach { contentView.addSubview($0) }
        
        nameLabel.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide).inset(16.0)
        }
        
        mapImageView.snp.makeConstraints {
            $0.size.equalTo(20.0)
            $0.top.equalTo(nameLabel.snp.bottom).offset(4.0)
            $0.leading.bottom.equalTo(contentView.safeAreaLayoutGuide).inset(16.0)
        }
        
        addressLabel.snp.makeConstraints {
            $0.leading.equalTo(mapImageView.snp.trailing).offset(4.0)
            $0.centerY.equalTo(mapImageView)
            $0.trailing.equalTo(contentView.safeAreaLayoutGuide).inset(16.0)
        }
    }
    
    func configureUI() {
        backgroundColor = .customWhite
        contentView.backgroundColor = .customWhite
    }
}
