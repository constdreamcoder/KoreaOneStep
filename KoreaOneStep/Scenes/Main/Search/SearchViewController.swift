//
//  SearchViewController.swift
//  KoreaOneStep
//
//  Created by SUCHAN CHANG on 3/10/24.
//

import UIKit
import SnapKit

final class SearchViewController: UIViewController {
    
    let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.searchTextField.leftView = nil
        searchBar.searchTextField.backgroundColor = .customWhite
        return searchBar
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.identifier)
        
        tableView.rowHeight = 50
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavigationBar()
        configureConstraints()
        configureUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        searchBar.becomeFirstResponder()
    }
}

extension SearchViewController {
    @objc func leftBarButtonItemTapped() {
        dismiss(animated: false)
    }
    
    @objc func rightBarButtonItemTapped() {
        let filterVC = FilterViewController()
        let filterNav = UINavigationController(rootViewController: filterVC)
        present(filterNav, animated: true)
    }
}

extension SearchViewController: UIViewControllerConfiguration {
    func configureNavigationBar() {
        navigationController?.navigationBar.tintColor = .customBlack

        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(leftBarButtonItemTapped))
        navigationItem.titleView = searchBar
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "slider.horizontal.3"), style: .plain, target: self, action: #selector(rightBarButtonItemTapped))
    }
    
    func configureConstraints() {
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func configureUI() {
        view.backgroundColor = .customWhite
    }
}

extension SearchViewController: UITableViewDelegate {
    
}

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.identifier, for: indexPath) as? SearchTableViewCell else { return UITableViewCell() }
        
        return cell
    }
}
