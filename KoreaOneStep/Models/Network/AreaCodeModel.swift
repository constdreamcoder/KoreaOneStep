//
//  AreaCodeModel.swift
//  KoreaOneStep
//
//  Created by SUCHAN CHANG on 3/18/24.
//

import Foundation

struct AreaCodeModel: Decodable {
    let response: ACResponse
}

struct ACResponse: Decodable {
    let header: ACHeader
    let body: ACBody
}

struct ACHeader: Decodable {
    let resultCode: String
    let resultMsg: String
}

struct ACBody: Decodable {
    let items: ACItems
    let numOfRows: Int
    let pageNo: Int
    let totalCount: Int
}

struct ACItems: Decodable {
    let item: [ACItem]
}

struct ACItem: Decodable {
    let rnum: Int // 일련번호
    let code: String // 코드 : 지역코드또는시군구코드
    let name: String // 지역명또는시군구명
}
