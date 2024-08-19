//
//  UICollectionVIewCellConfiguration.swift
//  KoreaOneStep
//
//  Created by SUCHAN CHANG on 3/11/24.
//

import Foundation

protocol UICollectionViewCellConfiguration {
    associatedtype BindElementType
    
    func configureConstraints()
    func configureUI()
    func bind(element: BindElementType)
}
