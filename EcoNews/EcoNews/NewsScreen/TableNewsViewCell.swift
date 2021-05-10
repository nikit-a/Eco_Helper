//
//  TableViewCell.swift
//  EcoNews
//
//  Created by Никита Ткаченко on 10.01.2021.
//

import UIKit
import SafariServices
class TableNewsViewCell: UITableViewCell {

    @IBOutlet weak var imageCell: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelText: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
