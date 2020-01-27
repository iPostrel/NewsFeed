//
//  NoInternetViewCell.swift
//  NewsFeed
//
//  Created by Денис Аблызалов on 25.01.2020.
//  Copyright © 2020 Денис Аблызалов. All rights reserved.
//

import UIKit

class NoInternetViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func set(onOff: Bool, page: Int) {
        if page >= 5 {
            titleLabel.text = "The End"
        } else {
            titleLabel.text = !onOff ? "No internet connection \nPlease try again." : "Connection ..."
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
