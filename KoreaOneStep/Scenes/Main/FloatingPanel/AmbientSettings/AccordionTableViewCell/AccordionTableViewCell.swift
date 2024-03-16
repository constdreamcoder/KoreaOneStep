//
//  AccordionTableViewCell.swift
//  KoreaOneStep
//
//  Created by SUCHAN CHANG on 3/13/24.
//

import UIKit
import SnapKit

final class AccordionTableViewCell: UITableViewCell {
    
    let filteringDistanceStackView = FilteringDistanceStackView()

    let ambienDistanceSliderView: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 0.0
        slider.maximumValue = 10.0
        slider.value = 6.0
        return slider
    }()
    
    let filteringCategoryStackView = FilteringCategoryStackView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureConstraints()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension AccordionTableViewCell: UITableViewCellConfiguration {
    func configureConstraints() {
        [
            filteringDistanceStackView,
            ambienDistanceSliderView,
            filteringCategoryStackView
        ].forEach { contentView.addSubview($0) }
        
        filteringDistanceStackView.snp.makeConstraints {
            $0.top.equalTo(contentView.safeAreaLayoutGuide).offset(16.0)
            $0.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide).inset(16.0)
        }
        
        ambienDistanceSliderView.snp.makeConstraints {
            $0.top.equalTo(filteringDistanceStackView.snp.bottom).offset(8.0)
            $0.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide).inset(16.0)
        }
        
        filteringCategoryStackView.snp.makeConstraints {
            $0.top.equalTo(ambienDistanceSliderView.snp.bottom).offset(8.0)
            $0.leading.equalTo(filteringDistanceStackView)
            $0.bottom.equalTo(contentView.safeAreaLayoutGuide)
        }
    }
    
    func configureUI() {
        backgroundColor = .customWhite
        contentView.backgroundColor = .customWhite
        
        // TODO: - 리팩토링(UIViewController Extension으로 이동)
        guard let filteringCategoryButton = filteringCategoryStackView.arrangedSubviews[0] as? UIButton else { return }
        guard let buttonTitle = filteringCategoryButton.title(for: .normal) else { return }
        let attributedString = NSMutableAttributedString(string: buttonTitle)
        attributedString.addAttribute(.foregroundColor, value: UIColor.customLightBlue, range: ((buttonTitle) as NSString).range(of: "•"))
        let filteringCategoryName = buttonTitle.components(separatedBy: " • ")[1]
        attributedString.addAttribute(.foregroundColor, value: UIColor.customBlack, range: ((buttonTitle) as NSString).range(of: filteringCategoryName))
        filteringCategoryButton.setAttributedTitle(attributedString, for: .normal)
    }
}
