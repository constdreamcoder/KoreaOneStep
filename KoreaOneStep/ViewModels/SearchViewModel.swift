//
//  SearchViewModel.swift
//  KoreaOneStep
//
//  Created by SUCHAN CHANG on 3/18/24.
//

import Foundation

final class SearchViewModel {
    
    let inputFilterVCViewDidLoadTrigger: Observable<Void?> = Observable(nil)
    let inputSelectedRegionTag: Observable<ACItem?> = Observable(nil)
    
    let outputAreaCodeList: Observable<[ACItem]> = Observable([])
    let outputSiGunGuCodeList: Observable<[ACItem]> = Observable([])
    
    init() {
        inputFilterVCViewDidLoadTrigger.bind { [weak self] trigger in
            guard let weakSelf = self else { return }
            
            guard let trigger = trigger else { return }
            
            KoreaTravelingManager.shared.fetchAreaCode { areaCodeList in
                weakSelf.outputAreaCodeList.value = areaCodeList
            }
        }
        
        inputSelectedRegionTag.bind { [weak self] regionTag in
            guard let weakSelf = self else { return }
            
            guard let regionTag = regionTag else { return }
            
            KoreaTravelingManager.shared.fetchAreaCode(
                areaCode: regionTag.code
            ) { siGunGuCodeList in
                weakSelf.outputSiGunGuCodeList.value = siGunGuCodeList
            }
        }
    }
}
