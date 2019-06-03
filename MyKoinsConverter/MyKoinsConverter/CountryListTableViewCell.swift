//
//  CountryListTableViewCell.swift
//  MyKoinsConverter
//
//  Created by Antoine Proux on 28/05/2019.
//  Copyright © 2019 Antoine Proux. All rights reserved.
//

import UIKit

class CountryListTableViewCell: UITableViewCell {

    
    @IBOutlet weak var countryFlagImageView: UIImageView!
    @IBOutlet weak var countryNameLabel: UILabel!
    @IBOutlet weak var countryCheckBoxImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
