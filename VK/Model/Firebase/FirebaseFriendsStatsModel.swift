//
//  FirebaseFriendModel.swift
//  VK
//
//  Created by Konstantin Zaytcev on 10.04.2022.
//

import Foundation
import Firebase

final class FirebaseFriendsStatsModel {
    
    let id: Int
    let time: Int
    
    let reference: DatabaseReference?
    
    init(id: Int, time: Int) {
        self.id = id
        self.time = time
        self.reference = nil
    }
    
    init?(snapshot: DataSnapshot) {
        guard
            let value = snapshot.value as? [String: Any],
            let id = value["id"] as? Int,
            let time = value["time"] as? Int
        else { return nil }
        
        self.reference = snapshot.ref
        
        self.id = id
        self.time = time
    }
    
    func toAnyObject() -> [String: Any] {
        [
            "id": id,
            "time": time
        ]
    }
}
