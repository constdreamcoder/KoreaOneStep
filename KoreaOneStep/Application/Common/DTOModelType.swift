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
    associatedtype T: ItemType
    
    var items: T { get }
    var numOfRows: Int { get }
    var pageNo: Int { get }
    var totalCount: Int { get }
}

protocol ItemType: Decodable {
    associatedtype T: Decodable
    
    var item: [T] { get }
}
