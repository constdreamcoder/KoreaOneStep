//
//  ContentViewController.swift
//  KoreaOneStep
//
//  Created by SUCHAN CHANG on 3/13/24.
//

import UIKit
import SnapKit
import Kingfisher
import CoreLocation

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
    
    private var filteringButtonList: [UIButton] = []
    
    private var mainViewModel: MainViewModel
    
    private var locationBasedTouristDestinationList: [SearchResulData] = []
    
    private var selectedFilteringDistance: FilteringOrder.FilteringDistance = FilteringOrder.FilteringDistance.allCases[3]
    private var selectedFilteringCategory: FilteringOrder = FilteringOrder.allCases[0]
     var userLocationInfo: CLLocationCoordinate2D?
    var selectedTourType: TourType?
    
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
        binding()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true

        mainViewModel.inputForTableViewUpdate.value = (self.userLocationInfo, self.selectedFilteringDistance, self.selectedFilteringCategory)
    }
    
    private func selectFilteringDistance(slider: UISlider) -> FilteringOrder.FilteringDistance {
        let value = slider.value
        
        if value <= 1.0 {
            slider.value = 0.0
            return FilteringOrder.FilteringDistance.allCases[0]
        } else if value > 1.0 && value <= 3.0 {
            slider.value = 2.0
            return FilteringOrder.FilteringDistance.allCases[1]
        } else if value > 3.0 && value <= 5.0 {
            slider.value = 4.0
            return FilteringOrder.FilteringDistance.allCases[2]
        } else if value > 5.0 && value <= 7.0 {
            slider.value = 6.0
            return FilteringOrder.FilteringDistance.allCases[3]
        } else if value > 7.0 && value <= 9.0 {
            slider.value = 8.0
            return FilteringOrder.FilteringDistance.allCases[4]
        } else {
            slider.value = 10.0
            return FilteringOrder.FilteringDistance.allCases[5]
        }
    }
    
    private func binding() {
        mainViewModel.outputLocationBasedTouristDestinationList.bind { [weak self] locationBasedTouristDestinationList in
            guard let weakSelf = self else { return }
            
            weakSelf.locationBasedTouristDestinationList = locationBasedTouristDestinationList
            weakSelf.tableView.reloadSections([ContentTableViewSection.searchResultList.rawValue], with: .none)
        }
        
        mainViewModel.outputUserCurrentLocationInfo.bind { [weak self] coordinate in
            guard let weakSelf = self else { return }
            
            weakSelf.userLocationInfo = coordinate
        }
    }
}

extension ContentViewController {
    @objc func settingButtonTapped(_ button: UIButton) {
        isAmbientSettingsSectionOpened = !isAmbientSettingsSectionOpened
        
        tableView.reloadSections([ContentTableViewSection.ambientSettings.rawValue], with: .none)
    }
    
    @objc func sliderValueChanged(_ slider: UISlider) {
        self.selectedFilteringDistance = selectFilteringDistance(slider: slider)
        
        print(slider.value)
        
        tableView.reloadRows(at: [IndexPath(row: 0, section: ContentTableViewSection.allCases[0].rawValue)], with: .none)
        
        mainViewModel.inputForTableViewUpdate.value = (self.userLocationInfo, self.selectedFilteringDistance, self.selectedFilteringCategory)
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
                
                if let selectedFilteringCategory = FilteringOrder(rawValue: filteringCategoryName) {
                    self.selectedFilteringCategory = selectedFilteringCategory
                }
            } else {
                guard let buttonTitle = $0.title(for: .normal) else { return }
                let attributedString = NSMutableAttributedString(string: buttonTitle)
                attributedString.addAttribute(.foregroundColor, value: UIColor.customDarkGray, range: ((buttonTitle) as NSString).range(of: buttonTitle))
                $0.setAttributedTitle(attributedString, for: .normal)
            }
        }
        
        tableView.reloadRows(at: [IndexPath(row: 0, section: ContentTableViewSection.ambientSettings.rawValue)], with: .none)
        
        mainViewModel.inputForTableViewUpdate.value = (self.userLocationInfo, self.selectedFilteringDistance, self.selectedFilteringCategory)
    }
    
    @objc func bookmarkIconButtonTapped(_ button: UIButton) {
        guard let cell = tableView.cellForRow(at: IndexPath(row: button.tag, section: ContentTableViewSection.searchResultList.rawValue)) as? SearchResultListTableViewCell else { return }
        
        let locationBasedTouristDestination = locationBasedTouristDestinationList[button.tag].locationBasedTouristDestination
        
        if cell.isBookmarked {
            mainViewModel.inputRemoveBookmark.value = locationBasedTouristDestination
        } else {
            mainViewModel.inputAddNewBookmark.value = locationBasedTouristDestination
        }
        
        cell.isBookmarked.toggle()
    }
}

extension ContentViewController: UIViewControllerConfiguration {
    func configureNavigationBar() {
        
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
            let touristDestination = locationBasedTouristDestinationList[indexPath.row].locationBasedTouristDestination
            
            mainViewModel.inputContentVCTableViewDidSelectRowAtTrigger.value = touristDestination
            
            let detailVC = DetailViewController()
            
            detailVC.isFromBookmarkVC = false
            detailVC.mainViewModel = mainViewModel
            
            detailVC.contentTitle = touristDestination.title
            detailVC.contentId = touristDestination.contentid
            detailVC.contentTypeId = touristDestination.contenttypeid
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
        return locationBasedTouristDestinationList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if ContentTableViewSection.allCases[indexPath.section] == .ambientSettings {
            if indexPath.row == 0 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: AmbientSettingsTableViewCell.identifier) as? AmbientSettingsTableViewCell else { return UITableViewCell() }
                cell.selectionStyle = .none
                cell.settingButton.addTarget(self, action: #selector(settingButtonTapped), for: .touchUpInside)
                let title = "\(selectedFilteringDistance.getDistanceStringWithUnit) 반경 \(selectedFilteringCategory.rawValue)"
                cell.settingButton.setTitle(title, for: .normal)
                cell.setSettingButtonAttributedTitle(selectedFilteringDistance, selectedFilteringCategory)
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
        
        cell.bookmarkIconButton.addTarget(self, action: #selector(bookmarkIconButtonTapped), for: .touchUpInside)
        cell.bookmarkIconButton.tag = indexPath.row
        
        let locationBasedTouristDestination = locationBasedTouristDestinationList[indexPath.row].locationBasedTouristDestination
        
        let isBookmarked = locationBasedTouristDestinationList[indexPath.row].isBookmarked
        
        let regionImageURL = URL(string: locationBasedTouristDestination.firstimage)
        let placeholderImage = UIImage(systemName: "photo")
        cell.regionImageView.kf.setImage(with: regionImageURL, placeholder: placeholderImage)
        cell.regionNameLabel.text = locationBasedTouristDestination.title
        cell.distanceLabel.text = "\(locationBasedTouristDestination.dist.convertStringToDistanceWithIntType)m"
        cell.telephoneNumberLabel.text = locationBasedTouristDestination.tel == "" ? "전화번호 미기재" : locationBasedTouristDestination.tel
        
        cell.isBookmarked = isBookmarked
    
        return cell
    }
}
