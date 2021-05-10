//
//  MarkersLocation.swift
//  EcoHelper
//
//  Created by Никита Ткаченко on 25.04.2021.
//

import Foundation

import MapKit

class MarkersLocation: NSObject, MKAnnotation{
    static var allMarkers: [MKAnnotation] = [] 
    internal var coordinate: CLLocationCoordinate2D
    internal var title: String?
    internal var image: String?
    internal var subtitle: String?
    internal var glass: Bool
    internal var metall: Bool
    internal var paper: Bool
    internal var plastic: Bool
    internal var throwingTrash: Bool = false
    
    init(latitude: Double, longitude: Double, adress: String, image: String,
         title: String, glass: Bool, metall: Bool, paper: Bool, plastic: Bool){
        self.title = title
        self.image = image
        self.subtitle = adress
        self.glass = glass
        self.metall = metall
        self.paper = paper
        self.plastic = plastic
        coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
}
