//
//  MainViewController.swift
//  KoreaOneStep
//
//  Created by SUCHAN CHANG on 3/8/24.
//

import UIKit

final class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        configureConstraints()
        configureUI()
    }
}

extension MainViewController: UIViewControllerConfiguration {
    func configureNavigationBar() {
        
    }
    
    func configureConstraints() {
        
    }
    
    func configureUI() {
        view.backgroundColor = .customWhite
    }
}
