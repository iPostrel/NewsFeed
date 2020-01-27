//
//  NewsWebViewController.swift
//  NewsFeed
//
//  Created by Денис Аблызалов on 24.01.2020.
//  Copyright © 2020 Денис Аблызалов. All rights reserved.
//

import UIKit
import WebKit

class NewsWebViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var closeWebViewButton: UIButton!
    @IBOutlet weak var titleNewsLabel: UILabel!
    @IBOutlet weak var contentNewsView: UIView!
    @IBOutlet weak var topWebViewLayoutConstant: NSLayoutConstraint!
    
    var newsURL: String?
    var newsTitle: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleNewsLabel.text = newsTitle
        
        guard let newsURL = newsURL, let url = URL(string: newsURL) else {
            dismiss(animated: true, completion: nil);
            return }
        let urlRequest = URLRequest(url: url)
        webView.load(urlRequest)
    }
    
    // Close NewsWebViewController
    @IBAction func closeWebView(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    // Interface Orientation
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        if view.bounds.size.width > view.bounds.size.height {
            topWebViewLayoutConstant.constant = 60
        } else {
            topWebViewLayoutConstant.constant = 0
        }
    }
}
