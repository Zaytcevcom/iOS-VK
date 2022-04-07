//
//  Singleton.swift
//  VK
//
//  Created by Konstantin Zaytcev on 04.04.2022.
//

final class SomeSingleton {
    
    var token: String = ""
    var userId: Int = 0
    
    static let instance = SomeSingleton()
    
    private init() {}
}
