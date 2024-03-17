//
//  TouristDestionationCommonInformationModel.swift
//  KoreaOneStep
//
//  Created by SUCHAN CHANG on 3/17/24.
//

import Foundation

struct TouristDestionationCommonInformationModel: Decodable {
    let response: CIResponse
}

struct CIResponse: Decodable {
    let header: CIHeader
    let body: CIBody
}

struct CIHeader: Decodable {
    let resultCode: String
    let resultMsg: String
}

struct CIBody: Decodable {
    let items: CIItems
    let numOfRows: Int
    let pageNo: Int
    let totalCount: Int
}

struct CIItems: Decodable {
    let item: [CIItem]
}

struct CIItem: Decodable {
    let contentid: String // 콘텐츠ID
    let contenttypeid: String // 콘텐츠타입ID
    let title: String // 콘텐츠명(제목)
    let createdtime: String // 등록일
    let modifiedtime: String // 수정일
    let tel: String // 전화번호
    let telname: String // 전화번호명
    let homepage: String // 홈페이지주소
    let booktour: String // 교과서여행지여부
    let firstimage: String // 대표이미지(원본)
    let firstimage2: String // 대표이미지(썸네일)
    let cpyrhtDivCd: String // 저작권 유형 (Type1:제1유형(출처표시-권장), Type3:제3유형(제1유형+변경금지)
    let areacode: String // 지역코드
    let sigungucode: String // 시군구코드
    let cat1: String // 대분류
    let cat2: String // 중분류
    let cat3: String // 소분류
    let addr1: String // 주소
    let addr2: String // 상세주소
    let zipcode: String // 우편번호
    let mapx: String // GPS X좌표
    let mapy: String // GPS Y좌표
    let mlevel: String // Map Level
    let overview: String // 개요
}
