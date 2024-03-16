//
//  FilteringDistanceStackView.swift
//  KoreaOneStep
//
//  Created by SUCHAN CHANG on 3/14/24.
//

import UIKit

final class FilteringDistanceStackView: UIStackView {
    
    private let searchDistance = FilteringOrder.FilteringDistance.allCases
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        axis = .horizontal
        distribution = .equalCentering
        alignment = .center
        
        searchDistance.forEach { addArrangedSubview(labelGenerator(text: $0.getDistanceStringWithUnit)) }
    }
    
    private func labelGenerator(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = .customBlack
        label.font = .systemFont(ofSize: 14.0)
        return label
    }
}