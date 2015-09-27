//
//  SavedRecipesViewController.swift
//  ChefNote
//
//  Created by Jason Cheng on 9/18/15.
//  Copyright (c) 2015 Jason. All rights reserved.
//

import UIKit

class SavedRecipesViewController: UIViewController {
    var containerViewController:UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Saved Recipes"

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "EmbedContainer" {
            self.containerViewController = segue.destinationViewController as! ContainerViewController
        }
    }


}
