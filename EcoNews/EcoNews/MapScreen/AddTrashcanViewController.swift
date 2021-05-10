//
//  AddTrashcanViewController.swift
//  EcoHelper
//
//  Created by Никита Ткаченко on 09.05.2021.
//

import UIKit

class AddTrashcanViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var addressField: UITextField!
    @IBOutlet weak var latitudeField: UITextField!
    @IBOutlet weak var longitudeField: UITextField!
    @IBOutlet weak var errorText: UILabel!
    @IBOutlet weak var btnGlass: UIButton!
    @IBOutlet weak var btnMetal: UIButton!
    @IBOutlet weak var btnPaper: UIButton!
    @IBOutlet weak var btnPlastic: UIButton!
    internal var isClickedGlass: Bool = false
    internal var isClickedMetal: Bool = false
    internal var isClickedPaper: Bool = false
    internal var isClickedPlastic: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func clickBtnGlass(_ sender: UIButton) {
        isClickedGlass = !isClickedGlass
        if isClickedGlass {
            btnGlass.setImage(UIImage(named: "glassTrashcan"), for: .normal)
        } else{
            btnGlass.setImage(UIImage(named: "wbGlass"), for: .normal)
        }
    }
    
    @IBAction func clickBtnMetal(_ sender: UIButton) {
        isClickedMetal = !isClickedMetal
        if isClickedMetal {
            btnMetal.setImage(UIImage(named: "metallTrashcan"), for: .normal)
        } else{
            btnMetal.setImage(UIImage(named: "wbMetall"), for: .normal)
        }
    }
    
    @IBAction func clickBtnPaper(_ sender: UIButton) {
        isClickedPaper = !isClickedPaper
        if isClickedPaper {
            btnPaper.setImage(UIImage(named: "paperTrashcan"), for: .normal)
        } else{
            btnPaper.setImage(UIImage(named: "wbPaper"), for: .normal)
        }
    }
    @IBAction func clickBtnPlastic(_ sender: UIButton) {
        isClickedPlastic = !isClickedPlastic
        if isClickedPlastic {
            btnPlastic.setImage(UIImage(named: "plasticTrashcan"), for: .normal)
        } else{
            btnPlastic.setImage(UIImage(named: "wbPlastic"), for: .normal)
        }
    }
    
}

