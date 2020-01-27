//
//  Article.swift
//  NewsFeed
//
//  Created by Денис Аблызалов on 26.01.2020.
//  Copyright © 2020 Денис Аблызалов. All rights reserved.
//

import Foundation

struct Article: Codable {
    var source: Source?
    var author: String?
    var title: String?
    var description: String?
    var url: String?
    var urlToImage: String?
    var publishedAt: String?
    var content: String?
    
    init?(json: [String: Any]) {
        guard
            let source = json["source"] as? [String: Any],
            let author = json["author"] as? String,
            let title = json["title"] as? String,
            let description = json["description"] as? String,
            let url = json["url"] as? String,
            let urlToImage = json["urlToImage"] as? String,
            let publishedAt = json["publishedAt"] as? String,
            let content = json["content"] as? String
        else {
            return nil
        }
        self.source = Source(json: source)
        self.author = author
        self.title = title
        self.description = description
        self.url = url
        self.publishedAt = publishedAt
        self.content = content
        
        // Reference correcting for image
        let string = urlToImage
        if let range = string.range(of: "?") {
            let substring = string[..<range.lowerBound]
            self.urlToImage = String(substring)
        } else {
            self.urlToImage = urlToImage
        }
    }
    
    static func getArray(from jsonArray: Any) -> [Article]? {
        guard let jsonArray = jsonArray as? Array<[String: Any]> else { return nil }
        return jsonArray.compactMap { Article(json: $0) }
    }
}

struct Source: Codable {
    var id: String?
    var name: String?
    
    init?(json: [String: Any]) {
        guard
            let id = json["id"] as? String,
            let name = json["name"] as? String
        else {
            return nil
        }
        self.id = id
        self.name = name
    }
}
