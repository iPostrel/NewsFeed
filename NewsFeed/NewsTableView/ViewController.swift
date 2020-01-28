//
//  ViewController.swift
//  NewsFeed
//
//  Created by Денис Аблызалов on 24.01.2020.
//  Copyright © 2020 Денис Аблызалов. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var newsArray: [Article] = []
    var page: Int = 0
    var pageSize: Int = 5
    var isLoading: Bool = false
    let spinner = UIActivityIndicatorView(style: .large)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingsTableView()
        getNews()
    }
    
    // TableView Settings
    func settingsTableView() {
        // TableView Settings
        tableView.tableFooterView = UIView()
        // Cell News
        let cellNib = UINib(nibName: "NewsTableViewCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "newsCell")
        // Cell NoInternet
        let cellnoIntNib = UINib(nibName: "NoInternetViewCell", bundle: nil)
        tableView.register(cellnoIntNib, forCellReuseIdentifier: "noInternetCell")
        // Activity Indicator
        spinner.startAnimating()
        spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(64))
        tableView.tableFooterView = spinner
        tableView.tableFooterView?.isHidden = false
    }
    
    // Interne + Request
    func loadNews() {
        isLoading = true
        tableView.tableFooterView?.isHidden = !isLoading
        InternetService.getJSON(withPage: page, withSize: pageSize) { articles in
            if let articleArray = articles {
                self.newsArray += articleArray
            }
            DispatchQueue.main.async {
                self.isLoading = false
                self.tableView.tableFooterView?.isHidden = !self.isLoading
                self.tableView.reloadData()
            }
        }
    }
    func getNews() {
        guard InternetService.connection() else { return }
        guard !isLoading else { return }
        page = 0
        loadNews()
    }
    func getNextNews() {
        guard InternetService.connection() else { return }
        guard !isLoading else { return }
        guard page < 5 else { return }
        page += 1
        loadNews()
    }
    
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    // Rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsArray.count + 1
    }
    // Cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if  indexPath.row == newsArray.count {
            self.tableView.tableFooterView?.isHidden = true
            let cell = tableView.dequeueReusableCell(withIdentifier: "noInternetCell", for: indexPath) as! NoInternetViewCell
            cell.set(onOff: InternetService.connection(), page: page)
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "newsCell", for: indexPath) as! NewsTableViewCell
        let newsArticle = newsArray[indexPath.row]
        cell.set(article: newsArticle)
        return cell
    }
    // Present WebView
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if InternetService.connection() && newsArray.count + 1 == 1  {
            getNews()
            return
        } else if !InternetService.connection() && indexPath.row == newsArray.count || !InternetService.connection() {
            return
        } else if indexPath.row < newsArray.count {
            let newsArticle = newsArray[indexPath.row]
            let newsWebViewController = NewsWebViewController()
            newsWebViewController.newsURL = newsArticle.url
            newsWebViewController.newsTitle = newsArticle.title
            present(newsWebViewController, animated: true, completion: nil)
        }
    }
    // Updating last сell View and getNextNews
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row >= (newsArray.count - 5) {
            getNextNews()
        }
    }
}
