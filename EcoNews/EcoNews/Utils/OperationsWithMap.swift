//
//  OperationsWithMap.swift
//  EcoHelper
//
//  Created by Никита Ткаченко on 09.05.2021.
//

import Foundation
import MapKit
import FloatingPanel
import UIKit
class OperationsWithMap{
    
    static func zoomRegionOnMap(latitude: Double, longitude: Double, map:  MKMapView, zoom: Double){
        let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let region = MKCoordinateRegion(center: location, latitudinalMeters: zoom, longitudinalMeters: zoom)
        map.setRegion(region, animated: true)
    }
    
    static func changeAppearanceFloatingPanel(fpc: FloatingPanelController){
        fpc.layout = MyFloatingPanelLayout()
        let appearance = SurfaceAppearance()
        appearance.cornerRadius = 20.0
        fpc.surfaceView.appearance = appearance
        fpc.surfaceView.contentPadding = .init(top: 50, left: 0, bottom: 10, right: 0)
    }
    
    
}
