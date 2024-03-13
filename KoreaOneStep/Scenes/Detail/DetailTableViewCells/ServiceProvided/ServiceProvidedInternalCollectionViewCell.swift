//
//  ServiceProvidedInternalCollectionViewCell.swift
//  KoreaOneStep
//
//  Created by SUCHAN CHANG on 3/12/24.
//

import UIKit
import SnapKit

final class ServiceProvidedInternalCollectionViewCell: UICollectionViewCell {
    
    let serviceImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo")
        imageView.tintColor = .customBlack
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureConstraints()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ServiceProvidedInternalCollectionViewCell: UICollectionViewCellConfiguration {
    func configureConstraints() {
        contentView.addSubview(serviceImageView)
        
        serviceImageView.snp.makeConstraints {
            $0.edges.equalTo(contentView.safeAreaLayoutGuide)
        }
    }
    
    func configureUI() {
        
    }
}
