//
//  ImageCardTableViewCell.swift
//  ChefNote
//
//  Created by Jason Cheng on 8/9/15.
//  Copyright (c) 2015 Jason. All rights reserved.
//

import UIKit

class ImageCardTableViewCell: UITableViewCell {

    @IBOutlet weak var recipePublisherLabel: UILabel!
    @IBOutlet weak var recipeTitleLabel: UILabel!
    @IBOutlet weak var recipeImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
