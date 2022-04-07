//
//  PhotoModel.swift
//  VK
//
//  Created by Konstantin Zaytcev on 03.01.2022.
//

import UIKit

struct PhotoModel {
    let id: Int
    let albumId: Int
    let date: Int
    let ownerId: Int
    let sizes: [PhotoModelSizes]
    let text: String?
    let likes: PhotoModelLikes
}

extension PhotoModel: Codable {
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case albumId = "album_id"
        case date = "date"
        case ownerId = "owner_id"
        case sizes = "sizes"
        case text = "text"
        case likes = "likes"
    }
}

struct PhotoModelSizes {
    let height: Int
    let url: String
    let type: String
    let width: Int
}

extension PhotoModelSizes: Codable {
    enum CodingKeys: String, CodingKey {
        case height = "height"
        case url = "url"
        case type = "type"
        case width = "width"
    }
}

struct PhotoModelLikes {
    let userLikes: Int
    let count: Int
}

extension PhotoModelLikes: Codable {
    enum CodingKeys: String, CodingKey {
        case userLikes = "user_likes"
        case count = "count"
    }
}
