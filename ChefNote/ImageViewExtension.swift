//
//  ImageViewExtension.swift
//  ChefNote
//
//  Created by Jason Cheng on 8/7/15.
//  Copyright (c) 2015 Jason. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    // Load image asynchronously fro an URL.
    public func imageFromUrl(urlString: String) {
        if let url = NSURL(string: urlString) {
            let request = NSURLRequest(URL: url)
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {
                (response: NSURLResponse?, data: NSData?, error: NSError?) -> Void in
                self.image = UIImage(data: data!)
            }
        }
    }
}