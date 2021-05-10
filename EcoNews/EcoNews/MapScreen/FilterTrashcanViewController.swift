//
//  FilterTrashcanViewController.swift
//  EcoHelper
//
//  Created by Никита Ткаченко on 07.05.2021.
//

import UIKit

class FilterTrashcanViewController: UIViewController {
    internal var isClickedGlass: Bool = false
    internal var isClickedMetal: Bool = false
    internal var isClickedPaper: Bool = false
    internal var isClickedPlastic: Bool = false
    internal var isClickedFavorite: Bool = false
    @IBOutlet weak var btnGlass: UIButton!
    @IBOutlet weak var btnMetal: UIButton!
    @IBOutlet weak var btnPaper: UIButton!
    @IBOutlet weak var btnPlastic: UIButton!
    @IBOutlet weak var btnFavorite: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

    }    

    @IBAction func clickGlassBtn(_ sender: UIButton) {
        isClickedGlass = !isClickedGlass
        if isClickedGlass {
            btnGlass.setImage(UIImage(named: "glassTrashcan"), for: .normal)
        } else{
            btnGlass.setImage(UIImage(named: "wbGlass"), for: .normal)
        }
    }
    
    @IBAction func clickMetalBtn(_ sender: UIButton) {
        isClickedMetal = !isClickedMetal
        if isClickedMetal {
            btnMetal.setImage(UIImage(named: "metallTrashcan"), for: .normal)
        } else{
            btnMetal.setImage(UIImage(named: "wbMetall"), for: .normal)
        }
    }
    @IBAction func clickPaperBtn(_ sender: UIButton) {
        isClickedPaper = !isClickedPaper
        if isClickedPaper {
            btnPaper.setImage(UIImage(named: "paperTrashcan"), for: .normal)
        } else{
            btnPaper.setImage(UIImage(named: "wbPaper"), for: .normal)
        }
    }
    @IBAction func clickPlasticBtn(_ sender: UIButton) {
        isClickedPlastic = !isClickedPlastic
        if isClickedPlastic {
            btnPlastic.setImage(UIImage(named: "plasticTrashcan"), for: .normal)
        } else{
            btnPlastic.setImage(UIImage(named: "wbPlastic"), for: .normal)
        }
    }
    @IBAction func clickFavoriteBtn(_ sender: UIButton) {
        isClickedFavorite = !isClickedFavorite
        if isClickedFavorite {
            btnFavorite.setImage(UIImage(named: "favoriteTrashcan"), for: .normal)
        } else{
            btnFavorite.setImage(UIImage(named: "wbFavorite"), for: .normal)
        }
    }
    
}
