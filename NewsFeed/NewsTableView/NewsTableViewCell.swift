//
//  NewsTableViewCell.swift
//  NewsFeed
//
//  Created by Денис Аблызалов on 24.01.2020.
//  Copyright © 2020 Денис Аблызалов. All rights reserved.
//

import UIKit

class NewsTableViewCell: UITableViewCell {

    @IBOutlet weak var newsImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var contentNewsView: UIView!
    @IBOutlet weak var imageIndicator: UIActivityIndicatorView!
    @IBOutlet weak var contentDescriptionView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        newsImageView.layer.cornerRadius = 2
        contentNewsView.layer.cornerRadius = 2
        contentNewsView.layer.borderWidth = 0.3
        contentNewsView.layer.borderColor = UIColor.lightGray.cgColor
        contentNewsView.layer.shadowColor = UIColor.black.cgColor
        contentNewsView.layer.shadowOpacity = 0.1
        contentNewsView.layer.shadowOffset = CGSize(width: 2, height: 2)
        contentNewsView.layer.shadowRadius = 2
    }
    
    func set(article: Article) {
        titleLabel.text = article.title
        dateLabel.text = publishedDate(publishedAt: article.publishedAt!, format: "dd.MM HH:mm")
        // Description
        descriptionLabel.text = article.description
        contentDescriptionView.isHidden = article.description == "" ? true : false
        // Image
        newsImageView.image = nil
        newsImageView.isHidden = false
        imageIndicator.isHidden = false
        if let imageUrl = article.urlToImage, article.urlToImage != "" {
            ImageService.getImage(withURL: imageUrl) { image in
                if let getImage = image {
                    self.newsImageView.image = getImage
                    self.imageIndicator.isHidden = true
                }
            }
        } else {
            newsImageView.isHidden = true
            imageIndicator.isHidden = true
        }
    }
    
    // DareFormatter
    func publishedDate(publishedAt: String, format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        if let date = formatter.date(from: publishedAt) {
            formatter.dateFormat = format
            return formatter.string(from: date)
        }
        return publishedAt
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
