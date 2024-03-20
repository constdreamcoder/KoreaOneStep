//
//  SearchViewController.swift
//  KoreaOneStep
//
//  Created by SUCHAN CHANG on 3/10/24.
//

import UIKit
import SnapKit

final class SearchViewController: UIViewController {
    
    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.searchTextField.leftView = nil
        searchBar.searchTextField.backgroundColor = .customWhite
        searchBar.delegate = self
        return searchBar
    }()
    
    lazy var recentKeywordTableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.identifier)
            
        return tableView
    }()
    
    lazy var searchedResultTableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(SearchedResultsTableViewTableViewCell.self, forCellReuseIdentifier: SearchedResultsTableViewTableViewCell.identifier)

        tableView.isHidden = true
        
        return tableView
    }()
    
    private let viewModel = SearchViewModel()
    private var mainViewModel: MainViewModel
    
    private var recentKeywordList: [RecentKeyword] = []
    private var searchedResultList: [KSItem] = []
    
    private var selectedRegion: ACItem?
    private var selectedSiGunGu: ACItem?
    
    init(mainViewModel: MainViewModel) {
        self.mainViewModel = mainViewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavigationBar()
        configureConstraints()
        configureUI()
        bindings()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        searchBar.becomeFirstResponder()
    }
    
    private func bindings() {
        viewModel.inputViewDidLoadTrigger.value = ()
        
        viewModel.outputSearchedResultList.bind { [weak self] searchedResultList in
            guard let weakSelf = self else { return }
               
            weakSelf.searchedResultList = searchedResultList
            weakSelf.searchedResultTableView.reloadData()
            
            if searchedResultList.count >= 1 {
                weakSelf.searchedResultTableView.isHidden = false
            } else if searchedResultList.count < 0 {
                weakSelf.searchedResultTableView.isHidden = true
            }
        }
        
        viewModel.outputSelectedRegionTag.bind { [weak self] selectedRegion in
            guard let weakSelf = self else { return }
            
            weakSelf.selectedRegion = selectedRegion
        }
        
        viewModel.outputSelectedSiGunGu.bind { [weak self] selectedSiGunGu in
            guard let weakSelf = self else { return }
                        
            weakSelf.selectedSiGunGu = selectedSiGunGu
        }
        
        viewModel.outputRecentKeywordList.bind { [weak self] recentKeywordList in
            guard let weakSelf = self else { return }
            
            weakSelf.recentKeywordList = recentKeywordList
            weakSelf.recentKeywordTableView.reloadData()
        }
    }
}

extension SearchViewController {
    @objc func leftBarButtonItemTapped() {
        dismiss(animated: false)
    }
    
    @objc func rightBarButtonItemTapped() {
        let filterVC = FilterViewController(searchViewModel: viewModel)
        let filterNav = UINavigationController(rootViewController: filterVC)
        present(filterNav, animated: true)
    }
    
    @objc func xmarkButtonTapped(_ button: UIButton) {
        let recentKeyword = recentKeywordList[button.tag]
        
        viewModel.inputXmarkButtonTapTrigger.value = recentKeyword
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
        view.addSubview(recentKeywordTableView)
        view.addSubview(searchedResultTableView)
        
        recentKeywordTableView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        searchedResultTableView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func configureUI() {
        view.backgroundColor = .customWhite
    }
}

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == recentKeywordTableView {
            let recentKeyword = recentKeywordList[indexPath.row]
            
            searchBar.text = recentKeyword.keyword
            
            viewModel.inputSearchElements.value = (recentKeyword.keyword, selectedRegion, selectedSiGunGu)
        } else if tableView == searchedResultTableView {
            let selectedTouristDestination = searchedResultList[indexPath.row]
            
            mainViewModel.inputSearchVCTableViewDidSelectRowAt.value = selectedTouristDestination
            
            dismiss(animated: true)
        }
    }
}

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == recentKeywordTableView {
            return recentKeywordList.count
        } else if tableView == searchedResultTableView {
            return searchedResultList.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == recentKeywordTableView {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.identifier, for: indexPath) as? SearchTableViewCell else { return UITableViewCell() }
            
            let recentKeyword = recentKeywordList[indexPath.row]
            
            cell.keywordLabel.text = recentKeyword.keyword
            
            cell.xmarkButton.tag = indexPath.row
            cell.xmarkButton.addTarget(self, action: #selector(xmarkButtonTapped), for: .touchUpInside)
            
            return cell
        } else if tableView == searchedResultTableView {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchedResultsTableViewTableViewCell.identifier, for: indexPath) as? SearchedResultsTableViewTableViewCell else { return UITableViewCell() }
            
            let searchedResult = searchedResultList[indexPath.row]
            
            cell.nameLabel.text = searchedResult.title
            cell.addressLabel.text = searchedResult.addr1
            
            return cell
        }
        
        return UITableViewCell()
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        guard searchBar.text! != "" else { return }
        
        let trimmedsearchBarText = searchBar.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if trimmedsearchBarText != "" {
            viewModel.inputSearchElements.value = (trimmedsearchBarText, selectedRegion, selectedSiGunGu)
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            searchedResultTableView.isHidden = true
        }
    }
}
