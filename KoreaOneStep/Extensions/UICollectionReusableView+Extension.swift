//
//  UICollectionReusableView+Extension.swift
//  KoreaOneStep
//
//  Created by SUCHAN CHANG on 3/11/24.
//

import UIKit

extension UICollectionReusableView: CellIdentifiable {
    static var identifier: String {
        return String(describing: self)
    }
}
