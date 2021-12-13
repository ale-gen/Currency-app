//
//  CurrencyCell.swift
//  CurrencyApp
//
//  Created by Aleksandra Generowicz on 13/12/2021.
//

import UIKit

class CurrencyCell: UITableViewCell {

    @IBOutlet weak var codeLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var midLabel: UILabel!
    @IBOutlet weak var bgView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureSubviews()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func configureSubviews() {
        bgView.layer.cornerRadius = 15
        codeLabel.layer.cornerRadius = 10
        codeLabel.numberOfLines = 2
    }
    
}
