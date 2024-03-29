//
//  SettingViewController.swift
//  KoreaOneStep
//
//  Created by SUCHAN CHANG on 3/8/24.
//

import UIKit
import SnapKit
import Toast

final class SettingViewController: UIViewController {
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.identifier)
        
        return tableView
    }()
    
    private let viewModel = SettingViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavigationBar()
        configureConstraints()
        configureUI()
        bindings()
    }
}

extension SettingViewController: UIViewControllerConfiguration {
    func configureNavigationBar() {
        navigationItem.title = navigationController?.tabBarItem.title
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
    
    func bindings() {
        viewModel.outputRemoveAllBookmarksToastMessage.bind { [weak self] toastMessage in
            guard let weakSelf = self else { return }
            
            weakSelf.view.makeToast(toastMessage)
        }
    }
}

extension SettingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(SettingTableViewCellTitle.allCases[indexPath.row].rawValue)
        
        if SettingTableViewCellTitle.allCases[indexPath.row] == .removeAllBookmarkRecords {
            viewModel.inputBookmarkRemoveAllCellTapTrigger.value = ()
        }
    }
}

extension SettingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SettingTableViewCellTitle.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.identifier)!
        
        cell.selectionStyle = .none

        cell.textLabel?.text = SettingTableViewCellTitle.allCases[indexPath.row].rawValue
        cell.textLabel?.textColor = SettingTableViewCellTitle.allCases[indexPath.row].titleColor
        cell.textLabel?.font = .boldSystemFont(ofSize: 18.0)
        
        if !(SettingTableViewCellTitle.allCases[indexPath.row] == .removeAllBookmarkRecords) {
            cell.accessoryType = .disclosureIndicator
        }
        
        return cell
    }
}
