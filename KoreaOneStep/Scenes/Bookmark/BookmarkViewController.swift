//
//  BookmarkViewController.swift
//  KoreaOneStep
//
//  Created by SUCHAN CHANG on 3/8/24.
//

import UIKit
import SnapKit
import Kingfisher

final class BookmarkViewController: UIViewController {
    
    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = "검색어를 입력해주세요"
        searchBar.delegate = self
        return searchBar
    }()
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: configureCollectionViewLayout())
        collectionView.dataSource = self
        collectionView.delegate = self
        
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
    
    private var bookmarkList: [Bookmark] = []
    
    private var isSearchingMode: Bool = false
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        configureConstraints()
        configureUI()
        bindings()
        addUserEvents()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let searchText = searchBar.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        collectionViewUpdate(with: searchText)
    }
    
    private func addUserEvents() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(backgroundViewTapped))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    private func collectionViewUpdate(with searchText: String) {
        let trimmedSearchText = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if trimmedSearchText != "" {
            viewModel.inputForCollectionViewUpdateWithsearchText.value = trimmedSearchText
        } else {
            viewModel.inputForGettingInitialCollectionViewState.value = ()
        }
    }
}

extension BookmarkViewController {
    @objc func backgroundViewTapped(_ gestureRecognizer: UIGestureRecognizer) {
        print("바탕화면 터치됨")
        view.endEditing(true)
    }
    
    @objc func bookmarkIconButtonTapped(_ button: UIButton) {
        let bookmark = bookmarkList[button.tag]
        
        viewModel.inputBookmarkIconButtonTapTrigger.value = bookmark
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
    
    func bindings() {
        viewModel.outputBookmarkList.bind { [weak self] bookmarkList in
            guard let weakSelf = self else { return }
            
            if !weakSelf.isSearchingMode {
                if bookmarkList.count >= 1 {
                    weakSelf.noBookmarkLabel.isHidden = true
                } else {
                    weakSelf.noBookmarkLabel.isHidden = false
                }
            }
           
            weakSelf.bookmarkList = bookmarkList
            
            weakSelf.collectionView.reloadData()
        }
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
        layout.headerReferenceSize = .init(width: view.frame.width, height: 190)
        // layout.headerReferenceSize = .init(width: view.frame.width, height: .zero)
        
        return layout
    }
}

extension BookmarkViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let selectedBookmark = bookmarkList[indexPath.item]
        
        let detailVC = DetailViewController()

        detailVC.isFromBookmarkVC = true

        detailVC.contentTitle = selectedBookmark.title
        detailVC.contentId = selectedBookmark.contentId
        detailVC.contentTypeId = selectedBookmark.contentTypeId
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

extension BookmarkViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: BookmarkHeaderView.identifier, for: indexPath) as? BookmarkHeaderView else { return UICollectionViewCell() }
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bookmarkList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BookmarkCollectionViewCell.identifier, for: indexPath) as? BookmarkCollectionViewCell else { return UICollectionViewCell() }
        
        let bookmark = bookmarkList[indexPath.item]
        
        let buttonImageURL = URL(string: bookmark.imageURL)
        let placeholderImage = UIImage(systemName: "photo")
        cell.thumnailImageView.kf.setImage(with: buttonImageURL, placeholder: placeholderImage)
        cell.nameLabel.text = bookmark.title
        
        cell.bookmarkIconButton.tag = indexPath.item
        cell.bookmarkIconButton.addTarget(self, action: #selector(bookmarkIconButtonTapped), for: .touchUpInside)
        return cell
    }
}

extension BookmarkViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
        isSearchingMode = true
        
//        let updatedLayout = configureCollectionViewLayout()
//        updatedLayout.headerReferenceSize = .zero
//        collectionView.collectionViewLayout = updatedLayout
            
        guard let searchText = searchBar.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        collectionViewUpdate(with: searchText)
        
        collectionView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        collectionViewUpdate(with: searchText)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        isSearchingMode = false
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
        
        isSearchingMode = false
    }
}
