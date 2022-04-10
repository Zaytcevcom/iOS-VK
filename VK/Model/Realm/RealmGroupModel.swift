//
//  RealmUserModel.swift
//  VK
//
//  Created by Konstantin Zaytcev on 08.04.2022.
//

import Foundation
import RealmSwift

class RealmGroupModel: Object {
    @Persisted(primaryKey: true) var id: Int
    @Persisted(indexed: true) var userId: Int
    @Persisted(indexed: true) var name: String = ""
    @Persisted var photo50: String = ""
    @Persisted var photo100: String = ""
    @Persisted var photo200: String = ""
}

extension RealmGroupModel {
    convenience init(userId: Int, group: GroupModel) {
        self.init()
        self.id = group.id
        self.userId = userId
        self.name = group.name
        self.photo50 = group.photo50 ?? ""
        self.photo100 = group.photo100
        self.photo200 = group.photo200 ?? ""
    }
}
