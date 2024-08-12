//
//  Image.swift
//  ITAcademy_SecretStorage
//
//  Created by Влад Муравьев on 05.06.2024.
//

import Foundation

final class Image: Codable {
    
    let name: String
    let date: String
    var description: String
    var isLiked: Bool
    
    init(name: String, date: String, description: String, isLiked: Bool) {
        self.name = name
        self.date = date
        self.description = description
        self.isLiked = isLiked
    }

}
