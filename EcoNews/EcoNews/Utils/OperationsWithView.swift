//
//  changeUIView.swift
//  EcoHelper
//
//  Created by Никита Ткаченко on 09.05.2021.
//

import Foundation
import UIKit

class OperationsWithView{
    
    static func changeImageView(nameBackground: String, view: UIView) -> UIImageView{
        let background = UIImage(named: nameBackground)
        var imageView : UIImageView!
        imageView = UIImageView(frame: view.bounds)
        imageView.contentMode =  UIView.ContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = background
        imageView.center = view.center
        view.addSubview(imageView)
        return imageView
    }
}
