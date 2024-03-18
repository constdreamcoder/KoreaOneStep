//
//  FilterTableViewCell.swift
//  KoreaOneStep
//
//  Created by SUCHAN CHANG on 3/10/24.
//

import UIKit
import SnapKit
import TTGTags

final class FilterTableViewCell: UITableViewCell {

    lazy var tagListView: TTGTextTagCollectionView = {
        let tagListView = TTGTextTagCollectionView()
        
        tagListView.alignment = .left
        
        tagListView.selectionLimit = 1
        
        tagListView.showsVerticalScrollIndicator = false
        tagListView.scrollView.scrollsToTop = true
            
        return tagListView
    }()
    
    var tagList: [String] = [] {
        didSet {
            addTags()
        }
    }
        
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureConstraints()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension FilterTableViewCell: UITableViewCellConfiguration {
    func configureConstraints() {
        [
            tagListView,
        ].forEach { contentView.addSubview($0) }
        
        tagListView.snp.makeConstraints {
            $0.edges.equalTo(contentView.safeAreaLayoutGuide).inset(16.0)
        }
    }
    
    func configureUI() {
    }
}

extension FilterTableViewCell {
    private func addTags() {
        tagListView.removeAllTags()
        
        for i in 0..<tagList.count {
            let content = TTGTextTagStringContent()
            content.text = tagList[i]
            content.textColor = .customBlack
            content.textFont = .boldSystemFont(ofSize: 18.0)
            
            let style = TTGTextTagStyle()
            style.borderWidth = 1
            style.borderColor = .customBlack
            style.cornerRadius = 8.0
            style.backgroundColor = .customWhite
            style.extraSpace = .init(width: 16.0, height: 16.0)
            
            let selectedContent = TTGTextTagStringContent()
            selectedContent.text = tagList[i]
            selectedContent.textColor = .customWhite
            selectedContent.textFont = .boldSystemFont(ofSize: 18.0)
            
            let selectedStyle = TTGTextTagStyle()
            selectedStyle.borderWidth = 1
            selectedStyle.borderColor = .customBlack
            selectedStyle.cornerRadius = 8.0
            selectedStyle.backgroundColor = .customBlack
            selectedStyle.extraSpace = .init(width: 16.0, height: 16.0)
            
            let textTag = TTGTextTag(content: content, style: style, selectedContent: selectedContent, selectedStyle: selectedStyle)
            
            tagListView.addTag(textTag)
        }
        tagListView.reload()
    }
}

