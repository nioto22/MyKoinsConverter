//
//  CurrencyTableViewCell.swift
//  MyKoinsConverter
//
//  Created by Antoine Proux on 27/05/2019.
//  Copyright © 2019 Antoine Proux. All rights reserved.
//

import UIKit

class CurrencyTableViewCell: UITableViewCell {

    // MARK: - Outlets
    
    
    @IBOutlet weak var currencyNameLabel: UILabel!
    
    @IBOutlet weak var upDownIcon: UIImageView!
    
    @IBOutlet weak var progressValuesLabel: UILabel!
    
    @IBOutlet weak var convertValueLabel: UILabel!
    
    @IBOutlet weak var rateValueLabel: UILabel!

    @IBOutlet weak var flagIconImageView: UIImageView!
    
    
    // MARK: - UITableViewCell methods
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
