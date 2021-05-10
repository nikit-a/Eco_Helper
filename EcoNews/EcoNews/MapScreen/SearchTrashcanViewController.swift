//
//  SearchTrashcanViewController.swift
//  EcoHelper
//
//  Created by Никита Ткаченко on 04.05.2021.
//

import UIKit
import MapKit
class SearchTrashcanViewController: UITableViewController {
    
    private let searchController = UISearchController(searchResultsController: nil)
    private let reuseIdentifier = "Cell"
    private var categories = MarkersLocation.allMarkers
    private var filterTrashcans:[MKAnnotation] = []
    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    private var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"

        navigationItem.searchController = searchController
      //  navigationItem.searchController = searchController
        definesPresentationContext = true
        
    }

}
// MARK: - Navigation



extension SearchTrashcanViewController{
    
    //
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filterTrashcans.count
        }
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier,for: indexPath)
        let trashcan: MKAnnotation
        if isFiltering {
            trashcan = filterTrashcans[indexPath.row]
        } else {
            trashcan = categories[indexPath.row]
        }
        cell.textLabel?.text = trashcan.subtitle ?? "Title"
        cell.detailTextLabel?.text = trashcan.title ?? "Subtitle"
        return cell
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let trashcan: MKAnnotation
             let detailVC = segue.destination as! DetailSearchViewController
                
                if isFiltering {
                    trashcan = filterTrashcans[indexPath.row]
                    for case let item in categories {
                        if item.coordinate.latitude == trashcan.coordinate.latitude &&
                            item.coordinate.longitude == trashcan.coordinate.longitude{
                          detailVC.trashcan = item as? MarkersLocation
                            break
                        }
                    }
                } else {
                    trashcan = categories[indexPath.row]
                    detailVC.trashcan = trashcan as? MarkersLocation
                }
            
            }
        }
    }
}

extension SearchTrashcanViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    private func filterContentForSearchText(_ searchText: String) {
        filterTrashcans = categories.filter({(trashcan: MKAnnotation) -> Bool in
            guard let str = trashcan.subtitle else {return false}
            return str!.lowercased().contains(searchText.lowercased())
        })
        tableView.reloadData()
    }
    

}
