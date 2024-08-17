//
//  CustomObservable.swift
//  KoreaOneStep
//
//  Created by SUCHAN CHANG on 3/16/24.
//

import Foundation

final class CustomObservable<T> {
    
    private var closure: ((T) -> Void)?
    
    var value: T {
        didSet {
            closure?(value)
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
    
    func bind(_ closure: @escaping (T) -> Void) {
        closure(value)
        self.closure = closure
    }
}
