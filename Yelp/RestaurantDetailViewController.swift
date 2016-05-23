//
//  RestaurantDetailViewController.swift
//  RestaurantFinder
//
//  Created by Ashish Mishra on 5/21/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit
import CoreData

class RestaurantDetailViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{
    var businesses: [Business] = NSArray() as! [Business]
    var currentIndex : Int = 0;
    var managedContext : NSManagedObjectContext?
    var currentBusiness : Business?
    var favoritesDetails : [Restaurant] = NSArray() as! [Restaurant]
    var isComingFromfavorites : Bool = false
    var currentfavorite: Restaurant?
    
    @IBOutlet var collectionView :UICollectionView!
    @IBOutlet var favoriteButton : UIButton!
    
    override func viewDidLoad() {
        let appDelegate : AppDelegate =  UIApplication.sharedApplication().delegate as! AppDelegate
        self.managedContext = appDelegate.managedContext
        
        if isComingFromfavorites {
            self.currentfavorite = self.favoritesDetails[currentIndex]
        }else {
            self.currentBusiness = self.businesses[currentIndex]
        }
        
        self.arrangefavoriteButton();
        
}
    
    func arrangefavoriteButton() {
        
        if isComingFromfavorites {
            self.favoriteButton.setImage(UIImage(named: "download1.jpeg"), forState: UIControlState.Normal)
        } else {
        let isAlreadyPresent = self.isAlreadyMarked(self.currentBusiness!).isPresent
        
        if isAlreadyPresent{
            self.favoriteButton.setImage(UIImage(named: "download1.jpeg"), forState: UIControlState.Normal)
            
        } else {
            self.favoriteButton.setImage(UIImage(named: "download.png"), forState: UIControlState.Normal)
            
        }
        }
    }
    
    @IBAction func addRemoveFavorite(sender : UIButton) {
        
        if isComingFromfavorites {
            self.removeRestaurant(self.currentfavorite!)
            self.favoritesDetails.removeAtIndex(self.currentIndex)
            self.collectionView.reloadData()
            
        } else {
            let currentRestaurant = self.businesses[currentIndex] as? Business
            
            let isMarked = self.isAlreadyMarked(currentRestaurant!).isPresent
            
            if isMarked{
                
                self.favoriteButton.setImage(UIImage(named: "download.png"), forState: UIControlState.Normal)
                
                //            self.favoriteButton.imageView?.image = UIImage(named: "download.png")!
                
                let retreivedRestaurant = self.isAlreadyMarked(currentRestaurant!).restaurantBusiness! as Restaurant
                self.removeRestaurant(retreivedRestaurant)
            } else {
                self.favoriteButton.setImage(UIImage(named: "download1.jpeg"), forState: UIControlState.Normal)
                
                //            self.favoriteButton.imageView?.image = UIImage(named: "download1.jpeg")!
                
                self.saveRestaurant(currentRestaurant!)
                
            }
        }
        
}
    
    func saveRestaurant(restaurant : Business) {
        
        let entity = NSEntityDescription.insertNewObjectForEntityForName("Restaurant", inManagedObjectContext: self.managedContext!) as! Restaurant
        entity.setValue(restaurant.name, forKey: "name")
        entity.setValue(restaurant.address, forKey: "address")
        entity.setValue(restaurant.imageURL?.absoluteString, forKey: "imageUrl")
        entity.setValue(restaurant.ratingImageURL?.absoluteString, forKey: "ratingurl")
        
        do {
           try self.managedContext!.save()
        } catch {
            fatalError("Failure to save context: \(error)")
         }
        
    }
    
    func removeRestaurant(restaurant : Restaurant) {
        let savedRestaurant = NSFetchRequest(entityName: "Restaurant")
        
        do {
             self.managedContext!.deleteObject(restaurant as NSManagedObject)
            try self.managedContext!.save()
            
        } catch {
            fatalError("Failed to fetch person: \(error)")
        }
    }
    
    func isAlreadyMarked(restaurant : Business) -> (isPresent : Bool, restaurantBusiness : Restaurant?) {
        let request = NSFetchRequest(entityName: "Restaurant")
        request.returnsObjectsAsFaults = false;
        
        let resultPredicate1 = NSPredicate(format: "name = %@", restaurant.name!)
        
        let compound = NSCompoundPredicate(andPredicateWithSubpredicates:[resultPredicate1])
        request.predicate = compound
        
        
        do {
            let fetchedPerson = try self.managedContext!.executeFetchRequest(request) as! [Restaurant]
            
            if fetchedPerson.count > 0 {
                return (true, fetchedPerson.first);
            }
            
        } catch {
            fatalError("Failed to fetch person: \(error)")
        }
        
        return (false,nil);
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var count : Int = 0;
        if isComingFromfavorites {
             count  =  self.favoritesDetails.count
        } else {
             count =  self.businesses.count

        }
        return count;
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1;
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        if isComingFromfavorites {
            self.currentIndex = indexPath.item
            self.currentfavorite = self.favoritesDetails[currentIndex]
            self.currentIndex = indexPath.item
            self.arrangefavoriteButton();

        } else {
            
            self.currentBusiness = self.businesses[indexPath.item];
            self.arrangefavoriteButton();
            self.currentIndex = indexPath.item
        }
    
        
        let cell: DetailViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("DetailViewcell", forIndexPath: indexPath) as! DetailViewCell
        
        if isComingFromfavorites {
            let business = self.favoritesDetails[indexPath.item]
            cell.restaurantname.text = business.name!
            //        cell.snippetText.text = business.!
            cell.rating.setImageWithURL(NSURL(string: business.ratingurl!)!)
            cell.reviewsCount.text = "\(business.reviewcount!)"
            cell.addressLabel.text = business.address!

        } else {
            let business = self.businesses[indexPath.item]
            cell.restaurantname.text = business.name!
            //        cell.snippetText.text = business.!
            cell.rating.setImageWithURL(business.ratingImageURL!)
            cell.reviewsCount.text = "\(business.reviewCount!)"
            cell.addressLabel.text = business.address!

        }
        
//        cell.restaurantImage.image
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat{
        return 1
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat{
        return 1
    }
    
}
