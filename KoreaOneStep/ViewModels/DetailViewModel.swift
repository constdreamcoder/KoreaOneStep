//
//  DetailViewModel.swift
//  KoreaOneStep
//
//  Created by SUCHAN CHANG on 3/17/24.
//

import Foundation

final class DetailViewModel {
    
    let inputViewDidLoadTrigger: Observable<(String?, String?)> = Observable((nil, nil))
    let inputIsBookmarked: Observable<String?> = Observable(nil)
    let inputBookmarkButtonTrigger: Observable<(String?, String?, String?, String?, String?)> = Observable((nil, nil, nil, nil, nil))
    let inputAcitivityIndicatorStartTrigger: Observable<Void?> = Observable(nil)
    
    let outputDetailTableViewData: Observable<(CIItem?, Dictionary<DetailTableViewSection.ServiceDetailSection, [String]>)> = Observable((nil, [:]))
    let outputIsBookmarked: Observable<Bool> = Observable(false)
    let outputAcitivityIndicatorStartTrigger: Observable<Void?> = Observable(nil)
    
    init() {
        inputViewDidLoadTrigger.bind { [weak self]  contentId, contentTypeId in
            guard let weakSelf = self else { return }
            
            guard
                let contentId = contentId,
                let contentTypeId = contentTypeId
            else { return }
            
            let group = DispatchGroup()
            
            var touristDestinationCommonInformationTemp: CIItem?
            
            group.enter()
            KoreaTravelingManager.shared.fetchTouristDestionationCommonInformation(
                contentId: contentId,
                contentTypeId: contentTypeId
            ) { touristDestinationCommonInformation in
                
                touristDestinationCommonInformationTemp = touristDestinationCommonInformation
                
                group.leave()
            }
            
            var providedImpairmentAidServiceList: Dictionary<DetailTableViewSection.ServiceDetailSection, [String]> = [
                .physicalDisability:[],
                .visualImpairment: [],
                .hearingImpairment: [],
                .familiesWithInfantsAndToddlers: [],
                .elderlyPeople: []
            ]
            
            group.enter()
            KoreaTravelingManager.shared.fetchProvidedImpairmentAidServices(
                contentId: contentId
            ) { providedImpairmentAidServices in
                // 지체장애 도움 서비스
                // 주차여부
                providedImpairmentAidServiceList[.physicalDisability]?.append(providedImpairmentAidServices.parking)
                // 대중교통
                providedImpairmentAidServiceList[.physicalDisability]?.append(providedImpairmentAidServices.route)
                // 핵심동선
                providedImpairmentAidServiceList[.physicalDisability]?.append(providedImpairmentAidServices.publictransport)
                // 매표소
                providedImpairmentAidServiceList[.physicalDisability]?.append(providedImpairmentAidServices.ticketoffice)
                // 홍보물
                providedImpairmentAidServiceList[.physicalDisability]?.append(providedImpairmentAidServices.promotion)
                // 휠체어
                providedImpairmentAidServiceList[.physicalDisability]?.append(providedImpairmentAidServices.wheelchair)
                // 엘리베이터
                providedImpairmentAidServiceList[.physicalDisability]?.append(providedImpairmentAidServices.elevator)
                // 화장실
                providedImpairmentAidServiceList[.physicalDisability]?.append(providedImpairmentAidServices.restroom)
                // 관람석(좌석)
                providedImpairmentAidServiceList[.physicalDisability]?.append(providedImpairmentAidServices.auditorium)
                
                // 시각장애
                // 점자블록
                providedImpairmentAidServiceList[.visualImpairment]?.append(providedImpairmentAidServices.braileblock)
                // 안내요원
                providedImpairmentAidServiceList[.visualImpairment]?.append(providedImpairmentAidServices.guidehuman)
                // 음성안내
                providedImpairmentAidServiceList[.visualImpairment]?.append(providedImpairmentAidServices.audioguide)
                // 큰활자/점자 홍보물
                providedImpairmentAidServiceList[.visualImpairment]?.append(providedImpairmentAidServices.bigprint)
                // 점자표지판
                providedImpairmentAidServiceList[.visualImpairment]?.append(providedImpairmentAidServices.brailepromotion)
                // 유도안내설비
                providedImpairmentAidServiceList[.visualImpairment]?.append(providedImpairmentAidServices.guidesystem)
                
                // 청각장애
                // 수어안내
                providedImpairmentAidServiceList[.hearingImpairment]?.append(providedImpairmentAidServices.signguide)
                // 자막
                providedImpairmentAidServiceList[.hearingImpairment]?.append(providedImpairmentAidServices.videoguide)
                
                // 영유아 가족
                // 유아차 대여
                providedImpairmentAidServiceList[.familiesWithInfantsAndToddlers]?.append(providedImpairmentAidServices.stroller)
                
                // 고령자
                // 휠체어 대여
                providedImpairmentAidServiceList[.elderlyPeople]?.append(providedImpairmentAidServices.wheelchair)
                // 이동보조도구 대여
                providedImpairmentAidServiceList[.elderlyPeople]?.append("")
                
                group.leave()
            }
            
            group.notify(queue: .main) {
                weakSelf.outputDetailTableViewData.value = (touristDestinationCommonInformationTemp, providedImpairmentAidServiceList)
            }
        }
        
        inputIsBookmarked.bind { [weak self] contentId in
            guard let weakSelf = self else { return }
            
            guard let contentId = contentId else { return }
            
            let bookmarkList: [Bookmark] = RealmManager.shared.read(Bookmark.self).map { $0 }
            
            let filteredBookmarkList = bookmarkList.filter { $0.contentId == contentId }
            
            if filteredBookmarkList.count == 0 {
                weakSelf.outputIsBookmarked.value = false
            } else if filteredBookmarkList.count == 1 {
                weakSelf.outputIsBookmarked.value = true
            }
        }
        
        inputBookmarkButtonTrigger.bind { [weak self] contentId, contentTypeId, title, imageURL, region in
            
            guard let weakSelf = self else { return }
            
            guard 
                let contentId = contentId,
                let contentTypeId = contentTypeId,
                let title = title,
                let imageURL = imageURL,
                let region = region
            else { return }
            
            let bookmarkList: [Bookmark] = RealmManager.shared.read(Bookmark.self).map { $0 }
            
            let filteredBookmarkList = bookmarkList.filter { $0.contentId == contentId }
            
            if filteredBookmarkList.count < 1 {
                // 추가
                let newBookmark = Bookmark(
                    contentId: contentId,
                    contentTypeId: contentTypeId,
                    title: title,
                    imageURL: imageURL,
                    region: region
                )
                RealmManager.shared.write(newBookmark)
                weakSelf.outputIsBookmarked.value = true
            } else {
                // 삭제
                RealmManager.shared.delete(filteredBookmarkList[0])
                weakSelf.outputIsBookmarked.value = false
            }
        }
        
        inputAcitivityIndicatorStartTrigger.bind { [weak self] trigger in
            guard let weakSelf = self else { return }
            
            guard let trigger = trigger else { return }
            
            weakSelf.outputAcitivityIndicatorStartTrigger.value = trigger
        }
    }
}
