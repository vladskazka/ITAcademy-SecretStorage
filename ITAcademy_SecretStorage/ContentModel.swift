//
//  ContentModel.swift
//  ITAcademy_SecretStorage
//
//  Created by Влад Муравьев on 09.06.2024.
//

import Foundation

protocol IContentModel {
    func setNewIndex(movingTo direction: Direction, with count: Int, _ index: Int) -> Int
}

final class ContentModel: IContentModel {
        
    func setNewIndex(movingTo direction: Direction, with count: Int, _ index: Int) -> Int {
        
        var currentIndex = index
        
        switch direction {
        case .left:
            currentIndex -= 1
            
            if currentIndex < 0 {
                currentIndex = count - 1
            }
            
        case .right:
            currentIndex += 1
            
            if currentIndex > count - 1 {
                currentIndex = 0
            }
        }

        return currentIndex
    }
    
}
