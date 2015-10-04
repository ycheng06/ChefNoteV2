//
//  SavedRecipesViewController.swift
//  ChefNote
//
//  Created by Jason Cheng on 9/18/15.
//  Copyright (c) 2015 Jason. All rights reserved.
//

import UIKit
import Parse
import Alamofire
import SwiftyJSON

class SavedRecipesViewController: UIViewController, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    private var savedRecipes:[JSON] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func queryForSavedRecipes() -> Void {
        if let user = PFUser.currentUser(){
            let query = PFQuery(className: "AllRecipe")
            query.whereKey("createdBy", equalTo: user)
            query.fromLocalDatastore()
            query.findObjectsInBackgroundWithBlock{
                (objects: [PFObject]?, error: NSError?) -> Void in
                
                // get the ids
                let object = objects![0]
                let ids:[String] = object["recipeIds"] as! [String]
                
                // and request recipe info from recipe server 
                let parameters = [
                    "recipeIds": ids
                ]
                let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                
                // Post request to api
                Alamofire.request(.POST, appDelegate.host + "api/v1.0/recipe/recipes", parameters: parameters)
                    .responseJSON{ req, res, result in
                        switch result {
                        case .Success:
                            var json:JSON = JSON(result.value!)
                            
                            // get recipes and reload collection view
                            self.savedRecipes = json["result"].arrayValue
                            self.collectionView.reloadData()
                            
                            break
                        case .Failure:
                            NSLog("UpdateRecipe GET Error: \(result.error)")
                            break
                        }
                }
            }
        }
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.savedRecipes.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! DiscoverCollectionViewCell
        
        return cell
    }

    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
    }
}
