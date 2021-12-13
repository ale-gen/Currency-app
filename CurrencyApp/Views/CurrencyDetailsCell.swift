//
//  CurrencyDetailsCell.swift
//  CurrencyApp
//
//  Created by Aleksandra Generowicz on 13/12/2021.
//

import UIKit

class CurrencyDetailsCell: UITableViewCell {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var midLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        bgView.layer.cornerRadius = 15
        dateLabel.layer.cornerRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
