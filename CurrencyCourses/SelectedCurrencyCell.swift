//
//  SelectedCurrencyCell.swift
//  CurrencyCourses
//
//  Created by hryst on 7/29/19.
//  Copyright © 2019 Anton Mikliayev. All rights reserved.
//

import UIKit

class SelectedCurrencyCell: UITableViewCell {

    
    
    
    @IBOutlet weak var imageFlagSelected: UIImageView!
    
    @IBOutlet weak var labelSelectedCurrency: UILabel!
    
    func initSelectedCell(currency: Currency)  {
        imageFlagSelected.image = currency.imagesFlag
        labelSelectedCurrency.text = currency.Name
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
