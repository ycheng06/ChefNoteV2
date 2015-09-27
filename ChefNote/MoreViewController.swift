//
//  MoreViewController.swift
//  ChefNote
//
//  Created by Jason Cheng on 9/20/15.
//  Copyright (c) 2015 Jason. All rights reserved.
//

import UIKit
import Parse
import ParseFacebookUtilsV4

class MoreViewController: UIViewController {
    @IBOutlet weak var logoutButton: UIButton!

    @IBAction func logout(sender: UIButton) {
        var logoutButton = sender
        logoutButton.enabled = false
        
        PFUser.logOut()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if PFUser.currentUser() != nil {
            logoutButton.enabled = true
        }
        else {
            logoutButton.enabled = false
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
