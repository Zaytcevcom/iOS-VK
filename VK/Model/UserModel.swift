//
//  UserModel.swift
//  VK
//
//  Created by Konstantin Zaytcev on 25.12.2021.
//

import UIKit

struct UserModel {
    let id: Int
    let firstName: String
    let lastName: String
    let photo100: String
    let photo200: String
    //let image: UIImage?
    //var photos: [PhotoModel] = []
}

extension UserModel: Codable {
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case firstName = "first_name"
        case lastName = "last_name"
        case photo100 = "photo_100"
        case photo200 = "photo_200"
    }
}
