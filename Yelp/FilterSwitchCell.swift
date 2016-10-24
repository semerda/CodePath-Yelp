//
//  FiltersSwitchCell.swift
//  Yelp
//
//  Created by Ernest on 10/20/16.
//  Copyright © 2016 Purpleblue Pty Ltd. All rights reserved.
//

import UIKit

protocol FilterSwitchCellDelegate: class {
    func preferenceSwitchCellDidToggle(cell: FilterSwitchCell, newValue:Bool)
}

class FilterSwitchCell: UITableViewCell {
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var onOffSwitch: SevenSwitch!
    
    weak var delegate: FilterSwitchCellDelegate?
    
    var prefRowIdentifier: PrefRowIdentifier! {
        didSet {
            descriptionLabel?.text = prefRowIdentifier?.rawValue
        }
    }
    
    @IBAction func didToggleSwitch(sender: AnyObject) {
        delegate?.preferenceSwitchCellDidToggle(cell: self, newValue: onOffSwitch.isOn())
    }
}
