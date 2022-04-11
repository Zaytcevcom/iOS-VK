//
//  FirebaseGroupsStatsModel.swift
//  VK
//
//  Created by Konstantin Zaytcev on 10.04.2022.
//

import Foundation
import Firebase

final class FirebaseGroupsStatsModel {
    
    let groupId: Int
    let time: Int
    
    let reference: DatabaseReference?
    
    init(groupId: Int, time: Int) {
        self.groupId = groupId
        self.time = time
        self.reference = nil
    }
    
    init?(snapshot: DataSnapshot) {
        guard
            let value = snapshot.value as? [String: Any],
            let groupId = value["group_id"] as? Int,
            let time = value["time"] as? Int
        else { return nil }
        
        self.reference = snapshot.ref
        
        self.groupId = groupId
        self.time = time
    }
    
    func toAnyObject() -> [String: Any] {
        [
            "group_id": groupId,
            "time": time
        ]
    }
}
