//
//  ImageService.swift
//  NewsFeed
//
//  Created by Денис Аблызалов on 25.01.2020.
//  Copyright © 2020 Денис Аблызалов. All rights reserved.
//

import UIKit
import Alamofire

class ImageService: UIImageView {
    static let imageCache = NSCache<NSString, UIImage>()
    
    // Request
    static func downloadImage(withURL url: String, completion: @escaping (_ image: UIImage?) -> ()) {
        request(url).validate().downloadProgress { progress in
//            print("totalUnitCount:\n", progress.totalUnitCount)
//            print("completedUnitCount:\n", progress.completedUnitCount)
//            print("fractionCompleted:\n", progress.fractionCompleted)
//            print("localizedDescription:\n", progress.localizedDescription as Any)
//            print("---------------------------------------------")
        }.response { response in
            guard
                let data = response.data,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async {
                imageCache.setObject(image, forKey: url as NSString)
                completion(image)
            }
        }
    }
    
    // Cache
    static func getImage(withURL url: String, completion: @escaping (_ image: UIImage?) -> ()) {
        if let image = imageCache.object(forKey: url as NSString) {
            completion(image)
        } else {
            if InternetService.connection() {
                downloadImage(withURL: url, completion: completion)
            } else {
                completion(nil)
            }
        }
    }
}
