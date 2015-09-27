//
//  ContainerViewController.swift
//  ChefNote
//
//  Created by Jason Cheng on 9/19/15.
//  Copyright (c) 2015 Jason. All rights reserved.
//

import UIKit
import ParseFacebookUtilsV4

class ContainerViewController: UIViewController {
    var currentSegueIdentifier:String!
    let validUserViewIdentifier:String = "ShowSavedRecipes"
    let invalidUserViewIdentifier:String = "SignupFirst"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        println("container view controller view did load")
        // Check if user is valid here
        var currentUser = PFUser.currentUser()
        if currentUser != nil {
            self.performSegueWithIdentifier(validUserViewIdentifier, sender: nil)
            self.currentSegueIdentifier = self.validUserViewIdentifier
        }
        else {
            self.performSegueWithIdentifier(self.invalidUserViewIdentifier, sender: nil)
            self.currentSegueIdentifier = self.invalidUserViewIdentifier
        }
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
        
        if segue.identifier == self.invalidUserViewIdentifier {
            let destinationController = segue.destinationViewController as! NewMemberViewController
            destinationController.containerViewController = self
            
            // if there's something in the container view already
            if self.childViewControllers.count > 0 {
                let fromViewController = self.childViewControllers[0] as! UIViewController
                self.swapFromViewController(fromViewController, toViewController: segue.destinationViewController as! UIViewController)
            }
            else {
                // add the controller to container
                self.addChildViewController(destinationController)
                // add the view
                self.view.addSubview(destinationController.view)
                // assign the parent
                destinationController.didMoveToParentViewController(self)
            }
        }
        else if segue.identifier == self.validUserViewIdentifier {
            let destinationController = segue.destinationViewController as! UIViewController
            
            let fromViewController = self.childViewControllers[0] as! UIViewController
            self.swapFromViewController(fromViewController, toViewController: destinationController)
        }
    }
    
    // remove fromViewController from container view and add the toViewController
    private func swapFromViewController(fromViewController:UIViewController, toViewController:UIViewController){
        
        fromViewController.willMoveToParentViewController(nil)
        self.addChildViewController(toViewController)

        self.transitionFromViewController(fromViewController, toViewController: toViewController, duration: 1.0, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: nil, completion: {
                Bool -> Void in
                // after transition remove old view controller
                fromViewController.removeFromParentViewController()
            
                // assign parent for the new view controller
                toViewController.didMoveToParentViewController(self)
            })
    }
    
    func swapViewControllers(){
        self.currentSegueIdentifier = (self.currentSegueIdentifier == invalidUserViewIdentifier) ? validUserViewIdentifier : invalidUserViewIdentifier
        
        self.performSegueWithIdentifier(self.currentSegueIdentifier, sender: nil)
    }

}
