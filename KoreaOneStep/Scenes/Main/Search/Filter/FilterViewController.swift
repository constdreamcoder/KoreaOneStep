//
//  FilterViewController.swift
//  KoreaOneStep
//
//  Created by SUCHAN CHANG on 3/10/24.
//

import UIKit
import SnapKit
import TTGTags

final class FilterViewController: UIViewController {
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        
        // TODO: - HeaderView Identifier 문자열 리터털을 변수로 바꾸기
        tableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "customHeader")
        tableView.register(FilterTableViewCell.self, forCellReuseIdentifier: FilterTableViewCell.identifier)
        
        tableView.separatorStyle = .none
        
        return tableView
    }()
    
    private var searchViewModel: SearchViewModel?
    
    private var regionTagList: [ACItem] = []
    
    private var siGunGuTagList: [ACItem] = []
    
    init(searchViewModel: SearchViewModel) {
        self.searchViewModel = searchViewModel
        
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
        
        tableView.reloadData()
    }
    
    private func bindings() {
        guard let searchViewModel = searchViewModel else { return }
        
        searchViewModel.inputFilterVCViewDidLoadTrigger.value = ()
        
        searchViewModel.outputAreaCodeList.bind { [weak self] areaCodeList in
            guard let weakSelf = self else { return }
            
            weakSelf.regionTagList = areaCodeList
            
            weakSelf.tableView.reloadData()
        }
        
        searchViewModel.outputSiGunGuCodeList.bind { [weak self] siGunGuCodeList in
            guard let weakSelf = self else { return }
            
            weakSelf.siGunGuTagList = siGunGuCodeList
                        
            weakSelf.tableView.reloadSections([FilterTableViewSection.selectSiGunGu.rawValue], with: .none)
        }
    }
}

extension FilterViewController: UIViewControllerConfiguration {
    func configureNavigationBar() {
        navigationItem.title = "필터"
    }
    
    func configureConstraints() {
        [
            tableView,
        ].forEach { view.addSubview($0) }
        
        tableView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func configureUI() {
        view.backgroundColor = .customWhite
    }
}

extension FilterViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "customHeader")
        header?.textLabel?.text = FilterTableViewSection.allCases[section].sectionTitle
        header?.textLabel?.textColor = .customBlack
        header?.textLabel?.font = .systemFont(ofSize: 24.0, weight: .bold)
        
        return header
    }
}

extension FilterViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return FilterTableViewSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FilterTableViewCell.identifier, for: indexPath) as? FilterTableViewCell else { return UITableViewCell() }
        
        cell.selectionStyle = .none
        
        cell.tagListView.delegate = self
        
        if FilterTableViewSection.allCases[indexPath.section] == .selectRegion {
            cell.tagList = self.regionTagList.map { $0.name }
            return cell
        }
        
        cell.tagList = self.siGunGuTagList.map { $0.name }
        return cell
    }
}

extension FilterViewController: TTGTextTagCollectionViewDelegate {
    func textTagCollectionView(_ textTagCollectionView: TTGTextTagCollectionView!, didTap tag: TTGTextTag!, at index: UInt) {
        if tag.selected {
            let selectedTagName = tag.content.getAttributedString().string
            
            let selectedSiGunGuTagList = self.siGunGuTagList.filter { $0.name == selectedTagName }
            
            if selectedSiGunGuTagList.count >= 1 {
                print("시군구", selectedSiGunGuTagList)
                
            } else {
                let selectedReigonTagList = self.regionTagList.filter { $0.name == selectedTagName }
                print("지역", selectedReigonTagList)

                guard let searchViewModel = searchViewModel else { return }
                searchViewModel.inputSelectedRegionTag.value = selectedReigonTagList[0]
            }
        }
    }
    
}

