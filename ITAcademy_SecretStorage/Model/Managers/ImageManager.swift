//
//  ImageManager.swift
//  ITAcademy_SecretStorage
//
//  Created by Влад Муравьев on 05.06.2024.
//

import Foundation

final class ImageManager {
    
    static let shared = ImageManager()
    
    private init() {}
    
    private var imageArray: [Image]?
    
    private var isFiltered: Bool = false
    
    func loadImages() {
        imageArray = UserDefaults.standard.value([Image].self, forKey: K.imageObjectKey)
        
        if isFiltered {
            imageArray = imageArray?.filter { $0.isLiked }
        }
    }
    
    func getImageArray() -> [Image]? {
        if !isFiltered {
            return imageArray
        } else {
            return imageArray?.filter { $0.isLiked }
        }
    }
    
    func toggleFilter(_ bool: Bool) {
        isFiltered = bool
    }
    
    func saveImageObject(newImage: Image) {
        if !isFiltered {
            if var images = imageArray {
                images.append(newImage)
                UserDefaults.standard.set(encodable: images, forKey: K.imageObjectKey)
                imageArray = images
            } else {
                UserDefaults.standard.set(encodable: [newImage], forKey: K.imageObjectKey)
            }
        } else {
            if var images = UserDefaults.standard.value([Image].self, forKey: K.imageObjectKey) {
                images.append(newImage)
                UserDefaults.standard.set(encodable: images, forKey: K.imageObjectKey)
            } else {
                UserDefaults.standard.set(encodable: [newImage], forKey: K.imageObjectKey)
            }
        }
    }
    
    func updateImageArray(with name: String, description: String, like: Bool) {
        guard let images = UserDefaults.standard.value([Image].self, forKey: K.imageObjectKey) else { return }
        
        for image in images {
            if image.name == name {
                image.description = description
                image.isLiked = like
            }
        }
        
        UserDefaults.standard.set(encodable: images, forKey: K.imageObjectKey)
        
        if !isFiltered {
            imageArray = images
        } else {
            imageArray = images.filter { $0.isLiked }
        }
    }
    
    func getImageObject(atIndex index: Int) -> Image? {
        return imageArray?[index]
    }
    
    func getImageCount() -> Int? {
        return imageArray?.count
    }
    
}
