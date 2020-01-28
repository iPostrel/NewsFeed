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
    
    // Image Request
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
                storeImage(urlString: url, img: image)
                completion(image)
            }
        }
    }
    
    // Image Get
    static func getImage(withURL url: String, completion: @escaping (_ image: UIImage?) -> ()) {
        if let dict = UserDefaults.standard.object(forKey: "ImageCache") as? [String:String] {
            if let path = dict[url] {
                if let data = try? Data(contentsOf: URL(fileURLWithPath: path)) {
                    let img = UIImage(data: data)
                    completion(img)
                    return
                }
            }
        }
        if InternetService.connection() {
            downloadImage(withURL: url, completion: completion)
        }
    }
    
    // Image Cache
    static func storeImage(urlString: String, img: UIImage) {
        let path = NSTemporaryDirectory().appending(UUID().uuidString)
        let url = URL(fileURLWithPath: path)
        
        let data = img.jpegData(compressionQuality: 0.5)
        try? data?.write(to: url)
        
        var dict = UserDefaults.standard.object(forKey: "ImageCache") as? [String:String]
        if dict == nil {
            dict = [String:String]()
        }
        dict![urlString] = path
        UserDefaults.standard.set(dict, forKey: "ImageCache")
    }
}
