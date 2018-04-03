//
//  RateItemCell.swift
//  RatesViewer
//
//  Created by Алексей Киселев on 29/03/2018.
//  Copyright © 2018 Aleksei Kiselev. All rights reserved.
//

import UIKit

class RateItemCell: UITableViewCell {

    @IBOutlet var flagImageView: UIImageView!
    @IBOutlet var currencyCodeLabel: UILabel!
    @IBOutlet var currencyDescriptionLabel: UILabel!
    @IBOutlet var rateValueTextField: UITextField!
    @IBOutlet var rateValueUnderline: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        rateValueTextField.isEnabled = selected
        if selected {
            rateValueTextField.becomeFirstResponder()
            rateValueUnderline.backgroundColor = .blue
        } else {
            rateValueTextField.resignFirstResponder()
            rateValueUnderline.backgroundColor = .lightGray
        }
    }

}

extension RateItemCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.setSelected(false, animated: true)
    }
}
