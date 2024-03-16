//
//  String+Extension.swift
//  KoreaOneStep
//
//  Created by SUCHAN CHANG on 3/16/24.
//

import Foundation

extension String {
    var convertStringToDistanceWithIntType: Int {
        return Int(Double(self) ?? 0.0)
    }
}
