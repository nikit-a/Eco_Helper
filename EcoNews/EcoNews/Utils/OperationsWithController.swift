//
//  OperationsWithController.swift
//  EcoHelper
//
//  Created by Никита Ткаченко on 09.05.2021.
//

import Foundation
import UIKit
class OperationsWithController {
    static func initVC(nameVC: String, identifier: String) -> UIViewController{
        let storyboard = UIStoryboard(name: nameVC, bundle: nil)
        let tabBarVC = storyboard.instantiateViewController(withIdentifier: identifier) as UIViewController
        tabBarVC.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        return tabBarVC
    }
}
