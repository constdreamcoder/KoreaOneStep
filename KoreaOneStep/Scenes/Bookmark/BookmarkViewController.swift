//
//  BookmarkViewController.swift
//  KoreaOneStep
//
//  Created by SUCHAN CHANG on 3/8/24.
//

import UIKit
import SnapKit
import Kingfisher
import RxSwift
import RxCocoa
import RxDataSources

final class BookmarkViewController: UIViewController {
    
    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = "검색어를 입력해주세요"
        return searchBar
    }()
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: configureCollectionViewLayout())
        
        collectionView.register(BookmarkHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: BookmarkHeaderView.identifier)
        collectionView.register(BookmarkCollectionViewCell.self, forCellWithReuseIdentifier: BookmarkCollectionViewCell.identifier)
        
        return collectionView
    }()
    
    private let noBookmarkLabel: UILabel = {
        let label = UILabel()
        label.text = "데이터가 존재하지 않습니다\n북마크를 추가해주세요!!"
        label.textColor = .customBlack
        label.numberOfLines = 2
        label.font = .boldSystemFont(ofSize: 20)
        label.backgroundColor = .customWhite
        label.textAlignment = .center
        return label
    }()
    
    private let viewModel = BookmarkViewModel()
    
    private lazy var dataSource = RxCollectionViewSectionedReloadDataSource<BookmarkSectionData> { [weak self] dataSource, collectionView, indexPath, bookmark in
        guard let self else { return UICollectionViewCell() }
             
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BookmarkCollectionViewCell.identifier, for: indexPath) as? BookmarkCollectionViewCell else { return UICollectionViewCell() }
        
        let buttonImageURL = URL(string: bookmark.imageURL)
        let placeholderImage = UIImage(systemName: "photo")
        cell.thumnailImageView.kf.setImage(with: buttonImageURL, placeholder: placeholderImage)
        cell.nameLabel.text = bookmark.title
        
        cell.viewModel = viewModel
        cell.bind(element: bookmark)
        return cell
        
    } configureSupplementaryView: { dataSource, collectionView, kind, indexPath in
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: BookmarkHeaderView.identifier, for: indexPath) as? BookmarkHeaderView else { return UICollectionViewCell() }
            return header
        default:
            return UICollectionReusableView()
        }
    }
    
    private let disposeBag = DisposeBag()
    
    private var bookmarkList: [Bookmark] = []
    
    private var isSearchingMode: Bool = false
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        configureConstraints()
        configureUI()
        bind()
        addUserEvents()
    }
    
    private func addUserEvents() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(backgroundViewTapped))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
}

extension BookmarkViewController {
    @objc func backgroundViewTapped(_ gestureRecognizer: UIGestureRecognizer) {
        print("바탕화면 터치됨")
        view.endEditing(true)
    }
}

extension BookmarkViewController: UIViewControllerConfiguration {
    func configureNavigationBar() {
        navigationItem.title = navigationController?.tabBarItem.title
        navigationItem.backButtonTitle = ""
    }
    
    func configureConstraints() {
        [
            searchBar,
            collectionView,
            noBookmarkLabel
        ].forEach { view.addSubview($0) }
        
        searchBar.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom).offset(16.0)
            $0.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        noBookmarkLabel.snp.makeConstraints{
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func configureUI() {
        view.backgroundColor = .customWhite
    }
    
    func bind() {
        
        let textDidBeginEditing = searchBar.rx.textDidBeginEditing
            .withUnretained(self)
            .map { owner, _ in
                let updatedLayout = owner.configureCollectionViewLayout()
                updatedLayout.headerReferenceSize = .zero
                owner.collectionView.collectionViewLayout = updatedLayout
            }
        
        let input = BookmarkViewModel.Input(
            viewWillAppear: rx.viewWillAppear,
            searchText: searchBar.rx.text.orEmpty,
            textDidBeginEditing: textDidBeginEditing
        )
        
        let output = viewModel.transform(input: input)
        
        output.section
            .drive(collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        output.viewWillAppear
            .drive(with: self) { owner, bookmarkCount in
                if !owner.isSearchingMode {
                    if bookmarkCount >= 1 {
                        owner.noBookmarkLabel.isHidden = true
                    } else {
                        owner.noBookmarkLabel.isHidden = false
                    }
                }
            }
            .disposed(by: disposeBag)
        
        collectionView.rx.modelSelected(Bookmark.self)
            .bind(with: self) { owner, bookmark in
                let detailVC = DetailViewController()

                detailVC.isFromBookmarkVC = true

                detailVC.contentTitle = bookmark.title
                detailVC.contentId = bookmark.contentId
                detailVC.contentTypeId = bookmark.contentTypeId
                owner.navigationController?.pushViewController(detailVC, animated: true)
            }
            .disposed(by: disposeBag)
        
        searchBar.rx.textDidEndEditing
            .bind(with: self) { owner, _ in
                owner.isSearchingMode = false
            }
            .disposed(by: disposeBag)
        
        searchBar.rx.searchButtonClicked
            .bind(with: self) { owner, _ in
                owner.view.endEditing(true)
                
                owner.isSearchingMode = false
            }
            .disposed(by: disposeBag)
    }
}

extension BookmarkViewController: UICollectionViewConfiguration {
    func configureCollectionViewLayout() -> UICollectionViewFlowLayout {
        let spacing: CGFloat = 16
        
        let layout = UICollectionViewFlowLayout()
        let itemSize = UIScreen.main.bounds.width - (spacing * 3)
        layout.itemSize = CGSize(width: itemSize / 2, height: (itemSize / 2))
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        layout.sectionInset = UIEdgeInsets(top: 0, left: spacing, bottom: 0, right: spacing)
        // TODO: - 배포 후, 주석 해제(추가 개발 예정)
//        layout.headerReferenceSize = .init(width: view.frame.width, height: 190)
         layout.headerReferenceSize = .init(width: view.frame.width, height: .zero)
        
        return layout
    }
}
