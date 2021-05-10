//
//  FavouriteTrashcans.swift
//  EcoHelper
//
//  Created by Никита Ткаченко on 02.05.2021.
//

import Foundation
struct KeysDefaults {
    static let keyLatitude = "latitude"
    static let keyLongitude = "longitude"
    static let keyAddress = "address"
    static let keyTitle = "title"
    static let keyPlastic = "plastic"
    static let keyPaper = "paper"
    static let keyMetall = "metall"
    static let keyGlass = "glass"
}
class FavouriteTrashcans {
    internal var addresses: [String]
    internal var titles: [String]
    internal var plastics: [Bool]
    internal var papers: [Bool]
    internal var metalls: [Bool]
    internal var glasses: [Bool]
    internal var latitudes: [Double]
    internal var longitudes: [Double]
    private let defaults = UserDefaults.standard
    init() {
        addresses = defaults.stringArray(forKey: KeysDefaults.keyAddress) ?? []
        titles = defaults.stringArray(forKey: KeysDefaults.keyTitle) ?? []
        plastics = defaults.array(forKey: KeysDefaults.keyPlastic) as? [Bool] ?? []
        papers = defaults.array(forKey: KeysDefaults.keyPaper) as? [Bool] ?? []
        metalls = defaults.array(forKey: KeysDefaults.keyMetall) as? [Bool] ?? []
        glasses = defaults.array(forKey: KeysDefaults.keyGlass) as? [Bool] ?? []
        latitudes = defaults.array(forKey: KeysDefaults.keyLatitude) as? [Double] ?? []
        longitudes = defaults.array(forKey: KeysDefaults.keyLongitude) as? [Double] ?? []
    }
    
    func addFavouriteTrashcansInSet(address: String, title: String, plastic: Bool,
                                    metall: Bool, glass: Bool, paper: Bool,
                                    latitude: Double, longitude: Double){
        // определять уникальность по координатам и контейнсом
        if !latitudes.contains(latitude) && !longitudes.contains(longitude){
            addresses.append(address)
            titles.append(title)
            plastics.append(plastic)
            papers.append(paper)
            metalls.append(metall)
            glasses.append(glass)
            latitudes.append(latitude)
            longitudes.append(longitude)
        }
        defaults.set(addresses, forKey: KeysDefaults.keyAddress)
        defaults.set(titles, forKey: KeysDefaults.keyTitle)
        defaults.set(latitudes, forKey: KeysDefaults.keyLatitude)
        defaults.set(longitudes, forKey: KeysDefaults.keyLongitude)
        defaults.set(glasses, forKey: KeysDefaults.keyGlass)
        defaults.set(metalls, forKey: KeysDefaults.keyMetall)
        defaults.set(papers, forKey: KeysDefaults.keyPaper)
        defaults.set(plastics, forKey: KeysDefaults.keyPlastic)
        
    }
    
    func getFavouriteAddresses()->[String]{
        return self.addresses
    }
    
    func getFavouriteTitles()->[String]{
        return self.titles
    }
    
    func getFavouritePlastics()->[Bool]{
        return self.plastics
    }
    func getFavouritePapers()->[Bool]{
        return self.papers
    }
    func getFavouriteMetalls()->[Bool]{
        return self.metalls
    }
    func getFavouriteGlasses()->[Bool]{
        return self.glasses
    }
    func getFavouriteLatitudes()->[Double]{
        return self.latitudes
    }
    func getFavouriteLongitudes()->[Double]{
        return self.longitudes
    }

}
