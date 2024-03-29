//
//  DetailViewController.swift
//  KoreaOneStep
//
//  Created by SUCHAN CHANG on 3/11/24.
//

import UIKit
import SnapKit
import Kingfisher

struct cellData {
    var opened: Bool
    var sectionData: [String]
}

final class DetailViewController: UIViewController {
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(RegionDetailTableViewCell.self, forCellReuseIdentifier: RegionDetailTableViewCell.identifier)
        tableView.register(PhoneNumberTableViewCell.self, forCellReuseIdentifier: PhoneNumberTableViewCell.identifier)
        tableView.register(AddressTableViewCell.self, forCellReuseIdentifier: AddressTableViewCell.identifier)
        tableView.register(ServiceProvidedTableViewCell.self, forCellReuseIdentifier: ServiceProvidedTableViewCell.identifier)
        tableView.register(ServiceProvidedDetailTableViewCell.self, forCellReuseIdentifier: ServiceProvidedDetailTableViewCell.identifier)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.identifier)
        
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        
        tableView.isHidden = true
        
        return tableView
    }()
    
    var contentTitle: String?
    var contentId: String?
    var contentTypeId: String?
    
    var isFromBookmarkVC: Bool = false
    
    private var viewModel = DetailViewModel()
    var mainViewModel: MainViewModel?
    
    private var selectedService: DetailTableViewSection.ServiceDetailSection = .physicalDisability
    
    private var tableViewData = [cellData]()
    
    private var touristDestinationCommonInfo: CIItem?
    
    private var providedImpairmentAidServiceList: Dictionary<DetailTableViewSection.ServiceDetailSection, [String]> = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        configureConstraints()
        configureUI()
        bindings()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if isFromBookmarkVC && touristDestinationCommonInfo == nil {
            view.makeToastActivity(.center)
        }
    }
    
    private func updateTableViewData() {
        if let providedImpairmentAidServiceDescriptionList = providedImpairmentAidServiceList[selectedService] {
            tableViewData = selectedService.serviceTitleList.enumerated().map { index, _ in
                cellData(opened: false, sectionData: [providedImpairmentAidServiceDescriptionList[index]])
            }
        } else {
            tableViewData = selectedService.serviceTitleList.map { _ in
                cellData(opened: false, sectionData: ["없음"])
            }
        }
    }
}

extension DetailViewController {
    @objc func leftBarButtonItemTapped() {
        if isFromBookmarkVC {
            navigationController?.popViewController(animated: true)
            return
        }
        
        guard let mainViewModel = mainViewModel else { return }
        mainViewModel.inputDetailVCLeftBarButtonItemTappedTrigger.value = ()
        
        navigationController?.popViewController(animated: true)
    }
    
    @objc func bookmarkRightBarButtonItemTapped() {
        print(#function)
        
        guard let touristDestinationCommonInfo = touristDestinationCommonInfo else { return }

        viewModel.inputBookmarkButtonTrigger.value = (
            contentId,
            contentTypeId,
            touristDestinationCommonInfo.title,
            touristDestinationCommonInfo.firstimage,
            touristDestinationCommonInfo.areacode
        )
    }
    
    @objc func shareRightBarButtonItemTapped() {
        print(#function)
    }
}

extension DetailViewController: UIViewControllerConfiguration {
    func configureNavigationBar() {
        navigationController?.navigationBar.isHidden = false
        
        navigationItem.title = contentTitle
        
        navigationController?.navigationBar.tintColor = .customBlack
        
        let leftBarButtonImage = UIImage(systemName: "chevron.left")?.withTintColor(.customBlack, renderingMode: .alwaysOriginal)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: leftBarButtonImage, style: .plain, target: self, action: #selector(leftBarButtonItemTapped))
        
        let bookmarkImage = UIImage(systemName: "bookmark")?.withTintColor(.systemGreen, renderingMode: .alwaysOriginal)
        let bookmarkRightBarButtonItem = UIBarButtonItem(image: bookmarkImage, style: .plain, target: self, action: #selector(bookmarkRightBarButtonItemTapped))
        
        let shareImage = UIImage(systemName: "square.and.arrow.up")?.withTintColor(.customBlack, renderingMode: .alwaysOriginal)
        let shareImageRightBarButtonItem = UIBarButtonItem(image: shareImage, style: .plain, target: self, action: #selector(shareRightBarButtonItemTapped))
        
        // TODO: - 배포 후, 주석 해제(추가 개발 예정)
//        navigationItem.rightBarButtonItems = [shareImageRightBarButtonItem, bookmarkRightBarButtonItem]
        navigationItem.rightBarButtonItems = [bookmarkRightBarButtonItem]
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
        if isFromBookmarkVC {
            viewModel.inputAcitivityIndicatorStartTrigger.value = ()
        }
        
        viewModel.inputViewDidLoadTrigger.value = (self.contentId, self.contentTypeId)
        viewModel.inputIsBookmarked.value = self.contentId
        
        viewModel.outputDetailTableViewData.bind { [weak self]
            touristDestinationCommonInfo, dictionary in
            guard let weakSelf = self else { return }
            
            weakSelf.touristDestinationCommonInfo = touristDestinationCommonInfo
            
            weakSelf.providedImpairmentAidServiceList = dictionary
            weakSelf.updateTableViewData()
            weakSelf.tableView.reloadData()
            
            if touristDestinationCommonInfo != nil {
                weakSelf.tableView.isHidden = false
            }

            if weakSelf.isFromBookmarkVC {
                weakSelf.view.hideToastActivity()
            } else {
                guard
                    let _ = touristDestinationCommonInfo else { return }
                guard let mainViewModel = weakSelf.mainViewModel else { return }
                mainViewModel.outputActivityIndicatorStopTrigger.value = ()
            }
        }
        
        viewModel.outputIsBookmarked.bind { [weak self] isBookmarked in
            guard let weakSelf = self else { return }
            
            if isBookmarked {
                weakSelf.navigationItem.rightBarButtonItems?[0].image = UIImage(systemName: "bookmark.fill")?.withTintColor(.systemGreen, renderingMode: .alwaysOriginal)
            } else {
                weakSelf.navigationItem.rightBarButtonItems?[0].image = UIImage(systemName: "bookmark")?.withTintColor(.systemGreen, renderingMode: .alwaysOriginal)
            }
        }
        
        viewModel.outputAcitivityIndicatorStartTrigger.bind { [weak self] trigger in
            guard let weakSelf = self else { return }
            
            guard let trigger = trigger else { return }
            
            weakSelf.view.makeToastActivity(.center)
        }
        
        guard let mainViewModel = mainViewModel else { return }
        mainViewModel.inputDetailVCViewDidLoadTrigger.value = ()
    }
}

extension DetailViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == DetailTableViewSection.descriptionSection.rawValue {
            if DetailTableViewSection.DescriptionSection.allCases[indexPath.row] == .addressCell {
                if !isFromBookmarkVC {
                    guard
                        let mainViewModel = mainViewModel,
                        let touristDestinationCommonInfo = touristDestinationCommonInfo
                    else { return }
                    
                    guard
                        let latitude = Double(touristDestinationCommonInfo.mapy),
                        let longitude = Double(touristDestinationCommonInfo.mapx)
                    else { return }
                    
                    mainViewModel.inputDetailVCAddressCellTappTrigger.value = (latitude, longitude)
                }
            }
        } else {
            tableView.deselectRow(at: indexPath, animated: true)
            
            if indexPath.row == 0 {
                tableViewData[indexPath.section - 1].opened = !tableViewData[indexPath.section - 1].opened
                
                tableView.reloadSections([indexPath.section], with: .none)
               
                if indexPath.section == selectedService.providedServiceNumber && tableViewData[selectedService.providedServiceNumber - 1].opened {
                    tableView.scrollToRow(at: IndexPath(row: 1, section: selectedService.providedServiceNumber), at: .bottom, animated: true)
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == DetailTableViewSection.descriptionSection.rawValue {
            if DetailTableViewSection.DescriptionSection.allCases[indexPath.row] == .serviceProvidedCell {
                return 80
            }
            return UITableView.automaticDimension
        } else {
            return UITableView.automaticDimension
        }
    }
}

extension DetailViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return DetailTableViewSection.allCases.count - 1 + selectedService.providedServiceNumber
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == DetailTableViewSection.descriptionSection.rawValue {
            return DetailTableViewSection.DescriptionSection.allCases.count
        } else {
            if tableViewData[section - 1].opened {
                return tableViewData[section - 1].sectionData.count + 1
            } else {
                return 1
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == DetailTableViewSection.descriptionSection.rawValue {
            if let touristDestinationCommonInfo = touristDestinationCommonInfo {
                if DetailTableViewSection.DescriptionSection.allCases[indexPath.row] == .regionDetailCell {
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: RegionDetailTableViewCell.identifier, for: indexPath) as? RegionDetailTableViewCell else { return UITableViewCell() }
                    cell.selectionStyle = .none
                    
                    let regionImageURL = URL(string: touristDestinationCommonInfo.firstimage)
                    let placeHolderImage = UIImage(systemName: "photo")
                    cell.regionImageView.kf.setImage(with: regionImageURL, placeholder: placeHolderImage)
                    cell.regionNameLabel.text = touristDestinationCommonInfo.title
                    cell.regionDescriptionLabel.text = touristDestinationCommonInfo.overview.htmlEscaped
                    return cell
                } else if DetailTableViewSection.DescriptionSection.allCases[indexPath.row] == .phoneNumberCell {
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: PhoneNumberTableViewCell.identifier, for: indexPath) as? PhoneNumberTableViewCell else { return UITableViewCell() }
                    cell.selectionStyle = .none
                    
                    cell.phoneNumberLabel.text = touristDestinationCommonInfo.tel == "" ? "없음" : touristDestinationCommonInfo.tel
                    return cell
                } else if DetailTableViewSection.DescriptionSection.allCases[indexPath.row] == .addressCell {
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: AddressTableViewCell.identifier, for: indexPath) as? AddressTableViewCell else { return UITableViewCell() }
                    cell.selectionStyle = .none
                    
                    cell.addressLabel.text = touristDestinationCommonInfo.addr1 == "" ? "없음" : touristDestinationCommonInfo.addr1
                    cell.chevronRightIconImageView.isHidden = isFromBookmarkVC
                    return cell
                } else if DetailTableViewSection.DescriptionSection.allCases[indexPath.row] == .serviceProvidedCell {
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: ServiceProvidedTableViewCell.identifier, for: indexPath) as? ServiceProvidedTableViewCell else { return UITableViewCell() }
                    cell.selectionStyle = .none
                    cell.delegate = self
                    return cell
                }
            }
        } else {
            if indexPath.row == 0 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: ServiceProvidedDetailTableViewCell.identifier, for: indexPath) as? ServiceProvidedDetailTableViewCell else { return UITableViewCell() }
                cell.selectionStyle = .none
                cell.serviceTitleLabel.text = selectedService.serviceTitleList[indexPath.section - 1]
                if tableViewData[indexPath.section - 1].opened {
                    cell.chevronImageView.image = UIImage(systemName: "chevron.up")
                } else {
                    cell.chevronImageView.image = UIImage(systemName: "chevron.down")
                }
                return cell
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.identifier) else { return UITableViewCell() }
                let providedImpairmentAidServiceDescription = tableViewData[indexPath.section - 1].sectionData[indexPath.row - 1]
                cell.textLabel?.text = providedImpairmentAidServiceDescription == "" ? "없음" : providedImpairmentAidServiceDescription
                cell.textLabel?.numberOfLines = 0
                return cell
            }
        }
        return UITableViewCell()
    }
}

extension DetailViewController: ServiceProvidedTableViewCellDelegate {
    func transferSelectedService(selectedService: DetailTableViewSection.ServiceDetailSection) {
        self.selectedService = selectedService
        updateTableViewData()
        tableView.reloadData()
        tableView.scrollToRow(at: IndexPath(row: 0, section: selectedService.providedServiceNumber), at: .bottom, animated: true)
    }
}
