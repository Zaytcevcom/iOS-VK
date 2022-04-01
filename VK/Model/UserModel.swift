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
    let image: UIImage?
    var photos: [PhotoModel] = []
}
