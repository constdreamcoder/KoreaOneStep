//
//  FilteringCategoryStackView.swift
//  KoreaOneStep
//
//  Created by SUCHAN CHANG on 3/14/24.
//

import UIKit

final class FilteringCategoryStackView: UIStackView {

    private let filteringCategoryList = FilteringOrder.allCases
    
    override init(frame: CGRect) {
        super.init(frame: frame)
     
        configureUI()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        axis = .horizontal
        distribution = .equalSpacing
        alignment = .center
        spacing = 8.0
        filteringCategoryList.forEach { addArrangedSubview(generateButton(with: $0.rawValue)) }
    }
    
    private func generateButton(with title: String) -> UIButton {
        let button = UIButton()
        button.setTitle(" • \(title)", for: .normal)
        button.setTitleColor(.customDarkGray, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16.0)
        return button
    }

}
