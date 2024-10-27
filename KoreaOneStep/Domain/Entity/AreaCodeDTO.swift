//
//  AreaCodeDTO.swift
//  KoreaOneStep
//
//  Created by SUCHAN CHANG on 10/27/24.
//

import Foundation

struct AreaCodeDTO: DTOModelType {
    let response: ACResponse
}

struct ACResponse: ResponseType {
    let header: ACHeader
    let body: ACBody
}

struct ACHeader: HeaderType {
    let resultCode: String
    let resultMsg: String
}

struct ACBody: BodyType {
    let items: ACItems
    let numOfRows: Int
    let pageNo: Int
    let totalCount: Int
}

struct ACItems: ItemType {
    let item: [ACItem]
}

struct ACItem: Decodable {
    let rnum: Int // 일련번호
    let code: String // 코드 : 지역코드또는시군구코드
    let name: String // 지역명또는시군구명
}
