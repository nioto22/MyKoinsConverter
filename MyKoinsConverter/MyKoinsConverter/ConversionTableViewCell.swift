//
//  ConversionTableViewCell.swift
//  MyKoinsConverter
//
//  Created by Antoine Proux on 29/05/2019.
//  Copyright © 2019 Antoine Proux. All rights reserved.
//

import UIKit

class ConversionTableViewCell: UITableViewCell {

    

    @IBOutlet weak var refConversionLabel: UILabel!
    
    @IBOutlet weak var resultConversionLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
