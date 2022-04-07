//
//  GroupModel.swift
//  VK
//
//  Created by Konstantin Zaytcev on 25.12.2021.
//

import UIKit

struct GroupModel {
    let id: Int
    let name: String
    let photo50: String?
    let photo100: String
    let photo200: String?
    //let image: UIImage?
}

extension GroupModel: Codable {
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case photo50 = "photo_50"
        case photo100 = "photo_100"
        case photo200 = "photo_200"
    }
}
