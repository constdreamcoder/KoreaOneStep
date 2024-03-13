//
//  UITableViewHeaderFooterView+Extension.swift
//  KoreaOneStep
//
//  Created by SUCHAN CHANG on 3/12/24.
//

import UIKit

extension UITableViewHeaderFooterView: CellIdentifiable {
    static var identifier: String {
        return String(describing: self)
    }
}
