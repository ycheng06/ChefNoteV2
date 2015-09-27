//
//  NewMemberViewController.swift
//  ChefNote
//
//  Created by Jason Cheng on 9/19/15.
//  Copyright (c) 2015 Jason. All rights reserved.
//

import UIKit


class NewMemberViewController: UIViewController {
    var containerViewController:ContainerViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        println("new member view controller view did load")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signupWithFB(sender: AnyObject) {

//        PFFacebookUtils.logInWithPermissionsInBackground(permissions){
//            (user: PFUser?, error: NSError?) -> Void in
//        
//        }
//        PFFacebookUtils.logInWithPermissions(["email"], block: {
//            (user: PFUser?, error: NSError?) -> Void in
//            println("what is goin on")
//            if let user = user {
//                if user.isNew {
//                    println("User signed up and logged in through Facebook!")
//                    self.containerViewController?.swapViewControllers()
//                } else {
//                    println("User logged in through Facebook!")
//                }
//                
//            } else {
//                println("Uh oh. The user cancelled the Facebook login.")
//            }
//        })
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
