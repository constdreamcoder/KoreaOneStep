//
//  UIViewControllerConfiguration.swift
//  KoreaOneStep
//
//  Created by SUCHAN CHANG on 3/8/24.
//

import Foundation

protocol UIViewControllerConfiguration {
    func configureNavigationBar()
    func configureConstraints()
    func configureUI()
    func bindings()
}
