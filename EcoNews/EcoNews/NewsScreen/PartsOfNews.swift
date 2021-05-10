//
//  PartsOfNews.swift
//  EcoNews
//
//  Created by Никита Ткаченко on 30.12.2020.
//

import Foundation
import UIKit
import SwiftSoup

struct PartsOfNews {
    var title: String
    var news: [News]
    
}


struct News {
    var photo: UIImage?
    var title: String
    var info: String
}


extension PartsOfNews{
    static var allNews: [PartsOfNews]{
        var articles: Array<Elements.Element>
        var h2: Array<Elements.Element>
        var times: Array<Elements.Element>
        var images:Array<UIImage> =  []
        let myUrlString = "https://nia.eco/category/world/"
        let myURL = URL(string: myUrlString)
        do{
            let myHtmlString = try! String(contentsOf: myURL!, encoding: .utf8)
            let htmlContent = myHtmlString
            do{
                let doc = try! SwiftSoup.parse(htmlContent)
                do{
                    articles = try! doc.getElementsByClass("post-summary").array()
                    h2 = try! doc.select("h2").array()
                    times = try! doc.select("time").array()
                    let p = try! doc.select("article").array()
                    var references: [String] = []
                    for i in 0...p.count-1{
                        references.append(try! p[i].getElementsByTag("a").last()!.attr("href"))
                    }
                    var photoArticle: String
                    for i in 0...p.count-1{
                        let URLArticle = URL(string: references[i])!
                        let html = try! String(contentsOf: URLArticle, encoding: .utf8)
                        let content = html
                        do{
                            let docArt = try! SwiftSoup.parse(content)
                            do{
                                photoArticle = try! docArt.select("figure").first()!.getElementsByTag("a").attr("href")
                                let csCopy = CharacterSet(bitmapRepresentation: CharacterSet.urlPathAllowed.bitmapRepresentation)
                                if let photoArticle = photoArticle.addingPercentEncoding(withAllowedCharacters: csCopy),
                                   let url = URL(string: photoArticle){
                                    print(url)
                                    let data = try! Data(contentsOf: url)
                                    let image = UIImage(data: data)!
                                    images.append(image)
                                }
                            }
                        }
                    }
                }
            }
        }
        var news: [PartsOfNews] = [PartsOfNews(title: "",news: [])]
        for i in 0...articles.count-1{
            news.append(PartsOfNews(title:try! times[i].text(), news: [
                                        News(photo:images[i],
                                             title: try! h2[i].text(),
                                             info: try! articles[i].text())]))
        }
        return news
    }
}

extension String {
    func safeAddingPercentEncoding(withAllowedCharacters allowedCharacters: CharacterSet) -> String? {
        // using a copy to workaround magic: https://stackoverflow.com/q/44754996/1033581
        let allowedCharacters = CharacterSet(bitmapRepresentation: allowedCharacters.bitmapRepresentation)
        return addingPercentEncoding(withAllowedCharacters: allowedCharacters)
    }
}
