//
//  InternetService.swift
//  NewsFeed
//
//  Created by Денис Аблызалов on 25.01.2020.
//  Copyright © 2020 Денис Аблызалов. All rights reserved.
//

import UIKit
import Alamofire
import SystemConfiguration

class InternetService {
    static func connection() -> Bool {
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) { zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }
        
        // Working for Cellular and WiFi
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        
        let ret = (isReachable && !needsConnection)
        return ret
    }
    
    
    static let jsonCache = NSCache<NSString, AnyObject>()
    static let urlNews: String = "https://newsapi.org/v2/everything"
    
    // Request
    static func downloadJSON(withPage page: Int, withSize pageSize: Int, completion: @escaping (_ image: [Article]?) -> ()) {
        let paramaters: [String: Any] = [
          "page": page,
          "pageSize": pageSize,
          "q": "android",
          "from": "2019-04-00",
          "sortBy": "publishedAt",
          "apiKey": "26eddb253e7840f988aec61f2ece2907"
        ]
        request(urlNews, method: .get, parameters: paramaters).validate().responseJSON { responseJSON in
            switch responseJSON.result {
            case .success(let value):
                guard let response = value as? NSDictionary, let articlesObject = response.object(forKey: "articles") else { return }
                guard let articles = Article.getArray(from: articlesObject as Any) else { return }
                DispatchQueue.main.async {
                    jsonCache.setObject(articles as AnyObject, forKey: (urlNews + "=\(page)") as NSString)
                    completion(articles)
                }
            case .failure(let error):
                print(error)
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
    }
    
    // Cache JSON
    static func getJSON(withPage page: Int, withSize pageSize: Int,  completion: @escaping (_ articles: [Article]?) -> ()) {
        if let article = jsonCache.object(forKey: (urlNews + "=\(page)") as NSString) as? [Article] {
            completion(article)
        } else {
            if InternetService.connection() {
                downloadJSON(withPage: page, withSize: pageSize, completion: completion)
            } else {
                completion(nil)
            }
        }
    }
}
