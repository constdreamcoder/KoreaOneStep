//
//  MainViewController.swift
//  KoreaOneStep
//
//  Created by SUCHAN CHANG on 3/8/24.
//

import UIKit
import SnapKit

final class MainViewController: UIViewController {
    
    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "원하는 지역을 검색해주세요."
        searchBar.searchBarStyle = .minimal
        
        searchBar.delegate = self
        
        return searchBar
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        configureConstraints()
        configureUI()
    }
}

extension MainViewController: UIViewControllerConfiguration {
    func configureNavigationBar() {
        navigationController?.navigationBar.isHidden = true
        
        navigationItem.backButtonTitle = ""
    }
    
    func configureConstraints() {
        [
            searchBar
        ].forEach { view.addSubview($0) }
        
        searchBar.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func configureUI() {
        view.backgroundColor = .customWhite
    }
}

extension MainViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        let searchVC = SearchViewController()
        let searchNav = UINavigationController(rootViewController: searchVC)
        searchNav.modalPresentationStyle = .fullScreen
        present(searchNav, animated: false)
    }
}
