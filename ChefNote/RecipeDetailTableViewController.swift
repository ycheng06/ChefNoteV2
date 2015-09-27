//
//  RecipeDetailTableViewController.swift
//  ChefNote
//
//  Created by Jason Cheng on 8/9/15.
//  Copyright (c) 2015 Jason. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class RecipeDetailTableViewController: UITableViewController {

    var recipeId:String!
    var photo:String!
    var recipeTitle:String!
    var publisher:String!
    
    private var recipe:JSON = nil
    private var yield:String = ""
    private var ingredients:[JSON] = []
    private var directions:[JSON] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        self.tableView.estimatedRowHeight = 317
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        loadRecipeDetail()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadRecipeDetail() -> Void {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        Alamofire.request(.GET, appDelegate.host + "api/v1.0/recipe/\(self.recipeId)")
            .responseJSON{(req, res, json, error) in
                if error != nil {
                    NSLog("GET Error: \(error)")
                }
                else {
                    var data:JSON = JSON(json!)
                    let result:[String:JSON] = data["result"].dictionaryValue
                    
                    if let yield:String = result["yield"]?.string {
                        self.yield = yield
                    }
                    
                    self.ingredients = result["ingredients"]!.arrayValue
                    self.directions = result["directions"]!.arrayValue

                    self.tableView.reloadData()
                }
            }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    
        // try to find out how many lines did the label took and increase the size of the roll
        var height:CGFloat = CGFloat(0)
        
        switch indexPath.row {
        case 0:
            height = 350
        case 1:
            height = CGFloat(self.ingredients.count * 2 + 316)
        case 2:
            height = CGFloat(self.directions.count * 5 + 316)
        default:
            height = 316
        }
        
        return height
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return 3
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            var cell = tableView.dequeueReusableCellWithIdentifier("imageCardCell", forIndexPath: indexPath) as! ImageCardTableViewCell
            cell.recipeImageView.image = nil
            cell.recipeImageView.imageFromUrl(self.photo)
            cell.recipeTitleLabel.text = self.recipeTitle
            cell.recipePublisherLabel.text = self.publisher
            
            return cell
        }
        // Set up cell for ingredients
        else if indexPath.row == 1 {
            var cell = tableView.dequeueReusableCellWithIdentifier("ingredientsCardCell", forIndexPath: indexPath) as! IngredientsTableViewCell
            
            var ingredientLabel:String = ""
            for ingredientJSON in self.ingredients {
                var ingredient = ingredientJSON.stringValue
                
                ingredientLabel += "\(ingredient) \n\n"
            }
            
            cell.ingredientsListLabel.text = ingredientLabel
            
            if self.yield != "" {
                cell.yieldLabel.text = self.yield
                cell.yieldLabel.hidden = false
            }
            else {
                cell.yieldLabel.hidden = true
            }
            
            return cell
        }
        // Set up cell for directions
        else if indexPath.row == 2 {
            var cell = tableView.dequeueReusableCellWithIdentifier("directionsCardCell", forIndexPath: indexPath) as! DirectionsTableViewCell
            
            var directionLabel:String = ""
            var number:Int = 1
            
            for directionJSON in self.directions {
                var direction = directionJSON.stringValue
                
                directionLabel += "\(number) \(direction) \n\n"
                number++
            }
            
            cell.directionsListLabel.text = directionLabel
            
            return cell
        }
        else {
            var cell = tableView.dequeueReusableCellWithIdentifier("directionsCardCell", forIndexPath: indexPath) as! DirectionsTableViewCell
            return cell
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
