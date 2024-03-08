//
//  BookmarkViewController.swift
//  KoreaOneStep
//
//  Created by SUCHAN CHANG on 3/8/24.
//

import UIKit

final class BookmarkViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavigationBar()
        configureConstraints()
        configureUI()
    }
}

extension BookmarkViewController: UIViewControllerConfiguration {
    func configureNavigationBar() {
        
    }
    
    func configureConstraints() {
        
    }
    
    func configureUI() {
        view.backgroundColor = .customWhite
    }
}
