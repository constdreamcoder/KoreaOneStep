//
//  DTOModelType.swift
//  KoreaOneStep
//
//  Created by SUCHAN CHANG on 10/27/24.
//

import Foundation

protocol DTOModelType: Decodable {
    associatedtype Response: ResponseType
    
    var response: Response { get }
}

protocol ResponseType: Decodable {
    associatedtype Header: HeaderType
    associatedtype Body: BodyType
    
    var header: Header { get }
    var body: Body { get }
}

protocol HeaderType: Decodable {
    var resultCode: String { get }
    var resultMsg: String { get }
}

protocol BodyType: Decodable {
    associatedtype Items : ItemType
    
    var items: Items { get }
    var numOfRows: Int { get }
    var pageNo: Int { get }
    var totalCount: Int { get }
}

protocol ItemType: Decodable {
    associatedtype Item: Decodable
    
    var item: [Item] { get }
}
