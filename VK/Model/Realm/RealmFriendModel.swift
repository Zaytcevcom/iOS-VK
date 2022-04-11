//
//  RealmUserModel.swift
//  VK
//
//  Created by Konstantin Zaytcev on 08.04.2022.
//

import Foundation
import RealmSwift

class RealmFriendModel: Object {
    @Persisted(primaryKey: true) var id: Int
    @Persisted(indexed: true) var userId: Int
    @Persisted(indexed: true) var firstName: String = ""
    @Persisted(indexed: true) var lastName: String = ""
    @Persisted var photo100: String = ""
    @Persisted var photo200: String = ""
}

extension RealmFriendModel {
    convenience init(userId: Int, user: UserModel) {
        self.init()
        self.id = user.id
        self.userId = userId
        self.firstName = user.firstName
        self.lastName = user.lastName
        self.photo100 = user.photo100
        self.photo200 = user.photo200
    }
}
