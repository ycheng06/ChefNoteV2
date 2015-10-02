//
//  DiscoverCollectionViewCell.swift
//  ChefNote
//
//  Created by Jason Cheng on 8/1/15.
//  Copyright (c) 2015 Jason. All rights reserved.
//

import UIKit

class DiscoverCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var publisherLabel: UILabel!
    @IBOutlet weak var itemsRequiredLabel: UILabel!
    @IBOutlet weak var totalTimeLabel: UILabel!
    @IBOutlet weak var recipeNameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageLoadingIndicator: UIActivityIndicatorView!
    var saveButtonCallback:((UIButton)->Void)?
    
    @IBAction func saveButtonClicked(sender: UIButton) {
        if let callback = saveButtonCallback {
            callback(sender)
        }
    }

}
