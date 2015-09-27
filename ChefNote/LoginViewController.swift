//
//  LoginViewController.swift
//  ChefNote
//
//  Created by Jason Cheng on 9/20/15.
//  Copyright (c) 2015 Jason. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var emailAddressLabel: UITextField!
    @IBOutlet weak var passwordLabel: UITextField!
    
    @IBAction func cancelLogin(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func loginWithFB(sender: UIButton) {
        var loginButton:UIButton = sender
        loginButton.enabled = false
        
//        PFFacebookUtils.logInWithPermissions(["public_profile", "email"], block: {
//            (user: PFUser?, error: NSError?) -> Void in
//            if let user = user {
//                if user.isNew {
//                    println("User signed up and logged in through Facebook!")
//                } else {
//                    println("User logged in through Facebook!")
//                    self.dismissViewControllerAnimated(true, completion: nil)
//                }
//                
//            } else {
//                println("Uh oh. The user cancelled the Facebook login.")
//            }
//            
//            loginButton.enabled = true
//        })

    }
    
    @IBAction func loginWithEmail(sender: UIButton) {
        var loginButton = sender
        loginButton.enabled = false
        
        var email = emailAddressLabel.text
        var password = passwordLabel.text
        
        if !isEmpty(email) && !isEmpty(password) {
//            PFUser.logInWithUsernameInBackground("myname", password:"mypass") {
//                (user: PFUser?, error: NSError?) -> Void in
//                if user != nil {
//                    // Do stuff after successful login.
//                    self.dismissViewControllerAnimated(true, completion: nil)
//                } else {
//                    // The login failed. Check error to see why.
//                }
//                loginButton.enabled = true
//            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
