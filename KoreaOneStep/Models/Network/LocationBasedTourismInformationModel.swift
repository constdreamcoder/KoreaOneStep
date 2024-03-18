//
//  LocationBasedTourismInformationModel.swift
//  KoreaOneStep
//
//  Created by SUCHAN CHANG on 3/16/24.
//

import Foundation

struct LocationBasedTourismInformationModel: Decodable {
    let response: LBResponse
}

struct LBResponse: Decodable {
    let header: LBHeader
    let body: LBBody
}

struct LBHeader: Decodable {
    let resultCode: String
    let resultMsg: String
}

struct LBBody: Decodable {
    let items: LBItems
    let numOfRows: Int
    let pageNo: Int
    let totalCount: Int
}

struct LBItems: Decodable {
    let item: [LBItem]
}

struct LBItem: Decodable {
    let addr1: String
    let addr2: String
    let areacode: String
    let booktour: String
    let cat1: String
    let cat2: String
    let cat3: String
    let contentid: String
    let contenttypeid: String
    let createdtime: String
    let dist: String
    let firstimage: String
    let firstimage2: String
    let cpyrhtDivCd: String
    let mapx: String
    let mapy: String
    let mlevel: String
    let modifiedtime: String
    let sigungucode: String
    let tel: String
    let title: String
}
