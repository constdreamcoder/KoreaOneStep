//
//  RealmManager.swift
//  KoreaOneStep
//
//  Created by SUCHAN CHANG on 3/18/24.
//

import Foundation
import RealmSwift

final class RealmManager {
    static let shared = RealmManager()
    
    private let realm: Realm
    
    private init() {
        self.realm = try! Realm()
    }
    
    func getLocationOfDefaultRealm() {
        print("Realm is located at:", realm.configuration.fileURL!)
    }
    
    func read<T: Object>(_ object: T.Type) -> Results<T> {
        return realm.objects(object)
    }
    
    func write<T: Object>(_ object: T) {
        do {
            try realm.write {
                realm.add(object)
                print("새로운 북마크가 추가 되었습니다.")
            }
        } catch {
            // TODO: - 에러 처리하기
            print(error)
        }
    }
    
    func delete<T: Object>(_ object: T) {
        do {
            try realm.write {
                realm.delete(object)
                print("해당 북마크가 정상적으로 삭제되었습니다.")
            }
            
        } catch {
            // TODO: - 에러 처리하기
            print(error)
        }
    }
}
