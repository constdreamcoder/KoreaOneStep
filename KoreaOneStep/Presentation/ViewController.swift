//
//  ViewController.swift
//  KoreaOneStep
//
//  Created by SUCHAN CHANG on 10/30/24.
//

import UIKit
import PinLayout
import SnapKit
import NMapsMap

final class ViewController: UIViewController {
    
    private lazy var mapView: NMFMapView = {
        let mapView = NMFMapView()
        mapView.logoAlign = .leftTop
        mapView.positionMode = .direction
        return mapView
    }()
    
    private lazy var bottomSheetView: BottomSheetView = {
        let view = BottomSheetView()
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(mapView)
        view.addSubview(bottomSheetView)
        
        mapView.pin.all()
        bottomSheetView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

final class BottomSheetView: UIView {

    final class ContentView: UIView {
        
        private lazy var lineBarView: UIView = {
            let view = UIView()
            view.backgroundColor = .lightGray
            return view
        }()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            addSubview(lineBarView)
            
            lineBarView.snp.makeConstraints {
                $0.centerX.equalToSuperview()
                $0.top.equalToSuperview().inset(8)
                $0.width.equalTo(40)
                $0.height.equalTo(6)
            }
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }

    private lazy var contentView: ContentView = {
        let view = ContentView()
        view.backgroundColor = .white
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.layer.cornerRadius = 24.0
        view.clipsToBounds = true
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setLayout()
        setupGestures()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayout() {
        
        addSubview(contentView)
        
        contentView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(400)
        }
    }
    
    private func setupGestures() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        panGesture.delaysTouchesBegan = false
        panGesture.delaysTouchesEnded = false
        self.addGestureRecognizer(panGesture)
    }
    
    @objc func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self)
        print("translation", translation.y)
    }
}
