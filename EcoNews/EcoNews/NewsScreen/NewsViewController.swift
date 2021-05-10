//
//  NewsViewController.swift
//  EcoNews
//
//  Created by Никита Ткаченко on 31.12.2020.
//

import UIKit

class NewsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    let reuseIdentifier = "recipe cell"
    var categories =  PartsOfNews.allNews
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "TableNewsViewCell", bundle: nil), forCellReuseIdentifier: reuseIdentifier)
    }

}

extension NewsViewController: UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return categories.count

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories[section].news.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier,for: indexPath) as! TableNewsViewCell
        let news = categories[indexPath.section].news[indexPath.row]
        cell.labelTitle.text = news.title
        cell.labelText.text = news.info
        cell.imageCell.image = news.photo
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return categories[section].title
    }
    
    
}
