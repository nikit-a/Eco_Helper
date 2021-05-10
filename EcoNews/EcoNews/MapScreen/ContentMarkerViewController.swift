//
//  ContentMarkerViewController.swift
//  EcoHelper
//
//  Created by Никита Ткаченко on 29.04.2021.
//

import UIKit
import FloatingPanel
import MapKit
import FirebaseStorage
import FirebaseFirestore
class ContentMarkerViewController: UIViewController {
    private let constNameDirectory = "imagesTrashcans/"
    private var fpc: FloatingPanelController?
    internal var currentTrashcan: MarkersLocation!
    private let defaults = UserDefaults.standard
    private var favouriteTrashcans: FavouriteTrashcans?
    private var mapView: MKMapView?
    private var direction: MKDirections?
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var btnRoute: CustomButtonFavourite!
    @IBOutlet weak var btnFavourite: UIButton!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var imgPlastic: UIImageView!
    @IBOutlet weak var imgPaper: UIImageView!
    @IBOutlet weak var imgMetall: UIImageView!
    @IBOutlet weak var imgGlass: UIImageView!
    @IBOutlet weak var imageTrashcan: UIImageView!
    @IBOutlet weak var btnThrowTrash: UIButton!
    @IBAction func closeInfoMarker(_ sender: UIButton) {
        fpc?.hide()
    }
    
       override func viewDidLoad() {
        super.viewDidLoad()
        btnFavourite.layer.cornerRadius = 8
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
       scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 200)
    }
    
    
    @IBAction func clickBtnFavourite(_ sender: UIButton) {
        btnFavourite.backgroundColor = UIColor(red: 255 / 255.0, green: 149 / 255.0, blue: 0 / 255.0, alpha: 1)
        btnFavourite.setTitle("Добавлено!", for: .normal)
        btnFavourite.isEnabled = false
        favouriteTrashcans?.addFavouriteTrashcansInSet(address: currentTrashcan?.subtitle ?? "", title: currentTrashcan?.title ?? "", plastic: currentTrashcan?.plastic ?? false, metall: currentTrashcan?.metall ?? false, glass: currentTrashcan?.glass ?? false, paper: currentTrashcan?.paper ?? false, latitude: currentTrashcan?.coordinate.latitude ?? 0, longitude: currentTrashcan?.coordinate.longitude ?? 0)
        
    }

    @IBAction func clickBtnRoute(_ sender: CustomButtonFavourite) {
        direction?.calculate { (response, error) in
            // наш маршрут
            guard let response = response else { return }
            for route in response.routes{
                // Строим маршрут на карте по ломанной линии
                self.mapView?.addOverlay(route.polyline)
            }
        }
        fpc?.hide()
    }
    
    func initDetailsContent(floatPanel: FloatingPanelController, trashcan: MarkersLocation,
                            favTrashcans: FavouriteTrashcans){
        fpc = floatPanel
        currentTrashcan = trashcan
        favouriteTrashcans = favTrashcans
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let stringImage: String = currentTrashcan.image ?? ""
        if(stringImage == ""){
            self.imageTrashcan.image = UIImage(named: "defaultTrashcanImage")
        } else{
            let islandRef = storageRef.child(constNameDirectory + stringImage)
            islandRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
                if error != nil {
                    
                } else {
                   
                    self.imageTrashcan.image = UIImage(data: data!)
                    
                }
            }
        }
    }
    
    func initRoute(map: MKMapView, dir: MKDirections){
        mapView = map
        direction = dir
    }
    
}
