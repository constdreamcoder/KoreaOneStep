//
//  SearchViewModel.swift
//  KoreaOneStep
//
//  Created by SUCHAN CHANG on 3/18/24.
//

import Foundation

final class SearchViewModel {
    let inputViewDidLoadTrigger: Observable<Void?> = Observable(nil)
    let inputFilterVCViewDidLoadTrigger: Observable<Void?> = Observable(nil)
    let inputSelectedRegionTag: Observable<ACItem?> = Observable(nil)
    let inputSelectedSiGunGuTag: Observable<ACItem?> = Observable(nil)
    let inputSearchElements: Observable<(String?, ACItem?, ACItem?)> = Observable((nil, nil, nil))
    let inputXmarkButtonTapTrigger: Observable<RecentKeyword?> = Observable(nil)
    
    let outputRecentKeywordList: Observable<[RecentKeyword]> = Observable([])
    let outputAreaCodeList: Observable<[ACItem]> = Observable([])
    let outputSiGunGuCodeList: Observable<[ACItem]> = Observable([])
    let outputSearchedResultList: Observable<[KSItem]?> = Observable(nil)
    let outputSelectedRegionTag: Observable<ACItem?> = Observable(nil)
    let outputSelectedSiGunGu: Observable<ACItem?> = Observable(nil)
    
    init() {
        inputViewDidLoadTrigger.bind { [weak self] trigger in
            guard let weakSelf = self else { return }
            
            guard let trigger = trigger else { return }
            
            let recentKeywordList: [RecentKeyword] = RealmManager.shared.read(RecentKeyword.self).sorted(byKeyPath: "regDate", ascending: false).map { $0 }
            weakSelf.outputRecentKeywordList.value = recentKeywordList
        }
        
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
            
            weakSelf.outputSelectedRegionTag.value = regionTag
            
            KoreaTravelingManager.shared.fetchAreaCode(
                areaCode: regionTag.code
            ) { siGunGuCodeList in
                
                weakSelf.outputSiGunGuCodeList.value = siGunGuCodeList
            }
        }
        
        inputSelectedSiGunGuTag.bind { [weak self] siGunGuTag in
            guard let weakSelf = self else { return }
            
            guard let siGunGuTag = siGunGuTag else { return }
            
            weakSelf.outputSelectedSiGunGu.value = siGunGuTag
        }
        
        inputSearchElements.bind { [weak self] searchText, selectedRegion, selectedSiGunGu in
            
            guard let searchText = searchText else { return }
            
            print("searchText", searchText)
            print("selectedRegion", selectedRegion)
            print("selectedSiGunGu", selectedSiGunGu)
            
            KoreaTravelingManager.shared.fetchKeywordBasedSearching(
                keyword: searchText,
                areaCode: selectedRegion == nil ? "" : selectedRegion!.code,
                sigunguCode: selectedSiGunGu == nil ? "" : selectedRegion!.code
            ) { searchedResultList in
                guard let weakSelf = self else { return }
                
                weakSelf.outputSearchedResultList.value = searchedResultList
                
                if searchedResultList.count >= 1 {
                    // 키워드가 중복 저장되었는지 확인
                    let filteredRecentKeywordList: [RecentKeyword] = RealmManager.shared.read(RecentKeyword.self).filter { $0.keyword == searchText }
                    
                    if filteredRecentKeywordList.count < 1 {
                        let newRecentKeyword = RecentKeyword(keyword: searchText)
                        RealmManager.shared.getLocationOfDefaultRealm()
                        RealmManager.shared.write(newRecentKeyword)
                        
                        let recentKeywordList: [RecentKeyword] = RealmManager.shared.read(RecentKeyword.self).sorted(byKeyPath: "regDate", ascending: false).map { $0 }
                        
                        weakSelf.outputRecentKeywordList.value = recentKeywordList
                    }
                }
            }
        }
        
        inputXmarkButtonTapTrigger.bind { [weak self] recentKeyword in
            guard let weakSelf = self else { return }
            
            guard let recentKeyword = recentKeyword else { return }
            
            RealmManager.shared.delete(recentKeyword)
            
            let updatedRecentKeywordList: [RecentKeyword] = RealmManager.shared.read(RecentKeyword.self).sorted(byKeyPath: "regDate", ascending: false).map { $0 }
            
            weakSelf.outputRecentKeywordList.value = updatedRecentKeywordList
        }
    }
}
