//
//  SettingViewController.swift
//  KoreaOneStep
//
//  Created by SUCHAN CHANG on 3/8/24.
//

import UIKit
import SnapKit
import Toast
import RxSwift
import RxCocoa
import RxAppState

final class SettingViewController: UIViewController {
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
                
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.identifier)
        
        return tableView
    }()
    
    private var disposeBag = DisposeBag()
        
    private let viewModel = SettingViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavigationBar()
        configureConstraints()
        configureUI()
        bind()
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
    
    func bind() {
        
        let itemTapped = Observable.zip(
            tableView.rx.modelSelected(SettingTableViewCellTitle.self),
            tableView.rx.itemSelected
        )
        
        let input = SettingViewModel.Input(itemTapped: itemTapped)
        let output = viewModel.transform(input: input)
        
        output.settingTableViewCellTitles
            .drive(tableView.rx.items(cellIdentifier: UITableViewCell.identifier)) { row, element, cell in
                
                cell.selectionStyle = .none

                cell.textLabel?.text = element.rawValue
                cell.textLabel?.textColor = element.titleColor
                cell.textLabel?.font = .boldSystemFont(ofSize: 18.0)
                
                if !(element == .removeAllBookmarkRecords) {
                    cell.accessoryType = .disclosureIndicator
                }
            }
            .disposed(by: disposeBag)
        
        output.removeAllBookmarksToastMessage
            .drive(with: self) { owner, toastMessage in
                owner.view.makeToast(toastMessage)
            }
            .disposed(by: disposeBag)
    }
}
