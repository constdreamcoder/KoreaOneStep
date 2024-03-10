//
//  UITableViewCell+Extension.swift
//  KoreaOneStep
//
//  Created by SUCHAN CHANG on 3/10/24.
//

import UIKit

extension UITableViewCell: CellIdentifiable {
    static var identifier: String {
        return String(describing: self)
    }
}
