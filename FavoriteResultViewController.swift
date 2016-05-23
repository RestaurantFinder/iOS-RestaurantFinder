//
//  FavoriteResultViewController.swift
//  Yelp
//
//  Created by Ashish Mishra on 5/22/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit
import CoreData

class FavoriteResultViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var favoriteTableView : UITableView!
    var favoriteResults : NSArray = NSArray()
    var managedContext : NSManagedObjectContext?

    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate : AppDelegate =  UIApplication.sharedApplication().delegate as! AppDelegate
        self.managedContext = appDelegate.managedContext
        

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        self.retrieveResultForFavorite()

    }
    
    func retrieveResultForFavorite() {
        let personFetch = NSFetchRequest(entityName: "Restaurant")
        
        do {
            self.favoriteResults = try self.managedContext!.executeFetchRequest(personFetch) as! [Restaurant]
            
        } catch {
            fatalError("Failed to fetch person: \(error)")
        }
        self.favoriteTableView.reloadData()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.favoriteResults.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier: String = "YelpDataCell"
        
        let cell: RestuarantSearchCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as! RestuarantSearchCell
        
        let cellData: Restaurant = self.favoriteResults[indexPath.row] as! Restaurant
        
        var imageUrl = cellData.imageUrl!
//        let url : NSURL = NSURL(string: cellData.valueForKey("imageURL") as! String)!
        cell.restImage?.setImageWithURL(NSURL(string: imageUrl)!)
        cell.restName?.text = cellData.name!
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("FavoriteDetail", sender: indexPath);
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "FavoriteDetail") {
            
            let destinationViewController = segue.destinationViewController as! RestaurantDetailViewController
            destinationViewController.isComingFromfavorites = true
            destinationViewController.favoritesDetails = self.favoriteResults as! [Restaurant]
            let currentIndex = sender as? NSIndexPath
            destinationViewController.currentIndex = (currentIndex?.row)!
        }
    }

}
