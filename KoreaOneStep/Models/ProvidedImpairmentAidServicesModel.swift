//
//  ProvidedImpairmentAidServicesModel.swift
//  KoreaOneStep
//
//  Created by SUCHAN CHANG on 3/17/24.
//

import Foundation

struct ProvidedImpairmentAidServicesModel: Decodable {
    let response: IASResponse
}

struct IASResponse: Decodable {
    let header: IASHeader
    let body: IASBody
}

struct IASHeader: Decodable {
    let resultCode: String
    let resultMsg: String
}

struct IASBody: Decodable {
    let items: IASItems
    let numOfRows: Int
    let pageNo: Int
    let totalCount: Int
}

struct IASItems: Decodable {
    let item: [IASItem]
}

struct IASItem: Decodable {
    let contentid: String // 콘텐츠ID
    let parking: String // 주차여부
    let route: String // 대중교통
    let publictransport: String // 접근로
    let ticketoffice: String // 매표소
    let promotion: String // 홍보물
    let wheelchair: String // 휠체어
    let exit: String // 출입통로
    let elevator: String // 엘리베이터
    let restroom: String // 화장실
    let auditorium: String // 관람석
    let room: String // 객실
    let handicapetc: String // 지체장애 기타 상세
    let braileblock: String // 점자블록
    let helpdog: String // 보조견동반
    let guidehuman: String // 안내요원
    let audioguide: String // 오디오가이드
    let bigprint: String // 큰활자 홍보물
    let brailepromotion: String // 점자홍보물 및 점자표지판
    let guidesystem: String // 유도안내설비
    let blindhandicapetc: String // 시각장애 기타상세
    let signguide: String // 수화안내
    let videoguide: String // 자막 비디오가이드 및 영상자막안내
    let hearingroom: String // 객실
    let hearinghandicapetc: String // 청각장애 기타상세
    let stroller: String // 유모차
    let lactationroom: String // 수유실
    let babysparechair: String // 유아용보조의자
    let infantsfamilyetc: String // 영유아가족 기타상세
}
