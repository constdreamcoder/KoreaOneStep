//
//  KeywordBasedSearchgingModel.swift
//  KoreaOneStep
//
//  Created by SUCHAN CHANG on 3/19/24.
//

import Foundation

struct KeywordBasedSearchgingModel: Decodable {
    let response: KSResponse
}

struct KSResponse: Decodable {
    let header: KSHeader
    let body: KSBody
}

struct KSHeader: Decodable {
    let resultCode: String
    let resultMsg: String
}

struct KSBody: Decodable {
    let items: KSItems
    let numOfRows: Int
    let pageNo: Int
    let totalCount: Int
}

struct KSItems: Decodable {
    let item: [KSItem]
}

// TODO: - 모델 공통부분 통합 처리
struct KSItem: Decodable {
    let addr1: String // 주소
    let addr2: String // 상세주소
    let areacode: String // 지역코드
    let booktour: String // 교과서속여행지 여부
    let cat1: String // 대분류
    let cat2: String // 중분류
    let cat3: String // 소분류
    let contentid: String // 콘텐츠ID
    let contenttypeid: String // 콘텐츠타입ID
    let createdtime: String // 등록일
    let firstimage: String // 대표이미지(원본)
    let firstimage2: String // 대표이미지(썸네일)
    let cpyrhtDivCd: String // 저작권 유형 (Type1:제1유형(출처표시-권장), Type3:제3유형(제1유형+변경금지)
    let mapx: String // GPS X좌표
    let mapy: String // GPS Y좌표
    let mlevel: String // Map Level
    let modifiedtime: String // 수정일
    let sigungucode: String // 시군구코드
    let tel: String // 전화번호
    let title: String // 제목
}
