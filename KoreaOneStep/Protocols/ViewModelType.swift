//
//  ViewModelType.swift
//  KoreaOneStep
//
//  Created by SUCHAN CHANG on 8/17/24.
//

import Foundation
import RxSwift

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    var disposeBag: DisposeBag { get set }
    
    func transform(input: Input) -> Output
}
