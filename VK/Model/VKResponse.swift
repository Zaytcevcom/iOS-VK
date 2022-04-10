//
//  VKResponse.swift
//  VK
//
//  Created by Konstantin Zaytcev on 06.04.2022.
//

struct VKResponse<T:Codable>: Codable {
    
    let response: VKResponseResponse<T>
    
    enum CodingKeys: String, CodingKey {
        case response = "response"
    }
}

struct VKResponseResponse<T:Codable> {
    let count: Int
    let items: [T]
}

extension VKResponseResponse: Codable {
    enum CodingKeys: String, CodingKey {
        case count = "count"
        case items = "items"
    }
}
