//
//  DetailSearchViewController.swift
//  EcoHelper
//
//  Created by Никита Ткаченко on 06.05.2021.
//

import UIKit
import MapKit
import FloatingPanel
class DetailSearchViewController: UIViewController {
    internal var trashcan: MarkersLocation!
    @IBOutlet weak var imgGlass: UIImageView!
    @IBOutlet weak var imgPaper: UIImageView!
    @IBOutlet weak var imgPlastic: UIImageView!
    @IBOutlet weak var imgMetal: UIImageView!
    @IBOutlet weak var labelAddress: UILabel!
    @IBOutlet weak var btnSearch: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        labelAddress.text! += trashcan.subtitle ?? ""
        uploadImages()
    }
    
    func uploadImages(){
        if trashcan.glass{
            imgGlass.image = UIImage(named: "glassTrashcan")
        } else{
            imgGlass.image = UIImage(named: "wbGlass")
        }
        if trashcan.metall{
            imgMetal.image = UIImage(named: "metallTrashcan")
        } else{
            imgMetal.image = UIImage(named: "wbMetall")
        }
        if trashcan.paper{
            imgPaper.image = UIImage(named: "paperTrashcan")
        } else{
            imgPaper.image = UIImage(named: "wbPaper")
        }
        if trashcan.plastic{
            imgPlastic.image = UIImage(named: "plasticTrashcan")
        } else{
            imgPlastic.image = UIImage(named: "wbPlastic")
        }
    }

}
