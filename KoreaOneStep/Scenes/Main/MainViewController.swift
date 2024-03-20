//
//  MainViewController.swift
//  KoreaOneStep
//
//  Created by SUCHAN CHANG on 3/8/24.
//

import UIKit
import SnapKit
import FloatingPanel
import TTGTags
import NMapsMap

final class MainViewController: UIViewController {
    
    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "원하는 지역을 검색해주세요."
        searchBar.searchBarStyle = .minimal
        
        searchBar.delegate = self
        
        return searchBar
    }()
    
    // TODO: - Floating Panel 위치에 따라 안보이게 처리하기
    lazy var tourTypeListView: TTGTextTagCollectionView = {
        let tourTypeListView = TTGTextTagCollectionView()
        
        tourTypeListView.alignment = .left
        tourTypeListView.delegate = self
        
        tourTypeListView.selectionLimit = 1
            
        tourTypeListView.scrollDirection = .horizontal
        tourTypeListView.showsHorizontalScrollIndicator = false
        
        tourTypeListView.contentInset = UIEdgeInsets(top: 2, left: 16, bottom: 2, right: 16)
        
        return tourTypeListView
    }()
    
    private let mapView: NMFMapView = {
        let mapView = NMFMapView()
        mapView.logoAlign = .leftTop
        mapView.locationOverlay.hidden = false
        mapView.positionMode = .direction
        return mapView
    }()
    
    private lazy var floatingPanelController: FloatingPanelController = {
        let floatingPC = FloatingPanelController()
        
        floatingPC.delegate = self
        
        let contentVC = ContentViewController(mainViewModel: viewModel)
        let contentNav = UINavigationController(rootViewController: contentVC)
        floatingPC.set(contentViewController: contentNav)
        floatingPC.track(scrollView: contentVC.tableView)
        floatingPC.addPanel(toParent: self)
        floatingPC.isRemovalInteractionEnabled = false
        return floatingPC
    }()
    
    private let viewModel = MainViewModel()
    
    private var userLocationInfo: CLLocationCoordinate2D?
    
    private let marker = NMFMarker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        configureConstraints()
        configureUI()
        addTourType()
        showFloatingPanel()  
        binding()        
    }
    
    // TODO: - 이 부분이 어떻게 동작하는지 다시 살펴보기
    private func showFloatingPanel() {
        floatingPanelController.show(animated: false) {
            self.floatingPanelController.didMove(toParent: self)
        }
    }
    
    private func addTourType() {
        TourType.allCases.forEach { tourType in
            let content = TTGTextTagStringContent()
            content.text = tourType.rawValue
            content.textColor = .customBlack
            content.textFont = .systemFont(ofSize: 16.0)
            
            let style = TTGTextTagStyle()
            style.cornerRadius = 16.0
            style.backgroundColor = .customWhite
            style.extraSpace = .init(width: 16.0, height: 16.0)
            
            let textTag = TTGTextTag(content: content, style: style)
            
            tourTypeListView.addTag(textTag)
        }
        
        tourTypeListView.reload()
    }
    
    private func binding() {
        viewModel.inputViewDidLoadTrigger.value = ()
        
        viewModel.outputUserCurrentLocationInfo.bind { [weak self] coordinate in
            guard let weakSelf = self else { return }
            
            guard let coordinate = coordinate else { return }
            
            weakSelf.mapView.locationOverlay.location = NMGLatLng(lat: coordinate.latitude, lng: coordinate.longitude)
            
            weakSelf.configureCamera(lat: coordinate.latitude, lng: coordinate.longitude)
            
            weakSelf.userLocationInfo = coordinate
        }
        
        viewModel.outputSelectedTouristDestination.bind { [weak self] touristDestination in
            guard let weakSelf = self else { return }

            guard let touristDestination = touristDestination else { return }
            
            weakSelf.confiugreMarker(
                lat: Double(touristDestination.mapy) ?? 126.9783881,
                lng: Double(touristDestination.mapx) ?? 37.5666102
            )
            
            weakSelf.configureCamera(
                lat: Double(touristDestination.mapy) ?? 126.9783881,
                lng: Double(touristDestination.mapx) ?? 37.5666102
            )
        }
        
        viewModel.outputTappedTouristDestination.bind { [weak self] tappedTouristDestionation in
            guard let weakSelf = self else { return }
            
            guard let tappedTouristDestionation = tappedTouristDestionation else { return }
            
            weakSelf.confiugreMarker(
                lat: Double(tappedTouristDestionation.mapy) ?? 126.9783881,
                lng: Double(tappedTouristDestionation.mapx) ?? 37.5666102
            )
            
            weakSelf.configureCamera(
                lat: Double(tappedTouristDestionation.mapy) ?? 126.9783881,
                lng: Double(tappedTouristDestionation.mapx) ?? 37.5666102
            )
            
            let detailVC = DetailViewController()
            
            detailVC.isFromBookmarkVC = false
            detailVC.mainViewModel = weakSelf.viewModel
            
            detailVC.contentTitle = tappedTouristDestionation.title
            detailVC.contentId = tappedTouristDestionation.contentid
            detailVC.contentTypeId = tappedTouristDestionation.contenttypeid
            
            guard let contentNav = weakSelf.floatingPanelController.contentViewController as? UINavigationController else { return }
            guard let contentVC = contentNav.viewControllers[0] as? ContentViewController else { return }
            
            contentVC.navigationController?.pushViewController(detailVC, animated: true)
        }
        
        viewModel.outputDetailVCLeftBarButtonItemTappedTrigger.bind { [weak self] trigger in
            guard let weakSelf = self else { return }
            
            guard let trigger = trigger else { return }
            
            weakSelf.searchBar.isHidden = false
            weakSelf.tourTypeListView.isHidden = false
        }
        
        viewModel.outputDetailVCViewDidLoadTrigger.bind { [weak self] trigger in
            guard let weakSelf = self else { return }
            
            guard let trigger = trigger else { return }
            
            weakSelf.searchBar.isHidden = true
            weakSelf.tourTypeListView.isHidden = true
        }
    }
}

// MARK: - 네이버 지도 관련 메서드
extension MainViewController {
    func configureCamera(lat: Double, lng: Double) {
        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: lat, lng: lng))
        cameraUpdate.animation = .easeOut
        cameraUpdate.animationDuration = 1.5
        mapView.moveCamera(cameraUpdate)
    }
    
    func confiugreMarker(lat: Double, lng: Double) {
        marker.mapView = nil
        marker.position = NMGLatLng(lat: lat, lng: lng)
        marker.mapView = mapView
    }
}

extension MainViewController: UIViewControllerConfiguration {
    func configureNavigationBar() {
        navigationController?.navigationBar.isHidden = true
        
        navigationItem.backButtonTitle = ""
    }
    
    func configureConstraints() {
        [
            mapView,
            searchBar,
            tourTypeListView
        ].forEach { view.addSubview($0) }
            
        mapView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        searchBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(32.0)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16.0)
        }
        
        tourTypeListView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func configureUI() {
        view.backgroundColor = .customWhite
    }
}

extension MainViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        let searchVC = SearchViewController(mainViewModel: viewModel)
        let searchNav = UINavigationController(rootViewController: searchVC)
        searchNav.modalPresentationStyle = .fullScreen
        present(searchNav, animated: false)
    }
}

extension MainViewController: TTGTextTagCollectionViewDelegate {
    func textTagCollectionView(_ textTagCollectionView: TTGTextTagCollectionView!, didTap tag: TTGTextTag!, at index: UInt) {
        tag.selected = false
        guard let content = tag.content as? TTGTextTagStringContent else { return }
        print(index, content.text)
        
        guard let contentNav = floatingPanelController.contentViewController as? UINavigationController else { return }
        guard let contentVC = contentNav.viewControllers.first as? ContentViewController else { return }
        contentVC.selectedTourType = TourType(rawValue: content.text)
        
        viewModel.inputTourType.value = (contentVC.userLocationInfo, contentVC.selectedTourType)
    }
}

extension MainViewController: FloatingPanelControllerDelegate {
    
}
