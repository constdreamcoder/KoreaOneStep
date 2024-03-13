//
//  DetailViewController.swift
//  KoreaOneStep
//
//  Created by SUCHAN CHANG on 3/11/24.
//

import UIKit
import SnapKit

struct cellData {
    var opened = Bool()
    var sectionData = [String]()
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
        
        return tableView
    }()
    
    private var selectedService: DetailTableViewSection.ServiceDetailSection = .physicalDisability
    
    private var tableViewData = [cellData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        configureConstraints()
        configureUI()
        updateTableViewData()
    }
    
    private func updateTableViewData() {
        tableViewData = selectedService.serviceTitleList.map({ _ in
            cellData(opened: false, sectionData: ["테스트"])
        })
    }
}

extension DetailViewController {
    @objc func bookmarkRightBarButtonItemTapped() {
        print(#function)
    }
    
    @objc func shareRightBarButtonItemTapped() {
        print(#function)
    }
}

extension DetailViewController: UIViewControllerConfiguration {
    func configureNavigationBar() {
        navigationItem.title = "우가우가 한식당"
        
        navigationController?.navigationBar.tintColor = .customBlack
        
        let bookmarkImage = UIImage(systemName: "bookmark")?.withTintColor(.customBlack, renderingMode: .alwaysOriginal)
        let bookmarkRightBarButtonItem = UIBarButtonItem(image: bookmarkImage, style: .plain, target: self, action: #selector(bookmarkRightBarButtonItemTapped))
        
        let shareImage = UIImage(systemName: "square.and.arrow.up")?.withTintColor(.customBlack, renderingMode: .alwaysOriginal)
        let shareImageRightBarButtonItem = UIBarButtonItem(image: shareImage, style: .plain, target: self, action: #selector(shareRightBarButtonItemTapped))
        
        navigationItem.rightBarButtonItems = [ shareImageRightBarButtonItem, bookmarkRightBarButtonItem]
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

extension DetailViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == DetailTableViewSection.descriptionSection.rawValue {
           
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
            
            if DetailTableViewSection.DescriptionSection.allCases[indexPath.row] == .regionDetailCell {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: RegionDetailTableViewCell.identifier, for: indexPath) as? RegionDetailTableViewCell else { return UITableViewCell() }
                cell.selectionStyle = .none
                return cell
            } else if DetailTableViewSection.DescriptionSection.allCases[indexPath.row] == .phoneNumberCell {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: PhoneNumberTableViewCell.identifier, for: indexPath) as? PhoneNumberTableViewCell else { return UITableViewCell() }
                cell.selectionStyle = .none
                return cell
            } else if DetailTableViewSection.DescriptionSection.allCases[indexPath.row] == .addressCell {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: AddressTableViewCell.identifier, for: indexPath) as? AddressTableViewCell else { return UITableViewCell() }
                cell.selectionStyle = .none
                return cell
            } else if DetailTableViewSection.DescriptionSection.allCases[indexPath.row] == .serviceProvidedCell {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: ServiceProvidedTableViewCell.identifier, for: indexPath) as? ServiceProvidedTableViewCell else { return UITableViewCell() }
                cell.selectionStyle = .none
                cell.delegate = self
                return cell
            }
        } else {
            if indexPath.row == 0 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: ServiceProvidedDetailTableViewCell.identifier, for: indexPath) as? ServiceProvidedDetailTableViewCell else { return UITableViewCell() }
                cell.selectionStyle = .none
                cell.serviceTitleLabel.text = selectedService.serviceTitleList[indexPath.section - 1]
                return cell
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.identifier) else { return UITableViewCell() }
                cell.textLabel?.text = tableViewData[indexPath.section - 1].sectionData[indexPath.row - 1]
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
