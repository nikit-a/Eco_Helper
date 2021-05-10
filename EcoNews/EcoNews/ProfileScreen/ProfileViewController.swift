//
//  ProfileViewController.swift
//  EcoNews
//
//  Created by Никита Ткаченко on 07.11.2020.
//

import UIKit
import Firebase
import FirebaseStorage
class ProfileViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var firstName: UILabel!
    @IBOutlet weak var secondName: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var imageUser: UIImageView!
    private let constNameDirectory = "avatars/"
    private let reuseIdentifier = "Cell"
    private var titlesTable: [String] = []
    private var subtitlesTable: [String] = []
    private var ratingTable: [Int] = []
    override func viewDidLoad() {
        self.tableView.backgroundColor = .clear
        self.tableView.delegate = self
        self.tableView.dataSource = self
        super.viewDidLoad()
        assignbackground()
        let defaults = UserDefaults.standard
        self.secondName.text = defaults.value(forKey: "secondNameUser") as? String
        self.firstName.text = defaults.value(forKey: "firstNameUser") as? String
        self.email.text = defaults.value(forKey: "emailUser") as? String
        guard let userUID = defaults.value(forKey: "userUID") as? String else { return }
        let islandRef = Storage.storage().reference().child(constNameDirectory + userUID)
        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
        islandRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if error != nil {
            
          } else {
            let image = UIImage(data: data!)
            self.imageUser.layer.borderWidth = 1
            self.imageUser.layer.masksToBounds = false
            self.imageUser.layer.borderColor = UIColor.black.cgColor
            self.imageUser.layer.cornerRadius = self.imageUser.frame.height/2
            self.imageUser.clipsToBounds = true
            self.imageUser.image = image
            
          }
        }
        
        let db = Firestore.firestore()
        db.collection("ecoUsers").addSnapshotListener { documentSnapshot, error in
            guard let document = documentSnapshot else {
                print("Error fetching document: \(error!)")
                return
            }
            guard let documents: [QueryDocumentSnapshot]? = document.documents else {
                print("Document data was empty.")
                return
            }
            self.titlesTable = []
            self.subtitlesTable = []
            self.ratingTable = []
            for document in documents!{
                let secondName: String = document.data()["secondName"] as! String
                let firstName: String = document.data()["firstName"] as! String
                self.titlesTable.append(secondName + " " + firstName)
                self.subtitlesTable.append(document.data()["email"] as! String)
                self.ratingTable.append(document.data()["rating"] as! Int)
            }
            self.tableView.reloadData()
        }
    }
    
    func assignbackground(){
       let imageView = OperationsWithView.changeImageView(nameBackground: "ecoProfile", view: view)
        self.view.sendSubviewToBack(imageView)
    }

}
extension ProfileViewController: UITableViewDataSource, UITableViewDelegate{
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titlesTable.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier,for: indexPath)
        cell.backgroundColor = .clear
        if ratingTable.count > 1{
            simpleInserts(masRate: &ratingTable, titles: &titlesTable, subtitles: &subtitlesTable)
        }
        ratingTable.reverse()
        titlesTable.reverse()
        subtitlesTable.reverse()
        cell.textLabel?.text = titlesTable[indexPath.row] + "   " + String(ratingTable[indexPath.row]) + " points"
        cell.textLabel?.textColor = UIColor(red: 52 / 255.0, green: 199 / 255.0, blue: 89 / 255.0, alpha: 1)
        cell.textLabel?.font = UIFont.systemFont(ofSize: 16.0)
        cell.detailTextLabel?.text = subtitlesTable[indexPath.row]
        cell.detailTextLabel?.textColor = UIColor(red: 52 / 255.0, green: 199 / 255.0, blue: 89 / 255.0, alpha: 1)
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 16.0)
        return cell
    }
    
    func simpleInserts(masRate: inout [Int], titles: inout [String], subtitles: inout [String]){
        for i in 1...masRate.count-1{
            let b: Int = masRate[i]
            let c: String = titles[i]
            let d: String = subtitles[i]
            var j: Int = i - 1
            while j >= 0 && b <= masRate[j]  {
                masRate[j + 1] = masRate[j]
                titles[j + 1] = titles[j]
                subtitles[j + 1] = subtitles[j]
                j -= 1
            }
            masRate[j + 1] = b
            titles[j + 1] = c
            subtitles[j + 1] = d
        }
    }
    
    
    
//    func quickSort( masRate: inout [Int], indexFirst: Int, indexLast: Int){
//        var i: Int = indexFirst
//        var j: Int = indexLast
//        let k: Int = (i + j) / 2
//        let pivot: Int = masRate[k]
//        repeat {
//            while (masRate[i] < pivot) {
//                i += 1
//            }
//            while (masRate[j] > pivot) {
//                j -= 1
//            }
//            if (i <= j) {
//                // свапаем так как нашли элемент >= выбранному слева и <= выбранному справа
//                masRate.swapAt(i, j)
//
//                i += 1
//                j -= 1
//            }
//            // пока один индекс не прошел другой
//        } while (i <= j)
//        if (indexFirst < j) {
//            // вызываем рекурсивно на левой части массива
//            quickSort(masRate: &masRate, indexFirst: indexFirst, indexLast: j)
//        }
//        if (indexLast > i) {
//            // вызываем рекурсивно на правой части массива
//            quickSort(masRate: &masRate, indexFirst: i, indexLast: indexLast)
//        }
//    }

}
