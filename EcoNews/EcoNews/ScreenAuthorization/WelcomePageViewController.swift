//
//  WelcowPageViewController.swift
//  EcoNews
//
//  Created by Ткаченко Никита on 07.11.2020.
//

import UIKit
import Firebase
import FirebaseStorage


class WelcomePageViewController: UIViewController {
    @IBOutlet weak var imageTest: UIImageView!
    @IBOutlet weak var labelEco: UILabel!
    @IBOutlet weak var buttonForAuthprize: UIButton!
    @IBOutlet weak var buttonForSignUp: UIButton!
    private var ref: DatabaseReference!
    override func viewDidLoad() {
        super.viewDidLoad()
        assignbackground()
        findValuesAndAddMarker()
    }
    func findValuesAndAddMarker(){
        ref = Database.database().reference()
        ref.child("markers").observe(.value) { snapshot in
            for case let child as DataSnapshot in snapshot.children.allObjects {
                let markerValues = child.value as? [String: Any]
                let markerAdress: String = markerValues?["adress"] as? String ?? ""
                let markerImage: String = markerValues?["image"] as? String ?? ""
                let markerTitle: String = markerValues?["title"] as? String ?? ""
                let markerLatitude: Double = Double(markerValues?["latitude"] as? String ?? "") ?? 0
                let markerLongitude: Double = Double(markerValues?["longitude"] as? String ?? "") ?? 0
                let markerGlass: Bool = markerValues?["glass"] as? Bool ?? false
                let markerMetall: Bool = markerValues?["metall"] as? Bool ?? false
                let markerPaper: Bool = markerValues?["paper"] as? Bool ?? false
                let markerPlastic: Bool = markerValues?["plastic"] as? Bool ?? false
                let marker = MarkersLocation(latitude: markerLatitude, longitude: markerLongitude, adress: markerAdress, image: markerImage, title: markerTitle, glass: markerGlass, metall: markerMetall, paper: markerPaper, plastic: markerPlastic)
                MarkersLocation.allMarkers.append(marker)
            }
        }
    }
    
    func assignbackground(){
        let imageView = OperationsWithView.changeImageView(nameBackground: "backGround.png", view: view)
        self.view.sendSubviewToBack(imageView)
        self.labelEco.backgroundColor = #colorLiteral(red: 0.5869942904, green: 0.4428036809, blue: 0.5852294564, alpha: 1).withAlphaComponent(0.5)
        self.buttonForAuthprize.backgroundColor = #colorLiteral(red: 0.5870402455, green: 0.4427049458, blue: 0.5894571543, alpha: 1).withAlphaComponent(0.7)
        self.buttonForSignUp.backgroundColor = #colorLiteral(red: 0.5870402455, green: 0.4427049458, blue: 0.5894571543, alpha: 1).withAlphaComponent(0.7)
    }
    
    
    @IBAction func buttonAuthorize(_ sender: Any) {
        present(OperationsWithController.initVC(nameVC: "Authorization", identifier: "AuthID"), animated: true, completion: nil)
    }
    
    
    @IBAction func buttonSignIn(_ sender: Any) {
        present(OperationsWithController.initVC(nameVC: "Registration", identifier: "SignUpID"), animated: true, completion: nil)
    }
}


