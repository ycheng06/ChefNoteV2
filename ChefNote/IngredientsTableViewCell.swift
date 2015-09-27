//
//  IngredientsTableViewCell.swift
//  ChefNote
//
//  Created by Jason Cheng on 8/15/15.
//  Copyright (c) 2015 Jason. All rights reserved.
//

import UIKit

class IngredientsTableViewCell: UITableViewCell {

    @IBOutlet weak var ingredientsListLabel: UILabel!
    @IBOutlet weak var yieldLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
