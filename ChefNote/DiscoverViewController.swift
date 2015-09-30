//
//  FirstViewController.swift
//  ChefNote
//
//  Created by Jason Cheng on 8/1/15.
//  Copyright (c) 2015 Jason. All rights reserved.
//

import UIKit
import CollectionViewWaterfallLayout
import Alamofire
import SwiftyJSON
import AVFoundation

class DiscoverViewController: UIViewController, UICollectionViewDataSource, UISearchResultsUpdating, UISearchBarDelegate {
//    CollectionViewWaterfallLayoutDelegate
    @IBOutlet var collectionView: UICollectionView!
    
    private var currentPage:Int = 1
    private var recipes:[JSON] = [] // discovering recipe
    private var searchedRecipes:[JSON] = [] // recipes from keyword search

    private var refreshControl:UIRefreshControl = UIRefreshControl()
    private var searchController:UISearchController!
    private var searchTimer:NSTimer?
    
    private var imageCache:[String:UIImage] = [String:UIImage]()
    
    private var activityIndicatorContainer:UIView?
    
    @IBOutlet weak var searchBarPlaceholder: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Discover"

        if let layout = collectionView?.collectionViewLayout as? PinterestLayout {
            layout.delegate = self
        }
        
        // Initialize search controller
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.searchBar.sizeToFit()
        searchController.searchBar.delegate = self
        self.definesPresentationContext = true
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        collectionView.addSubview(searchController.searchBar)
        
        // Pull To Refresh Control
        self.refreshControl.backgroundColor = UIColor.whiteColor()
        self.refreshControl.tintColor = UIColor.grayColor()
        self.refreshControl.addTarget(self, action: "updateRecipe", forControlEvents:
            UIControlEvents.ValueChanged)
        self.collectionView.addSubview(self.refreshControl)
        
        showActivityIndicatory(self.view)
        updateRecipe()
    }
    
    func showActivityIndicatory(uiView: UIView) {
        self.activityIndicatorContainer = UIView()
        self.activityIndicatorContainer!.frame = uiView.frame
        self.activityIndicatorContainer!.center = uiView.center
        
        // add a transparent background
        let loadingView: UIView = UIView()
        loadingView.frame = CGRectMake(0, 0, 80, 80)
        loadingView.center = uiView.center
        loadingView.backgroundColor = UIColor.darkGrayColor().colorWithAlphaComponent(0.7)
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10
        
        // add the activity indicator
        let actInd: UIActivityIndicatorView = UIActivityIndicatorView()
        actInd.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
        actInd.activityIndicatorViewStyle =
            UIActivityIndicatorViewStyle.WhiteLarge
        actInd.center = CGPointMake(loadingView.frame.size.width / 2,
            loadingView.frame.size.height / 2);
        loadingView.addSubview(actInd)
        
        // add views to super view
        self.activityIndicatorContainer!.addSubview(loadingView)
        uiView.addSubview(self.activityIndicatorContainer!)
        actInd.startAnimating()
    }
    
    func hideActivityIndicator(){
        self.activityIndicatorContainer?.removeFromSuperview()
        self.activityIndicatorContainer = nil
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateRecipe() -> Void {
        updateRecipe(self.currentPage)
    }

    // Make request to api and retrieve recipes
    func updateRecipe(pageNumber:Int) -> Void {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

        Alamofire.request(.GET, appDelegate.host + "api/v1.0/discover?page=\(pageNumber)")
            .responseJSON{ req, res, result in
                switch result {
                case .Success:
                    var results:JSON = JSON(result.value!)
                    
                    self.currentPage = results["page"].intValue // Change the next page variable
                    self.recipes += results["recipes"].arrayValue // Add recipes to local storage
                    self.collectionView.reloadData()
                    self.refreshControl.endRefreshing()
                    
                    self.hideActivityIndicator()

                    break
                case .Failure:
                    NSLog("GET Error: \(result.error)")
                    break
                }
        }
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Use total items from different data source if search controller is active
        return (searchController.active) ? self.searchedRecipes.count : self.recipes.count
    }
    
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {

        // detect scroll to the bottom, so need to make another request to api for more recipes
        print(indexPath.item)
        if indexPath.item == self.recipes.count - 1{
//            print(indexPath.item)
            // Update only if search is not active
            if !searchController.active {
                updateRecipe(self.currentPage + 1)
            }
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! DiscoverCollectionViewCell
        cell.imageView.image = nil
        cell.recipeNameLabel.text = ""
        cell.totalTimeLabel.text = ""
        cell.publisherLabel.text = ""

        let row = indexPath.row
        var recipe:JSON = nil

        // decide which data source to use depending on if search bar is active
        if searchController.active && self.searchedRecipes.count > 0 {
            recipe = self.searchedRecipes[row]
        }
        else{
            recipe = self.recipes[row]
        }
        
        // ------- Start populating cell data ---------------
        let basicInfo:[String: JSON] = recipe["basic"].dictionaryValue
        
        if let photoURLString:String = basicInfo["photo"]?.string {
            if let image = self.imageCache[photoURLString] {
                cell.imageView.image = image
            }
            else {
                cell.imageLoadingIndicator.hidden = false
                cell.imageLoadingIndicator.startAnimating()
                
                if let url = NSURL(string: photoURLString){
                    let request = NSURLRequest(URL: url)
                    
                    // load image from url asynchronously
                    NSURLConnection.sendAsynchronousRequest(request, queue:
                        // actions to perform in the main queue after image has been loaded
                        NSOperationQueue.mainQueue()) {
                        (response: NSURLResponse?, data: NSData?, error: NSError?) -> Void in
                            // convert downloaded data into image
                            if let downloadedImage = data {
                                let image = UIImage(data:downloadedImage)
                                
                                // cache it
                                self.imageCache[photoURLString] = image
                                
                                cell.imageLoadingIndicator.stopAnimating()
                                cell.imageLoadingIndicator.hidden = true
                                cell.imageView.image = image
                            }
                            
                            if let downloadedError = error {
                                print(downloadedError)
                            }
                    }
                }
                
            }
            
        }
        
        if let publisher:String = basicInfo["publisher"]?.string {
            cell.publisherLabel.text = publisher
        }
        
        if let totalTime:String = basicInfo["totalTime"]?.string {
            cell.totalTimeLabel.text = totalTime
            cell.totalTimeLabel.hidden = false
        } else {
            cell.totalTimeLabel.hidden = true
        }
        
//        if let yield:String = basicInfo["yield"]?.string {
//
//        }
        
        if let title:String = basicInfo["title"]?.string {
            cell.recipeNameLabel.text = title
        }
        
        return cell
    }
    
    // MARK: Search result
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        let searchText = searchController.searchBar.text
        
        // Remove and set a timer whenever the search bar is updated
        searchTimer?.invalidate()
        // Wait till the user stopped typing to initiate the search
        searchTimer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: Selector("searchRecipe:"), userInfo: searchText, repeats: false)
    }
    
    func searchRecipe(timer: NSTimer) -> Void{
        let searchText:String = timer.userInfo as! String
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        if (searchText != "") {
            Alamofire.request(.GET, appDelegate.host + "api/v1.0/search?keyword=\(searchText)")
                .responseJSON{ (req, res, result) in
                    switch result {
                    case .Success(let json):
                        var results:JSON = JSON(json)
                        
                        self.searchedRecipes = results["recipes"].arrayValue
                        self.collectionView.reloadData()
                        
                        break
                    case .Failure( _, let error):
                        NSLog("GET Error: \(error)")
                        break
                    }
            }
        }
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        // Make collection view reload data when search is canceled
        self.collectionView.reloadData()
    }
    
    // MARK: navigation preparation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showRecipeDetailView" {
            let destinationViewController = segue.destinationViewController as! RecipeDetailTableViewController
            
            // Get the selected index path
            let indexPaths:[NSIndexPath] = self.collectionView.indexPathsForSelectedItems()! as [NSIndexPath]
            let indexPath = indexPaths[0]
            var recipe:JSON = nil
            
            // Use different data source for search
            recipe = (searchController.active) ? self.searchedRecipes[indexPath.row] : self.recipes[indexPath.row]

            // Get the recipe Id
            let recipeId = recipe["_id"].stringValue
            destinationViewController.recipeId = recipeId
            
            let basicInfo:[String: JSON] = recipe["basic"].dictionaryValue
            
            if let photo:String = basicInfo["photo"]?.string {
                destinationViewController.photo = photo
            }
            
            if let publisher:String = basicInfo["publisher"]?.string {
                destinationViewController.publisher = publisher
            }
            
            if let title:String = basicInfo["title"]?.string {
                destinationViewController.recipeTitle = title
            }
            
            
            //            if let totalTime:String = recipe["totalTime"].string {
            //                cell.totalTimeLabel.text = totalTime
            //                cell.totalTimeLabel.hidden = false
            //            } else {
            //                cell.totalTimeLabel.hidden = true
            //            }
            //
            //            if let yield:String = recipe["yield"].string {
            //                
            //            }
            

        }
    }
}

extension DiscoverViewController : PinterestLayoutDelegate {
    func collectionView(collectionView: UICollectionView, heightForItemAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return CGFloat(220)
    }
}


