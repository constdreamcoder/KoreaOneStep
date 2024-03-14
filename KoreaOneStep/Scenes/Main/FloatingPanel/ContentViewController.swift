//
//  ContentViewController.swift
//  KoreaOneStep
//
//  Created by SUCHAN CHANG on 3/13/24.
//

import UIKit
import SnapKit

final class ContentViewController: UIViewController {
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(AmbientSettingsTableViewCell.self, forCellReuseIdentifier: AmbientSettingsTableViewCell.identifier) 
        tableView.register(AccordionTableViewCell.self, forCellReuseIdentifier: AccordionTableViewCell.identifier)
        tableView.register(SearchResultListTableViewCell.self, forCellReuseIdentifier: SearchResultListTableViewCell.identifier)
        
        tableView.separatorStyle = .none
        
        tableView.showsVerticalScrollIndicator = true
        
        return tableView
    }()
    
    private var isAmbientSettingsSectionOpened = false
    
    private var selectedSearchingDistance: String = FilteringOrder.FilteringDistance.allCases[3].rawValue
    private var filteringButtonList: [UIButton] = []
    private var selectedFilteringCategory: String = FilteringOrder.allCases[0].rawValue
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureConstraints()
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureNavigationBar()
    }
    
    private func selectFilterDistance(slider: UISlider) -> String {
        let value = slider.value
        
        if value <= 1.0 {
            slider.value = 0.0
            return FilteringOrder.FilteringDistance.allCases[0].rawValue
        } else if value > 1.0 && value <= 3.0 {
            slider.value = 2.0
            return FilteringOrder.FilteringDistance.allCases[1].rawValue
        } else if value > 3.0 && value <= 5.0 {
            slider.value = 4.0
            return FilteringOrder.FilteringDistance.allCases[2].rawValue
        } else if value > 5.0 && value <= 7.0 {
            slider.value = 6.0
            return FilteringOrder.FilteringDistance.allCases[3].rawValue
        } else if value > 7.0 && value <= 9.0 {
            slider.value = 8.0
            return FilteringOrder.FilteringDistance.allCases[4].rawValue
        } else {
            slider.value = 10.0
            return FilteringOrder.FilteringDistance.allCases[5].rawValue
        }
    }
}

extension ContentViewController {
    @objc func settingButtonTapped(_ button: UIButton) {
        isAmbientSettingsSectionOpened = !isAmbientSettingsSectionOpened
        
        tableView.reloadSections([ContentTableViewSection.ambientSettings.rawValue], with: .none)
    }
    
    @objc func sliderValueChanged(_ slider: UISlider) {
        self.selectedSearchingDistance = selectFilterDistance(slider: slider)
        
        print(slider.value)
        
        tableView.reloadRows(at: [IndexPath(row: 0, section: ContentTableViewSection.allCases[0].rawValue)], with: .none)
    }
    
    @objc func filteringCategoryTapped(_ button: UIButton) {
        filteringButtonList.forEach {
            if $0 == button {
                // TODO: - 리팩토링하기(UIViewController Extension으로 이동)
                guard let buttonTitle = button.title(for: .normal) else { return }
                let attributedString = NSMutableAttributedString(string: buttonTitle)
                attributedString.addAttribute(.foregroundColor, value: UIColor.customLightBlue, range: ((buttonTitle) as NSString).range(of: "•"))
                let filteringCategoryName = buttonTitle.components(separatedBy: " • ")[1]
                attributedString.addAttribute(.foregroundColor, value: UIColor.customBlack, range: ((buttonTitle) as NSString).range(of: filteringCategoryName))
                button.setAttributedTitle(attributedString, for: .normal)
                self.selectedFilteringCategory = filteringCategoryName
            } else {
                guard let buttonTitle = $0.title(for: .normal) else { return }
                let attributedString = NSMutableAttributedString(string: buttonTitle)
                attributedString.addAttribute(.foregroundColor, value: UIColor.customDarkGray, range: ((buttonTitle) as NSString).range(of: buttonTitle))
                $0.setAttributedTitle(attributedString, for: .normal)
            }
        }
        
        tableView.reloadRows(at: [IndexPath(row: 0, section: ContentTableViewSection.allCases[0].rawValue)], with: .none)
    }
}

extension ContentViewController: UIViewControllerConfiguration {
    func configureNavigationBar() {
        navigationController?.navigationBar.isHidden = true
        
        navigationItem.backButtonTitle = ""
    }
    
    func configureConstraints() {
        [
            tableView
        ].forEach { view.addSubview($0) }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20.0)
            $0.bottom.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func configureUI() {
        view.backgroundColor = .customWhite
        // TODO: - Floating Panel Top 부분 둥글게 만들기
    }
}

extension ContentViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if ContentTableViewSection.allCases[indexPath.section] == .searchResultList {
            let detailVC = DetailViewController()
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }
}

extension ContentViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return ContentTableViewSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if ContentTableViewSection.allCases[section] == .ambientSettings {
            if isAmbientSettingsSectionOpened {
                return 1 + 1
            } else {
                return 1
            }
        }
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if ContentTableViewSection.allCases[indexPath.section] == .ambientSettings {
            if indexPath.row == 0 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: AmbientSettingsTableViewCell.identifier) as? AmbientSettingsTableViewCell else { return UITableViewCell() }
                cell.selectionStyle = .none
                cell.settingButton.addTarget(self, action: #selector(settingButtonTapped), for: .touchUpInside)
                let title = "\(selectedSearchingDistance) 반경 \(selectedFilteringCategory)"
                cell.settingButton.setTitle(title, for: .normal)
                cell.setSettingButtonAttributedTitle(selectedSearchingDistance, selectedFilteringCategory)
                return cell
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: AccordionTableViewCell.identifier) as? AccordionTableViewCell else { return UITableViewCell() }
                cell.selectionStyle = .none
                cell.ambienDistanceSliderView.addTarget(self, action: #selector(sliderValueChanged), for: .touchUpInside)
                cell.filteringCategoryStackView.arrangedSubviews.forEach {
                    guard let filteringButton = $0 as? UIButton else { return }
                    filteringButton.addTarget(self, action: #selector(filteringCategoryTapped), for: .touchUpInside)
                    filteringButtonList.append(filteringButton)
                }
                return cell
            }
        }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultListTableViewCell.identifier) as? SearchResultListTableViewCell else { return UITableViewCell() }
        cell.selectionStyle = .none
        return cell
    }
}