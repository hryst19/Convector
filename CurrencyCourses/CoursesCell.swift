//
//  CoursesCell.swift
//  CurrencyCourses
//
//  Created by hryst on 7/25/19.
//  Copyright © 2019 Anton Mikliayev. All rights reserved.
//

import UIKit

class CoursesCell: UITableViewCell {

    
    
    @IBOutlet weak var imageFlag: UIImageView!
    @IBOutlet weak var labelCurrencyName: UILabel!
    @IBOutlet weak var labelCourse: UILabel!
    
    func initCell(currency: Currency) {
       imageFlag.image = currency.imagesFlag
        labelCurrencyName.text = currency.Name
        labelCourse.text = currency.Rate
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
