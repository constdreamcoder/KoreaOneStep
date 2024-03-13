//
//  RegionDetailTableViewCell.swift
//  KoreaOneStep
//
//  Created by SUCHAN CHANG on 3/12/24.
//

import UIKit
import SnapKit

final class RegionDetailTableViewCell: UITableViewCell {
    
    let regionImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo")
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    let regionNameLabel: UILabel = {
        let label = UILabel()
        label.text = "우가우가 한식당"
        label.textAlignment = .center
        label.textColor = .customBlack
        label.font = .systemFont(ofSize: 20.0, weight: .bold)
        label.numberOfLines = 2
        return label
    }()
    
    let regionDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "부안읍에서 격포항을 향하여 변산 해수욕장을 지나고 거의 격포에 이를 즈음 마포 마을을 지나 방향을 바꾸어 왼쪽 도로의 약 2.5km 지점인 변산면 도청리에 위치하고 있다. 금구원조각미술관은 1966년 김오성이 세운 우리나라 최초의 조각 공원으로 2003년 문화관광부에 등록된 사립 박물관 제277호이다. 이곳에 전시하고 있는 작품 100여 점은 사실적인 여체가 주류를 이루고 있는데, 작품에서 풍기는 이미지가 서로 연결되어 있는 것 같아서 마치 3막 5장의 연극을 보는 것과 같다. 야외 전시장에는 변산반도에 자생하는 호랑가시나무 등 많은 수목들 사이에 변산반도 연작, 농부의 손, 유한과 무한에 대한 사유, 서쪽 하늘, 봄 하늘의 별자리, 분수령 등의 조각 예술의 극치를 보여주고 있는 작품들이 있어 자연과 예술의 정취를 한껏 감상할 수 있다. 이 조각품들은 대리석이나 화강암으로 소형작품에서 대형 작품에 이르기까지 다양한데 큰 것은 450cm나 된다. 또 이곳에는 별자리를 연구하는 민간 최초로 1991년에 세운 금구원 천문대가 있어 천체에 관심이 있는 학생·일반인 등 관광객들의 체험관광지로도 각광을 받고 있으며, 주변에는 격포항, 채석강, 수성당, 적벽강 등의 관광명소가 있어 이들과 연계 관광이 가능한 곳이다."
        label.textColor = .customBlack
        label.font = .systemFont(ofSize: 14.0)
        label.numberOfLines = 0
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureConstraints()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension RegionDetailTableViewCell: UITableViewCellConfiguration {
    func configureConstraints() {
        [
            regionImageView,
            regionNameLabel,
            regionDescriptionLabel
        ].forEach { contentView.addSubview($0) }
        
        regionImageView.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide)
            $0.height.equalTo(200)
        }
        
        regionNameLabel.snp.makeConstraints {
            $0.top.equalTo(regionImageView.snp.bottom).offset(16.0)
            $0.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide).inset(16.0)
        }
        
        regionDescriptionLabel.snp.makeConstraints {
            $0.top.equalTo(regionNameLabel.snp.bottom).offset(16.0)
            $0.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide).inset(16.0)
            $0.bottom.equalTo(contentView.safeAreaLayoutGuide).inset(16.0)
        }
    }
    
    func configureUI() {
        
    }
}
